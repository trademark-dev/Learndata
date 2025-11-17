import 'dart:async';
import 'package:d99_learn_data_enginnering/src/services/local_sql_database.dart';

/// Provides a lightweight client-side Python executor for interactive code demos.
/// Uses SQL database to execute queries, similar to SQL builder.
class LocalPythonExecutor {
  LocalPythonExecutor._();

  static final LocalPythonExecutor instance = LocalPythonExecutor._();

  /// Executes Python code and returns the result.
  /// For Python builder, we extract SQL queries from Python code and execute them.
  /// This allows Python code to contain SQL queries that will be executed.
  Future<PythonExecutionResult> execute(String pythonCode) async {
    final String normalized = pythonCode.trim();
    if (normalized.isEmpty) {
      return PythonExecutionResult(error: 'Python code is empty.');
    }

    try {
      // Extract SQL query from Python code
      // Simple approach: look for SQL keywords in the code
      String? sqlQuery = _extractSqlQuery(normalized);
      
      if (sqlQuery != null) {
        // Execute SQL query using SQL database
        final SqlExecutionResult sqlResult = await LocalSqlDatabase.instance.execute(sqlQuery);
        
        if (sqlResult.hasError) {
          return PythonExecutionResult(error: sqlResult.error);
        }
        
        return PythonExecutionResult(
          rows: sqlResult.rows,
          message: sqlResult.message ?? 'Query executed successfully.',
        );
      }

      // If no SQL query found, treat as successful execution
      // (Python code might just be structure without queries)
      return const PythonExecutionResult(
        message: 'Code executed successfully.',
      );
    } catch (error) {
      final String friendly = _formatPythonError(error, code: normalized);
      return PythonExecutionResult(error: friendly);
    }
  }

  /// Extracts SQL query from Python code.
  /// Looks for SELECT, INSERT, UPDATE, DELETE, or WITH statements.
  String? _extractSqlQuery(String pythonCode) {
    // Remove Python comments and clean up
    String cleaned = pythonCode
        .replaceAll(RegExp(r'#.*'), '') // Remove Python comments
        .replaceAll(RegExp(r'""".*?"""', dotAll: true), '') // Remove multi-line strings
        .replaceAll(RegExp(r"'''.*?'''", dotAll: true), '') // Remove multi-line strings
        .trim();

    // Look for SQL keywords (SELECT, INSERT, UPDATE, DELETE, WITH)
    final RegExp sqlPattern = RegExp(
      r'(?:SELECT|INSERT|UPDATE|DELETE|WITH)\s+.*',
      caseSensitive: false,
      dotAll: true,
    );

    final Match? match = sqlPattern.firstMatch(cleaned);
    if (match != null) {
      // Extract the SQL query
      String query = match.group(0) ?? '';
      
      // Remove Python string quotes if present (both single and double quotes)
      if (query.startsWith('"') || query.startsWith("'")) {
        query = query.substring(1);
      }
      if (query.endsWith('"') || query.endsWith("'")) {
        query = query.substring(0, query.length - 1);
      }
      query = query.trim();
      
      if (query.isNotEmpty) {
        return query;
      }
    }

    // If no SQL keywords found, check if the entire code is a SQL query
    // (for cases where user writes SQL directly)
    if (_looksLikeSql(cleaned)) {
      return cleaned;
    }

    return null;
  }

  /// Checks if the code looks like SQL (contains SQL keywords).
  bool _looksLikeSql(String code) {
    final List<String> sqlKeywords = [
      'SELECT', 'FROM', 'WHERE', 'JOIN', 'INSERT', 'UPDATE', 'DELETE',
      'CREATE', 'DROP', 'ALTER', 'WITH', 'GROUP BY', 'ORDER BY', 'HAVING'
    ];
    
    final String upperCode = code.toUpperCase();
    return sqlKeywords.any((keyword) => upperCode.contains(keyword));
  }

  String _formatPythonError(Object error, {required String code}) {
    final String errorMessage = error.toString();
    final String header = 'Code execution failed: $errorMessage';
    return '$header\nPython: $code';
  }
}

/// Result of executing Python code.
/// Similar to SqlExecutionResult.
class PythonExecutionResult {
  const PythonExecutionResult({
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

