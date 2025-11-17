enum SqlColumnAffinity {
  text,
  numeric,
  boolean,
  datetime,
  blob,
  unknown,
}

class SqlTableColumnSchema {
  const SqlTableColumnSchema({
    required this.name,
    required this.affinity,
    this.declaration,
  });

  final String name;
  final SqlColumnAffinity affinity;
  final String? declaration;
}

class SqlTableSchema {
  SqlTableSchema({
    required this.name,
    required Map<String, SqlTableColumnSchema> columns,
  }) : columns = Map.unmodifiable(
          columns.map(
            (key, value) => MapEntry(key.toLowerCase(), value),
          ),
        );

  final String name;
  final Map<String, SqlTableColumnSchema> columns;

  SqlTableColumnSchema? column(String columnName) {
    return columns[columnName.toLowerCase()];
  }
}

class SqlSchemaSnapshot {
  SqlSchemaSnapshot({required Map<String, SqlTableSchema> tables})
    : tables = Map.unmodifiable(
        tables.map((key, value) => MapEntry(key.toLowerCase(), value)),
      );

  const SqlSchemaSnapshot._empty() : tables = const {};

  factory SqlSchemaSnapshot.empty() => const SqlSchemaSnapshot._empty();

  final Map<String, SqlTableSchema> tables;

  bool get isEmpty => tables.isEmpty;

  SqlTableSchema? table(String tableName) {
    return tables[tableName.toLowerCase()];
  }

  SqlTableColumnSchema? column(String tableName, String columnName) {
    final SqlTableSchema? table = this.table(tableName);
    if (table == null) {
      return null;
    }
    return table.column(columnName);
  }
}

SqlColumnAffinity inferSqlColumnAffinity(String? declaration) {
  if (declaration == null) {
    return SqlColumnAffinity.unknown;
  }
  final String trimmed = declaration.trim();
  if (trimmed.isEmpty) {
    return SqlColumnAffinity.unknown;
  }
  final String upper = trimmed.toUpperCase();
  if (upper.contains('CHAR') || upper.contains('CLOB') || upper.contains('TEXT')) {
    return SqlColumnAffinity.text;
  }
  if (upper.contains('BLOB')) {
    return SqlColumnAffinity.blob;
  }
  if (upper.contains('BOOL')) {
    return SqlColumnAffinity.boolean;
  }
  if (upper.contains('DATE') || upper.contains('TIME')) {
    return SqlColumnAffinity.datetime;
  }
  if (upper.contains('REAL') || upper.contains('FLOA') || upper.contains('DOUB')) {
    return SqlColumnAffinity.numeric;
  }
  if (upper.contains('INT')) {
    return SqlColumnAffinity.numeric;
  }
  if (upper.contains('DEC') || upper.contains('NUM')) {
    return SqlColumnAffinity.numeric;
  }
  return SqlColumnAffinity.unknown;
}

String describeSqlColumnAffinity(SqlColumnAffinity affinity) {
  switch (affinity) {
    case SqlColumnAffinity.text:
      return 'a TEXT';
    case SqlColumnAffinity.numeric:
      return 'a NUMERIC';
    case SqlColumnAffinity.boolean:
      return 'a BOOLEAN';
    case SqlColumnAffinity.datetime:
      return 'a DATETIME';
    case SqlColumnAffinity.blob:
      return 'a BLOB';
    case SqlColumnAffinity.unknown:
      return 'an unknown';
  }
}

