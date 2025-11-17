import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_canvas_token.dart';

/// Represents a serialized line from the Python canvas.
class PythonCanvasLine {
  const PythonCanvasLine({
    required this.rowIndex,
    required this.text,
    required this.tokens,
  });

  final int rowIndex;
  final String text;
  final List<PythonCanvasToken> tokens;

  String get primaryToken => tokens.isEmpty ? '' : tokens.first.label;

  PythonCanvasLine copyWith({String? text}) {
    return PythonCanvasLine(
      rowIndex: rowIndex,
      text: text ?? this.text,
      tokens: tokens,
    );
  }
}

/// Result of serializing a canvas into Python text.
typedef PythonCanvasProjectionMetadata = ({
  List<String> expressions,
  List<String> headers,
});

class PythonCanvasSerializationResult {
  const PythonCanvasSerializationResult({
    required this.python,
    required this.lines,
    this.projections = const (
      expressions: <String>[],
      headers: <String>[],
    ),
  });

  final String python;
  final List<PythonCanvasLine> lines;
  final PythonCanvasProjectionMetadata projections;
}

enum _StatementType {
  none,
  import,
  assignment,
  functionDef,
  controlFlow,
  expression,
  returnStatement,
}

class _StatementMatch {
  const _StatementMatch({required this.type, required this.tokensConsumed});

  final _StatementType type;
  final int tokensConsumed;
}

/// Serializes the canvas rows into raw Python text.
/// 
/// Does lightweight syntax completion (comma insertion, indentation) to make Python parseable,
/// but NO heavy processing (validation, formatting). That happens in PythonProcessor.
class PythonCanvasSerializer {
  static PythonCanvasSerializationResult serialize(
    List<List<PythonCanvasToken>> rows,
  ) {
    final List<PythonCanvasLine> lines = [];
    _StatementType activeStatement = _StatementType.none;
    int statementItemCount = 0;
    bool insideMultiLineExpression = false;
    
    for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      final List<PythonCanvasToken> rawTokens =
          rows[rowIndex]
              .map((token) {
                final String trimmed = token.label.trim();
                if (trimmed.isEmpty) {
                  return null;
                }
                return token.copyWith(label: trimmed);
              })
              .whereType<PythonCanvasToken>()
              .toList();
      
      if (rawTokens.isEmpty) {
        continue;
      }
      
      // Check if this row starts a new statement
      final _StatementMatch? statementMatch = _detectStatement(rawTokens);
      
      if (statementMatch != null) {
        // New statement detected - add it as-is
        final String lineText = _coalesceTokens(rawTokens);
        lines.add(PythonCanvasLine(rowIndex: rowIndex, text: lineText, tokens: rawTokens));
        activeStatement = statementMatch.type;
        statementItemCount = 0;
        insideMultiLineExpression = false;
        continue;
      }
      
      // Check if this row starts a multi-line expression (function call, list, etc.)
      final bool startsMultiLine = _startsMultiLineExpression(rawTokens);
      final bool endsMultiLine = _endsMultiLineExpression(rawTokens);
      
      // Handle comma insertion for list expressions
      if (_statementAllowsList(activeStatement)) {
        // Only add comma if not inside a multi-line expression
        if (!insideMultiLineExpression && statementItemCount > 0 && lines.isNotEmpty) {
          final PythonCanvasLine previous = lines.last;
          lines[lines.length - 1] = previous.copyWith(
            text: '${previous.text},',
          );
        }
        
        if (startsMultiLine) {
          insideMultiLineExpression = true;
        }
        if (endsMultiLine) {
          insideMultiLineExpression = false;
        }
        
        // Only increment count for actual new items (not continuation rows)
        if (!insideMultiLineExpression || startsMultiLine) {
          statementItemCount += 1;
        }
      }
      
      final String lineText = _coalesceTokens(rawTokens);
      lines.add(PythonCanvasLine(rowIndex: rowIndex, text: lineText, tokens: rawTokens));
    }
    
    final String python = lines.map((line) => line.text).join('\n');
    
