import 'dart:async';

import 'package:d99_learn_data_enginnering/src/common/widgets/sql_parser/schema.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sqflite;

/// Provides a lightweight client-side SQLite database for interactive query demos.
class LocalSqlDatabase {
  LocalSqlDatabase._();

  static final LocalSqlDatabase instance = LocalSqlDatabase._();
  static const int _schemaVersion = 1;

  sqflite.Database? _database;
  Completer<void>? _initCompleter;
  String? _databasePath;
  SqlSchemaSnapshot? _cachedSchema;

  /// Lazily opens the on-device database and seeds it with starter data.
  Future<void> ensureInitialized({bool forceReset = false}) async {
    final Completer<void>? inFlight = _initCompleter;
    if (inFlight != null && !inFlight.isCompleted) {
      await inFlight.future;
    }

    if (forceReset) {
      await _resetDatabase();
    } else if (_database != null) {
      return;
    }

    if (_database != null) {
      return;
    }

    if (_initCompleter != null && !_initCompleter!.isCompleted) {
      return _initCompleter!.future;
    }

    final completer = Completer<void>();
    _initCompleter = completer;

    try {
      final String dbPath = await _resolveDatabasePath();

      _database = await sqflite.openDatabase(
        dbPath,
        version: _schemaVersion,
        onCreate: (sqflite.Database db, int version) async {
          await _createSchema(db);
        },
      );

      await _seedInitialData(_database!);
      completer.complete();
    } catch (error, stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError(error, stackTrace);
      }
      rethrow;
    } finally {
      if (_initCompleter == completer) {
        _initCompleter = null;
      }
    }
  }

  Future<SqlExecutionResult> execute(String sql) async {
    await ensureInitialized();
    final sqflite.Database db = _database!;

    final String normalized = sql.trim();
    if (normalized.isEmpty) {
      return SqlExecutionResult(error: 'SQL statement is empty.');
    }

    final String command = _extractCommand(normalized);

    try {
      switch (command) {
        case 'SELECT':
        case 'WITH':
          final List<Map<String, Object?>> rows = await db.rawQuery(normalized);
          return SqlExecutionResult(
            rows: rows,
            message: 'Returned ${rows.length} row(s).',
          );
        case 'INSERT':
          final int rowId = await db.rawInsert(normalized);
          return SqlExecutionResult(
            message: 'Insert succeeded (rowid $rowId).',
          );
        case 'UPDATE':
          final int count = await db.rawUpdate(normalized);
          return SqlExecutionResult(message: 'Update affected $count row(s).');
        case 'DELETE':
          final int count = await db.rawDelete(normalized);
          return SqlExecutionResult(message: 'Delete affected $count row(s).');
        default:
          await db.execute(normalized);
          return const SqlExecutionResult(
            message: 'Statement executed successfully.',
          );
      }
    } on Object catch (error) {
      final String friendly = _formatDatabaseError(error, sql: normalized);
      return SqlExecutionResult(error: friendly);
    }
  }

  Future<SqlSchemaSnapshot> describeSchema({bool refresh = false}) async {
    await ensureInitialized();
    if (!refresh && _cachedSchema != null) {
      return _cachedSchema!;
    }

    final sqflite.Database db = _database!;
    final List<Map<String, Object?>> tableRows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );

    final Map<String, SqlTableSchema> tableSchemas = <String, SqlTableSchema>{};

    for (final Map<String, Object?> row in tableRows) {
      final String? tableName = row['name'] as String?;
      if (tableName == null || tableName.trim().isEmpty) {
        continue;
      }

      final List<Map<String, Object?>> columnRows = await db.rawQuery(
        'PRAGMA table_info(${_quoteIdentifier(tableName)})',
      );

      if (columnRows.isEmpty) {
        continue;
      }

      final Map<String, SqlTableColumnSchema> columns =
          <String, SqlTableColumnSchema>{};

      for (final Map<String, Object?> column in columnRows) {
        final String? columnName = column['name'] as String?;
        if (columnName == null || columnName.trim().isEmpty) {
          continue;
        }
        final String? declaration = column['type'] as String?;
        final SqlColumnAffinity affinity = inferSqlColumnAffinity(declaration);

        columns[columnName.toLowerCase()] = SqlTableColumnSchema(
          name: columnName,
          affinity: affinity,
          declaration: declaration,
        );
      }

      if (columns.isEmpty) {
        continue;
      }

      tableSchemas[tableName.toLowerCase()] = SqlTableSchema(
        name: tableName,
        columns: columns,
      );
    }

    final SqlSchemaSnapshot snapshot = SqlSchemaSnapshot(tables: tableSchemas);
    _cachedSchema = snapshot;
    return snapshot;
  }

  Future<void> _resetDatabase() async {
    final sqflite.Database? existing = _database;
    if (existing != null && existing.isOpen) {
      await existing.close();
    }
    _database = null;
    _cachedSchema = null;

    final String dbPath = await _resolveDatabasePath();
    await sqflite.deleteDatabase(dbPath);
    _initCompleter = null;
    _databasePath = null;
  }

  Future<String> _resolveDatabasePath() async {
    if (_databasePath != null) {
      return _databasePath!;
    }
    final String basePath = await sqflite.getDatabasesPath();
    final String dbPath = p.join(basePath, 'data_app_client.db');
    _databasePath = dbPath;
    return dbPath;
  }

  Future<void> _createSchema(sqflite.Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    try {
      await db.execute('PRAGMA strict = ON');
    } on Object catch (error) {
      if (!_isStrictUnsupported(error)) {
        rethrow;
      }
    }

    await _createTableWithStrictFallback(
      db,
      'orders',
      '''order_id INTEGER PRIMARY KEY AUTOINCREMENT,
            status TEXT NOT NULL,
            region TEXT NOT NULL,
            profit REAL NOT NULL DEFAULT 0''',
    );

    await _createTableWithStrictFallback(
      db,
      'customers',
      '''customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT NOT NULL,
            last_name TEXT NOT NULL,
            country TEXT NOT NULL''',
    );
  }

  Future<void> _seedInitialData(sqflite.Database db) async {
    final int orderCount =
        sqflite.Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM orders'),
        ) ??
        0;
    if (orderCount == 0) {
      final List<Map<String, Object?>> seedOrders = <Map<String, Object?>>[
        <String, Object?>{
          'order_id': 1,
          'status': 'Completed',
          'region': 'US',
          'profit': 1200.50,
        },
        <String, Object?>{
          'order_id': 2,
          'status': 'Pending',
          'region': 'EU',
          'profit': 540.00,
        },
        <String, Object?>{
          'order_id': 3,
          'status': 'Completed',
          'region': 'US',
          'profit': 260.75,
        },
        <String, Object?>{
          'order_id': 4,
          'status': 'Cancelled',
          'region': 'APAC',
          'profit': -100.00,
        },
        <String, Object?>{
          'order_id': 5,
          'status': 'Completed',
          'region': 'US',
          'profit': 875.20,
        },
        <String, Object?>{
          'order_id': 6,
          'status': 'Shipped',
          'region': 'US',
          'profit': 430.10,
        },
        <String, Object?>{
          'order_id': 7,
          'status': 'Processing',
          'region': 'EU',
          'profit': 310.45,
        },
        <String, Object?>{
          'order_id': 8,
          'status': 'Completed',
          'region': 'LATAM',
          'profit': 680.30,
        },
        <String, Object?>{
          'order_id': 9,
          'status': 'Pending',
          'region': 'US',
          'profit': 190.00,
        },
        <String, Object?>{
          'order_id': 10,
          'status': 'Completed',
          'region': 'APAC',
          'profit': 1025.60,
        },
        <String, Object?>{
          'order_id': 11,
          'status': 'Completed',
          'region': 'US',
          'profit': 340.15,
        },
        <String, Object?>{
          'order_id': 12,
          'status': 'Returned',
          'region': 'EU',
          'profit': -45.80,
        },
        <String, Object?>{
          'order_id': 13,
          'status': 'Completed',
          'region': 'MEA',
          'profit': 512.90,
        },
        <String, Object?>{
          'order_id': 14,
          'status': 'Processing',
          'region': 'US',
          'profit': 220.40,
        },
        <String, Object?>{
          'order_id': 15,
          'status': 'On Hold',
          'region': 'LATAM',
          'profit': 0.00,
        },
        <String, Object?>{
          'order_id': 16,
          'status': 'Completed',
          'region': 'US',
          'profit': 1450.00,
        },
        <String, Object?>{
          'order_id': 17,
          'status': 'Completed',
          'region': 'EU',
          'profit': 780.25,
        },
        <String, Object?>{
          'order_id': 18,
          'status': 'Pending',
          'region': 'APAC',
          'profit': 155.70,
        },
        <String, Object?>{
          'order_id': 19,
          'status': 'Completed',
          'region': 'US',
          'profit': 980.55,
        },
        <String, Object?>{
          'order_id': 20,
          'status': 'Cancelled',
          'region': 'EU',
          'profit': -220.10,
        },
        <String, Object?>{
          'order_id': 21,
          'status': 'Processing',
          'region': 'US',
          'profit': 415.95,
        },
        <String, Object?>{
          'order_id': 22,
          'status': 'Completed',
          'region': 'MEA',
          'profit': 605.20,
        },
        <String, Object?>{
          'order_id': 23,
          'status': 'Shipped',
          'region': 'LATAM',
          'profit': 330.80,
        },
        <String, Object?>{
          'order_id': 24,
          'status': 'Completed',
          'region': 'US',
          'profit': 720.00,
        },
        <String, Object?>{
          'order_id': 25,
          'status': 'Pending',
          'region': 'EU',
          'profit': 88.40,
        },
        <String, Object?>{
          'order_id': 26,
          'status': 'Completed',
          'region': 'APAC',
          'profit': 540.60,
        },
        <String, Object?>{
          'order_id': 27,
          'status': 'Completed',
          'region': 'US',
          'profit': 1230.75,
        },
        <String, Object?>{
          'order_id': 28,
          'status': 'Processing',
          'region': 'MEA',
          'profit': 270.30,
        },
        <String, Object?>{
          'order_id': 29,
          'status': 'Completed',
          'region': 'US',
          'profit': 890.90,
        },
        <String, Object?>{
          'order_id': 30,
          'status': 'Returned',
          'region': 'LATAM',
          'profit': -60.25,
        },
      ];

      for (final Map<String, Object?> order in seedOrders) {
        await db.insert('orders', order);
      }
    }

    final int customerCount =
        sqflite.Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM customers'),
        ) ??
        0;
    if (customerCount == 0) {
      final List<Map<String, Object?>> seedCustomers = <Map<String, Object?>>[
        <String, Object?>{
          'customer_id': 1,
          'first_name': 'Jordan',
          'last_name': 'Smith',
          'country': 'United States',
        },
        <String, Object?>{
          'customer_id': 2,
          'first_name': 'Priya',
          'last_name': 'Gupta',
          'country': 'India',
        },
        <String, Object?>{
          'customer_id': 3,
          'first_name': 'Luca',
          'last_name': 'Rossi',
          'country': 'Italy',
        },
        <String, Object?>{
          'customer_id': 4,
          'first_name': 'Ava',
          'last_name': 'Nguyen',
          'country': 'Vietnam',
        },
        <String, Object?>{
          'customer_id': 5,
          'first_name': 'Ethan',
          'last_name': 'Johnson',
          'country': 'United States',
        },
        <String, Object?>{
          'customer_id': 6,
          'first_name': 'Maria',
          'last_name': 'Garcia',
          'country': 'Spain',
        },
        <String, Object?>{
          'customer_id': 7,
          'first_name': 'Chen',
          'last_name': 'Wei',
          'country': 'China',
        },
        <String, Object?>{
          'customer_id': 8,
          'first_name': 'Sofia',
          'last_name': 'Petrova',
          'country': 'Russia',
        },
        <String, Object?>{
          'customer_id': 9,
          'first_name': 'Liam',
          'last_name': 'O\'Connor',
          'country': 'Ireland',
        },
        <String, Object?>{
          'customer_id': 10,
          'first_name': 'Isabella',
          'last_name': 'Martinez',
          'country': 'Mexico',
        },
        <String, Object?>{
          'customer_id': 11,
          'first_name': 'Noah',
          'last_name': 'Brown',
          'country': 'Canada',
        },
        <String, Object?>{
          'customer_id': 12,
          'first_name': 'Mia',
          'last_name': 'Dubois',
          'country': 'France',
        },
        <String, Object?>{
          'customer_id': 13,
          'first_name': 'Oliver',
          'last_name': 'Muller',
          'country': 'Germany',
        },
        <String, Object?>{
          'customer_id': 14,
          'first_name': 'Emma',
          'last_name': 'Andersson',
          'country': 'Sweden',
        },
        <String, Object?>{
          'customer_id': 15,
          'first_name': 'Hiro',
          'last_name': 'Tanaka',
          'country': 'Japan',
        },
        <String, Object?>{
          'customer_id': 16,
          'first_name': 'Chloe',
          'last_name': 'Wilson',
          'country': 'Australia',
        },
        <String, Object?>{
          'customer_id': 17,
          'first_name': 'Mateo',
          'last_name': 'Alvarez',
          'country': 'Argentina',
        },
        <String, Object?>{
          'customer_id': 18,
          'first_name': 'Amara',
          'last_name': 'Okafor',
          'country': 'Nigeria',
        },
        <String, Object?>{
          'customer_id': 19,
          'first_name': 'Yusuf',
          'last_name': 'Hassan',
          'country': 'United Arab Emirates',
        },
        <String, Object?>{
          'customer_id': 20,
          'first_name': 'Sara',
          'last_name': 'Cohen',
          'country': 'Israel',
        },
        <String, Object?>{
          'customer_id': 21,
          'first_name': 'Daniel',
          'last_name': 'Petrov',
          'country': 'Bulgaria',
        },
        <String, Object?>{
          'customer_id': 22,
          'first_name': 'Laila',
          'last_name': 'Rahman',
          'country': 'Bangladesh',
        },
        <String, Object?>{
          'customer_id': 23,
          'first_name': 'Benjamin',
          'last_name': 'Lee',
          'country': 'South Korea',
        },
        <String, Object?>{
          'customer_id': 24,
          'first_name': 'Harper',
          'last_name': 'Clark',
          'country': 'United Kingdom',
        },
        <String, Object?>{
          'customer_id': 25,
          'first_name': 'Jonas',
          'last_name': 'Schmidt',
          'country': 'Switzerland',
        },
        <String, Object?>{
          'customer_id': 26,
          'first_name': 'Elena',
          'last_name': 'Popescu',
          'country': 'Romania',
        },
        <String, Object?>{
          'customer_id': 27,
          'first_name': 'Diego',
          'last_name': 'Silva',
          'country': 'Brazil',
        },
        <String, Object?>{
          'customer_id': 28,
          'first_name': 'Valentina',
          'last_name': 'Costa',
          'country': 'Portugal',
        },
        <String, Object?>{
          'customer_id': 29,
          'first_name': 'Maya',
          'last_name': 'Singh',
          'country': 'Singapore',
        },
        <String, Object?>{
          'customer_id': 30,
          'first_name': 'Jacob',
          'last_name': 'Carter',
          'country': 'South Africa',
        },
      ];

      for (final Map<String, Object?> customer in seedCustomers) {
        await db.insert('customers', customer);
      }
    }
  }

  String _extractCommand(String sql) {
    final String trimmed = sql.trimLeft();
    if (trimmed.isEmpty) {
      return '';
    }
    final String firstToken = trimmed.split(RegExp(r'\s+')).first.toUpperCase();
    if (firstToken == 'WITH') {
      // Common table expressions behave like SELECT statements.
      return 'WITH';
    }
    return firstToken;
  }

  String _formatDatabaseError(Object error, {required String sql}) {
    if (error is sqflite.DatabaseException) {
      final String raw = error.toString();
      final String cleaned = _cleanSqliteMessage(raw);
      final _SqlErrorLocation location =
          _inferErrorLocation(rawMessage: raw, sql: sql);
      final String nearSuffix =
          location.token != null ? ' (near "${location.token}")' : '';
      final String header =
          'Query failed: line ${location.line}:${location.column}: $cleaned$nearSuffix';
      return '$header\nSQL: $sql';
    }

    return 'Query failed: ${error.toString()}';
  }

  String _cleanSqliteMessage(String message) {
    String cleaned = message.trim();

    cleaned = cleaned.replaceAll('\n', ' ');

    cleaned = cleaned.replaceFirst(RegExp(r'^DatabaseException:?\s*'), '');
    cleaned = cleaned.replaceFirst(RegExp(r'^Error\s+Domain=[^\s]+\s*'), '');
    cleaned = cleaned.replaceFirst(RegExp(r'^SqfliteDarwinDatabase\s*'), '');

    cleaned = cleaned.replaceAll(RegExp(r'UserInfo=\{.*?\}'), '');
    cleaned = cleaned.replaceAll(RegExp(r'Code=\d+'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\s+args\s*\[[^]]*\]'), '');
    cleaned = cleaned.replaceAll(RegExp(r',?\s*while compiling:.*'), '');
    cleaned = cleaned.replaceAll(RegExp(r',?\s*sql .*'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\(code \d+[^)]*\)'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\[SQLITE_[A-Z_]+\]'), '');

    final Match? quoted = RegExp(r'"([^"\n]+)"').firstMatch(cleaned);
    if (quoted != null) {
      cleaned = quoted.group(1)!;
    }

    final int newline = cleaned.indexOf('\n');
    if (newline >= 0) {
      cleaned = cleaned.substring(0, newline);
    }

    cleaned = cleaned.trim();
    return cleaned.isEmpty ? 'SQL error' : cleaned;
  }

  _SqlErrorLocation _inferErrorLocation({
    required String rawMessage,
    required String sql,
  }) {
    final RegExpMatch? nearMatch =
        RegExp(r'near "([^"]+)"', caseSensitive: false).firstMatch(rawMessage);

    if (nearMatch != null) {
      final String token = nearMatch.group(1)!;
      final int index = sql.toLowerCase().indexOf(token.toLowerCase());
      if (index >= 0) {
        return _SqlErrorLocation.fromIndex(sql, index, token: token);
      }
      return _SqlErrorLocation(line: 1, column: 1, token: token);
    }

    return const _SqlErrorLocation(line: 1, column: 1);
  }

  Future<void> _createTableWithStrictFallback(
    sqflite.Database db,
    String tableName,
    String columns,
  ) async {
    final String strictSql =
        'CREATE TABLE IF NOT EXISTS $tableName ($columns) STRICT';
    try {
      await db.execute(strictSql);
      return;
    } on Object catch (error) {
      if (!_isStrictUnsupported(error)) {
        rethrow;
      }
    }

    await db.execute('CREATE TABLE IF NOT EXISTS $tableName ($columns)');
  }

  bool _isStrictUnsupported(Object error) {
    if (error is sqflite.DatabaseException) {
      final String message = error.toString().toLowerCase();
      return message.contains('near "strict"') ||
          message.contains('unrecognized token: "strict"');
    }
    return false;
  }

  String _quoteIdentifier(String identifier) {
    final String escaped = identifier.replaceAll('"', '""');
    return '"$escaped"';
  }
}

class SqlExecutionResult {
  const SqlExecutionResult({
    this.rows = const <Map<String, Object?>>[],
    this.message,
    this.error,
  });

  final List<Map<String, Object?>> rows;
  final String? message;
  final String? error;

  bool get hasError => error != null;
  bool get hasRows => rows.isNotEmpty;
}

class _SqlErrorLocation {
  const _SqlErrorLocation({required this.line, required this.column, this.token});

  final int line;
  final int column;
  final String? token;

  factory _SqlErrorLocation.fromIndex(
    String sql,
    int index, {
    String? token,
  }) {
    final String priorText = index <= 0 ? '' : sql.substring(0, index);
      final List<String> segments = priorText.split('\n');
    final int lineNumber = segments.length;
    final int columnNumber = (segments.isEmpty ? 0 : segments.last.length) + 1;
    return _SqlErrorLocation(
      line: lineNumber,
      column: columnNumber,
      token: token,
    );
  }
}

