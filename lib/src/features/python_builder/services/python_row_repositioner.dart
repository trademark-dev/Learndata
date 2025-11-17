import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_canvas_token.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/services/python_canvas_service.dart';

/// Repositions canvas tiles across rows based on formatted Python line breaks
/// 
/// This implements Python-style formatting where tokens are moved to new rows
/// based on the line breaks in the formatted Python output. Blank rows are preserved.
/// 
/// Special handling for expressions: When multiple variables are on the same
/// canvas row but formatted Python has them on separate lines, they will be split
/// into separate rows.
class PythonRowRepositioner {
  const PythonRowRepositioner();

  /// Reposition tiles based on formatted Python line breaks
  /// 
  /// Takes current canvas rows and formatted Python, returns new canvas rows
  /// where tiles have been moved to match the line breaks in formatted Python.
  /// Preserves existing blank rows.
  /// 
  /// Special case: Expressions with multiple variables on one row will be
  /// split across multiple rows if the formatted Python has them on separate lines.
  List<List<PythonCanvasToken>> reposition(
    List<List<PythonCanvasToken>> currentRows,
    List<PythonCanvasLine> serializedLines,
    String formattedPython,
  ) {
    if (currentRows.isEmpty || formattedPython.trim().isEmpty) {
      return currentRows;
    }

    final List<String> formattedLines = formattedPython.split('\n');
    final List<List<PythonCanvasToken>> newRows = [];

    // Track which canvas row we're processing
    int currentSerializedLineIndex = 0;
    int lastProcessedOriginalRowIndex = -1;

    for (int formattedLineIndex = 0;
        formattedLineIndex < formattedLines.length;
        formattedLineIndex++) {
      final String formattedLine = formattedLines[formattedLineIndex].trim();

      if (formattedLine.isEmpty) {
        newRows.add(<PythonCanvasToken>[]);
        continue;
      }

      // For Python, we handle statements differently than SQL
      // Check if this is a function definition
      if (formattedLine.toUpperCase().startsWith('DEF ') ||
          formattedLine.toUpperCase().startsWith('DEF\t')) {
        // Find the canvas line for DEF
        final PythonCanvasLine? defLine = _findMatchingCanvasLine(
          serializedLines,
          currentSerializedLineIndex,
          'DEF',
        );
        if (defLine != null) {
          // Check if there are blank rows before DEF
          if (lastProcessedOriginalRowIndex >= 0) {
            final int blankRowsInBetween = defLine.rowIndex - lastProcessedOriginalRowIndex - 1;
            for (int i = 0; i < blankRowsInBetween; i++) {
              newRows.add(<PythonCanvasToken>[]);
            }
          }
          lastProcessedOriginalRowIndex = defLine.rowIndex;
          
          newRows.add(List<PythonCanvasToken>.from(defLine.tokens));
          currentSerializedLineIndex++;
        } else {
          newRows.add(<PythonCanvasToken>[]);
        }
        continue;
      }

      // For all other lines, try to find a matching canvas line
      final PythonCanvasLine? line = _findMatchingCanvasLine(
        serializedLines,
        currentSerializedLineIndex,
        formattedLine,
      );

      if (line != null) {
        // Check if there are blank rows between the last processed row and this one
        if (lastProcessedOriginalRowIndex >= 0) {
          final int blankRowsInBetween = line.rowIndex - lastProcessedOriginalRowIndex - 1;
          for (int i = 0; i < blankRowsInBetween; i++) {
            newRows.add(<PythonCanvasToken>[]);
          }
        }
        lastProcessedOriginalRowIndex = line.rowIndex;
        
        newRows.add(List<PythonCanvasToken>.from(line.tokens));
        currentSerializedLineIndex++;
      } else {
        newRows.add(<PythonCanvasToken>[]);
      }
    }

    // Preserve any blank rows that existed at the end
    final int originalBlankRowsAtEnd = _countTrailingBlankRows(currentRows);
    final int newBlankRowsAtEnd = _countTrailingBlankRows(newRows);

    if (originalBlankRowsAtEnd > newBlankRowsAtEnd) {
      final int blanksToAdd = originalBlankRowsAtEnd - newBlankRowsAtEnd;
      for (int i = 0; i < blanksToAdd; i++) {
        newRows.add(<PythonCanvasToken>[]);
      }
    }

    return newRows;
  }

  /// Find a canvas line that matches the formatted line
  PythonCanvasLine? _findMatchingCanvasLine(
    List<PythonCanvasLine> serializedLines,
    int startIndex,
    String formattedLine,
  ) {
    for (int i = startIndex; i < serializedLines.length; i++) {
      final PythonCanvasLine line = serializedLines[i];
      if (_lineMatchesFormattedLine(
        formattedLine,
        line.primaryToken,
        line.text,
      )) {
        return line;
      }
    }
    return null;
  }

  /// Check if a formatted line matches a canvas line
  bool _lineMatchesFormattedLine(
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

      // Check if the formatted line contains the candidate
      if (normalizedFormatted.contains(normalizedCandidate)) {
        return true;
      }

      // Also check with collapsed whitespace
      final String collapsedCandidate =
          _collapseWhitespace(normalizedCandidate);
      if (collapsedCandidate.isNotEmpty &&
          collapsedFormatted.contains(collapsedCandidate)) {
        return true;
      }
    }

    return false;
  }

  /// Collapse all whitespace in a string
  static final RegExp _whitespacePattern = RegExp(r'\s+');

  String _collapseWhitespace(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value.replaceAll(_whitespacePattern, '');
  }

  /// Count how many blank rows exist at the end of a row list
  int _countTrailingBlankRows(List<List<PythonCanvasToken>> rows) {
    int count = 0;
    for (int i = rows.length - 1; i >= 0; i--) {
      if (rows[i].isEmpty) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }
}