    return PythonCanvasSerializationResult(
      python: python,
      lines: lines,
      projections: const (
        expressions: <String>[],
        headers: <String>[],
      ),
    );
  }
  

  /// Check if a row starts a multi-line expression (function call, list, etc.)
  static bool _startsMultiLineExpression(List<PythonCanvasToken> tokens) {
    if (tokens.isEmpty) return false;
    final String first = tokens.first.label.toUpperCase();
    return first.contains('(') || first == '[';
  }

  /// Check if a row ends a multi-line expression (closing paren, bracket, etc.)
  static bool _endsMultiLineExpression(List<PythonCanvasToken> tokens) {
    if (tokens.isEmpty) return false;
    return tokens.any((token) {
      final String upper = token.label.toUpperCase();
      return upper == ')' || upper.endsWith(']') || upper.endsWith('}');
    });
  }

  static bool _statementAllowsList(_StatementType type) {
    return type == _StatementType.expression ||
        type == _StatementType.assignment;
  }

  static bool _shouldExplodeSimpleIdentifiers(List<PythonCanvasToken> tokens) {
    if (tokens.length <= 1) {
      return false;
    }

    final bool allSimpleExpressions = tokens.every((token) {
      if (token.kind == PythonCanvasTokenKind.variable) {
        return true;
      }
      if (token.kind == PythonCanvasTokenKind.function) {
        return true;
      }
      if (token.wrappedToken != null) {
        // Treat function-like wrappers uniformly even if the kind wasn't tagged as function.
        return true;
      }
      return false;
    });
    return allSimpleExpressions;
  }

  static _StatementMatch? _detectStatement(List<PythonCanvasToken> tokens) {
    if (tokens.isEmpty) return null;
    final String first = tokens.first.label.toUpperCase();

    if (first == 'IMPORT' || first.startsWith('FROM')) {
      return const _StatementMatch(type: _StatementType.import, tokensConsumed: 1);
    }
    if (first == 'DEF') {
      return const _StatementMatch(type: _StatementType.functionDef, tokensConsumed: 1);
    }
    if (first == 'IF' || first == 'FOR' || first == 'WHILE' || first == 'ELSE' || first == 'ELIF') {
      return const _StatementMatch(type: _StatementType.controlFlow, tokensConsumed: 1);
    }
    if (first == 'RETURN') {
      return const _StatementMatch(type: _StatementType.returnStatement, tokensConsumed: 1);
    }
    // Assignment detection: look for = token
    if (tokens.any((token) => token.label == '=')) {
      return const _StatementMatch(type: _StatementType.assignment, tokensConsumed: 0);
    }

    return null;
  }

  static String _coalesceTokens(List<PythonCanvasToken> tokens) {
    final List<String> parts = [];
    
    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];
      String tokenText;
      
      // If token has a wrapped token (e.g., function with variable inside)
      if (token.wrappedToken != null) {
        // Extract the function name and reconstruct with wrapped token
        // e.g., "print()" becomes "print(value)"
        final String label = token.label;
        final int openParenIndex = label.indexOf('(');
        if (openParenIndex != -1) {
          final String functionName = label.substring(
            0,
            openParenIndex + 1,
          );
          tokenText = '$functionName${token.wrappedToken!.label})';
        } else {
          tokenText = token.label;
        }
      } else {
        tokenText = token.label;
      }
      
      // Add comma between multiple variables/expressions on the same row
      // Check if this token and the previous token are both projection items
      if (i > 0 && _isProjectionToken(tokens[i - 1]) && _isProjectionToken(token)) {
        parts.add(',');
      }
      
      parts.add(tokenText);
    }
    
    return parts.join(' ');
  }
  
  /// Check if a token represents a projection item that should be comma-separated
  static bool _isProjectionToken(PythonCanvasToken token) {
    return token.kind == PythonCanvasTokenKind.variable ||
           token.kind == PythonCanvasTokenKind.function ||
           token.kind == PythonCanvasTokenKind.literal ||
           token.wrappedToken != null;  // Functions wrapping variables
  }
}

/// Result of attempting to format canvas Python using the parser.
class PythonFormattingResult {
  const PythonFormattingResult({
    required this.isValid,
    required this.python,
    this.issues = const <String>[],
    this.handlerError,
  });

  final bool isValid;
  final String python;
  final List<String> issues;
  final String? handlerError;
}

/// Provides formatting and validation by leveraging Python parsing/formatting.
/// For now, this is a placeholder that returns the input as-is.
/// TODO: Integrate with Python formatter when available.
class PythonCanvasFormatter {
  const PythonCanvasFormatter();

  PythonFormattingResult tryFormat(String python) {
    final String trimmed = python.trim();
    if (trimmed.isEmpty) {
      return const PythonFormattingResult(
        isValid: false,
        python: '',
        issues: <String>[],
      );
    }

    // For now, just return the input as-is (no formatting)
    // TODO: Integrate with Python formatter
    return PythonFormattingResult(
      isValid: true,
      python: trimmed,
      issues: const <String>[],
    );
  }
}

/// Normalizes canvas rows to align with formatter expectations for statement items.
class PythonCanvasRowNormalizer {
  static bool normalize(List<List<PythonCanvasToken>> rows) {
    final List<List<PythonCanvasToken>> normalized = _normalizedCopy(rows);
    if (_rowsEqual(rows, normalized)) {
      return false;
    }
    rows
      ..clear()
      ..addAll(
        normalized.map(
          (row) => row.map((token) => token.copyWith()).toList(growable: true),
        ),
      );
    return true;
  }

  static List<List<PythonCanvasToken>> _normalizedCopy(
    List<List<PythonCanvasToken>> rows,
  ) {
    final List<List<PythonCanvasToken>> result = [];
    _StatementType activeStatement = _StatementType.none;
    int? activeStatementRowIndex;
    int sourceRowIndex = 0;

    for (final List<PythonCanvasToken> row in rows) {
      if (row.isEmpty) {
        result.add(<PythonCanvasToken>[]);
        sourceRowIndex++;
        continue;
      }

      final List<PythonCanvasToken> trimmed =
          row
              .map((token) {
                final String trimmedLabel = token.label.trim();
                if (trimmedLabel.isEmpty) {
                  return null;
                }
                return token.copyWith(label: trimmedLabel);
              })
              .whereType<PythonCanvasToken>()
              .toList();
      if (trimmed.isEmpty) {
        result.add(<PythonCanvasToken>[]);
        continue;
      }

      final _StatementMatch? statementMatch = PythonCanvasSerializer._detectStatement(
        trimmed,
      );
      if (statementMatch != null) {
        final bool statementAllowsList = PythonCanvasSerializer._statementAllowsList(
          statementMatch.type,
        );
        final bool splitForListStatement =
            statementAllowsList && trimmed.length > statementMatch.tokensConsumed;

        if (splitForListStatement) {
          final List<PythonCanvasToken> statementTokens = trimmed.sublist(
            0,
            statementMatch.tokensConsumed,
          );
          final List<PythonCanvasToken> remainder = trimmed.sublist(
            statementMatch.tokensConsumed,
          );
          result.add(
            statementTokens
                .map((token) => token.copyWith())
                .toList(growable: true),
          );
          activeStatementRowIndex = result.length - 1;
          if (remainder.isNotEmpty) {
            // Check if the next source row is empty, if so use it instead of creating new row
            final int nextSourceRowIndex = sourceRowIndex + 1;
            final bool hasEmptyNextRow =
                nextSourceRowIndex < rows.length &&
                rows[nextSourceRowIndex].isEmpty;

            if (hasEmptyNextRow) {
              // Use the existing empty row - add it to result
              result.add(<PythonCanvasToken>[]);
              sourceRowIndex++;
            }

            result.add(
              remainder.map((token) => token.copyWith()).toList(growable: true),
            );
          }
        } else {
          result.add(
            trimmed.map((token) => token.copyWith()).toList(growable: true),
          );
          activeStatementRowIndex = result.length - 1;
        }

        activeStatement = statementMatch.type;
        sourceRowIndex++;
        continue;
      }

      final bool canMergeWithActiveStatement =
          activeStatement != _StatementType.none &&
          !PythonCanvasSerializer._statementAllowsList(activeStatement) &&
          activeStatementRowIndex != null &&
          activeStatementRowIndex >= 0 &&
          activeStatementRowIndex < result.length;

      final bool shouldKeepRowSeparate = _shouldKeepRowSeparate(
        activeStatement,
        trimmed,
      );
      final bool shouldMergeWithActiveStatement =
          canMergeWithActiveStatement && !shouldKeepRowSeparate;

      if (shouldMergeWithActiveStatement) {
        result[activeStatementRowIndex].addAll(
          trimmed.map((token) => token.copyWith()),
        );
        sourceRowIndex++;
        continue;
      }

      final bool isListStatement = PythonCanvasSerializer._statementAllowsList(
        activeStatement,
      );
      if (isListStatement &&
          PythonCanvasSerializer._shouldExplodeSimpleIdentifiers(trimmed)) {
        for (final PythonCanvasToken token in trimmed) {
          result.add(<PythonCanvasToken>[token.copyWith()]);
        }
        activeStatementRowIndex = null;
        sourceRowIndex++;
        continue;
      }

      result.add(
        trimmed.map((token) => token.copyWith()).toList(growable: true),
      );
      if (PythonCanvasSerializer._statementAllowsList(activeStatement)) {
        activeStatementRowIndex = null;
      } else {
        activeStatement = _StatementType.none;
        activeStatementRowIndex = null;
      }
      sourceRowIndex++;
    }
    return result;
  }

  static bool _shouldKeepRowSeparate(
    _StatementType activeStatement,
    List<PythonCanvasToken> tokens,
  ) {
    if (tokens.isEmpty) {
      return false;
    }
    final bool tokensAreVariables = tokens.every(
      (token) => token.kind == PythonCanvasTokenKind.variable,
    );
    if (!tokensAreVariables) {
      return false;
    }
    // For Python, we generally keep rows separate
    return false;
  }

  static bool _rowsEqual(
    List<List<PythonCanvasToken>> original,
    List<List<PythonCanvasToken>> normalized,
  ) {
    if (identical(original, normalized)) return true;
    if (original.length != normalized.length) return false;

    for (int i = 0; i < original.length; i++) {
      final List<PythonCanvasToken> a = original[i];
      final List<PythonCanvasToken> b = normalized[i];
      if (a.length != b.length) return false;
      for (int j = 0; j < a.length; j++) {
        if (a[j] != b[j]) {
          return false;
        }
      }
    }
    return true;
  }
}

/// Computes indentation guidance for each canvas row based on formatted Python.
class PythonIndentGuide {
  static List<double> computeIndentLevels(
    int rowCount,
    List<PythonCanvasLine> canvasLines,
    String formattedPython, {
    int indentSize = 4,
  }) {
    if (rowCount == 0) {
      return const [];
    }

    final List<String> formattedLines = formattedPython.split('\n');
    final List<double> indentLevels = List<double>.filled(rowCount, 0);
    int searchStart = 0;

    for (final PythonCanvasLine line in canvasLines) {
      final String primary = line.primaryToken.trim();
      final String lineText = line.text.trim();
      if (primary.isEmpty && lineText.isEmpty) {
        continue;
      }

      for (int i = searchStart; i < formattedLines.length; i++) {
        final String formattedLine = formattedLines[i];
        if (_lineMatchesFormattedLine(
          formattedLine,
          primary,
          lineText,
        )) {
          final int leadingSpaces = _countLeadingSpaces(formattedLine);
          final double level = indentSize > 0 ? leadingSpaces / indentSize : 0;
          if (line.rowIndex >= 0 && line.rowIndex < indentLevels.length) {
            indentLevels[line.rowIndex] = level;
          }
          searchStart = i;
          break;
        }
      }
    }

    return indentLevels;
  }

  static bool _lineMatchesFormattedLine(
    String formattedLine,
    String primaryToken,
    String fullText,
  ) {
    if (formattedLine.isEmpty) {
      return false;
    }

    final String normalizedFormatted = formattedLine.toUpperCase();
    final String collapsedFormatted = _collapseWhitespace(normalizedFormatted);

    final List<String> candidates = <String>[primaryToken, fullText];
    for (final String candidate in candidates) {
      final String normalizedCandidate = candidate.toUpperCase();
      if (normalizedCandidate.isEmpty) {
        continue;
      }
      if (normalizedFormatted.contains(normalizedCandidate)) {
        return true;
      }

      final String collapsedCandidate = _collapseWhitespace(
        normalizedCandidate,
      );
      if (
        collapsedCandidate.isNotEmpty &&
        collapsedFormatted.contains(collapsedCandidate)
      ) {
        return true;
      }
    }
    return false;
  }

  static final RegExp _whitespacePattern = RegExp(r'\s+');

  static String _collapseWhitespace(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value.replaceAll(_whitespacePattern, '');
  }

  static int _countLeadingSpaces(String line) {
    int count = 0;
    while (count < line.length && line[count] == ' ') {
      count += 1;
    }
    return count;
  }
}

