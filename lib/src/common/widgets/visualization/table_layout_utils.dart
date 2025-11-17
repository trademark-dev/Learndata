import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'table_models.dart';
import 'table_theme.dart';

List<int> computeColumnFlexFromTable(
  TableData table, {
  int minFlex = 12,
  int maxFlex = 96,
  int charUnit = 4,
  int paddingChars = 2,
}) {
  if (table.columnCount == 0) {
    return const <int>[];
  }

  final List<List<String>> rows =
      table.rows
          .map(
            (row) => List<String>.generate(table.columnCount, (index) {
              if (index >= row.length) {
                return '';
              }
              final dynamic cell = row[index];
              return cell == null ? '' : cell.toString();
            }),
          )
          .toList();

  final List<String> headers =
      table.columns.map((column) => column.name).toList();

  return computeColumnFlexFromContent(
    headers: headers,
    rows: rows,
    minFlex: minFlex,
    maxFlex: maxFlex,
    charUnit: charUnit,
    paddingChars: paddingChars,
  );
}

List<int> computeColumnFlexFromContent({
  required List<String> headers,
  required List<List<String>> rows,
  int minFlex = 12,
  int maxFlex = 96,
  int charUnit = 4,
  int paddingChars = 2,
}) {
  if (headers.isEmpty) {
    return const <int>[];
  }
  final int columnCount = headers.length;
  final List<int> flexes = List<int>.filled(
    columnCount,
    minFlex,
    growable: false,
  );

  for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
    int maxChars = headers[columnIndex].length;
    for (final List<String> row in rows) {
      if (columnIndex >= row.length) {
        continue;
      }
      final String value = row[columnIndex];
      if (value.length > maxChars) {
        maxChars = value.length;
      }
    }

    final int paddedChars = math.max(1, maxChars + paddingChars);
    final int flexValue = paddedChars * charUnit;
    flexes[columnIndex] = flexValue.clamp(minFlex, maxFlex);
  }

  return flexes;
}

class ColumnLayoutMetrics {
  final List<double> widths;
  final List<int> flex;
  final double totalWidth;

  const ColumnLayoutMetrics({
    required this.widths,
    required this.flex,
    required this.totalWidth,
  });
}

ColumnLayoutMetrics computeMeasuredColumnLayout({
  required List<String> headers,
  required List<List<String>> rows,
  required TextStyle headerTextStyle,
  required TextStyle cellTextStyle,
  required double horizontalPadding,
  List<double>? columnPaddingOverrides,
  TextDirection textDirection = TextDirection.ltr,
  int minFlex = 12,
  int maxFlex = 96,
  double textScaleFactor = 1.0,
}) {
  if (headers.isEmpty) {
    return const ColumnLayoutMetrics(
      widths: <double>[],
      flex: <int>[],
      totalWidth: 0.0,
    );
  }

  final int columnCount = headers.length;
  final List<double> columnWidths = List<double>.filled(
    columnCount,
    0.0,
    growable: false,
  );

  for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
    final double headerWidth = _measureTextWidth(
      headers[columnIndex],
      headerTextStyle,
      textDirection,
      textScaleFactor,
    );

    double maxWidth = headerWidth;
    for (final List<String> row in rows) {
      if (columnIndex >= row.length) {
        continue;
      }
      final double cellWidth = _measureTextWidth(
        row[columnIndex],
        cellTextStyle,
        textDirection,
        textScaleFactor,
      );
      if (cellWidth > maxWidth) {
        maxWidth = cellWidth;
      }
    }

    final double paddingOverride =
        columnPaddingOverrides != null &&
                columnIndex < columnPaddingOverrides.length
            ? columnPaddingOverrides[columnIndex]
            : horizontalPadding * 2;

    columnWidths[columnIndex] = maxWidth + paddingOverride;
  }

  if (columnWidths.every((width) => width <= 0)) {
    return ColumnLayoutMetrics(
      widths: columnWidths,
      flex: List<int>.filled(columnCount, minFlex, growable: false),
      totalWidth: 0.0,
    );
  }

  final double totalWidth = columnWidths.fold(0.0, (sum, width) => sum + width);
  
  // Calculate flex values proportional to measured widths
  // Scale to use the full flex range (minFlex to maxFlex) for better precision
  final double maxWidth = columnWidths.fold(0.0, (a, b) => a > b ? a : b);
  
  final List<int> flexes = columnWidths
      .map((width) {
        if (width <= 0 || maxWidth <= 0) {
          return minFlex;
        }
        // Map the width range to the flex range
        // Narrowest column gets minFlex, widest gets maxFlex
        final double ratio = width / maxWidth;
        final int flexRange = maxFlex - minFlex;
        final int flexValue = minFlex + (ratio * flexRange).round();
        return flexValue.clamp(minFlex, maxFlex);
      })
      .toList(growable: false);

  return ColumnLayoutMetrics(
    widths: columnWidths,
    flex: flexes,
    totalWidth: totalWidth,
  );
}

double _measureTextWidth(
  String text,
  TextStyle style,
  TextDirection textDirection,
  double textScaleFactor,
) {
  if (text.isEmpty) {
    return 0;
  }
  final TextPainter painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: textDirection,
    maxLines: 1,
    ellipsis: null,
    textScaler: TextScaler.linear(textScaleFactor),
  )..layout();
  return painter.size.width;
}

bool columnShouldCenter({
  required TableData table,
  required TableVisualTheme theme,
  required int columnIndex,
}) {
  if (!theme.centerNumericColumns ||
      columnIndex < 0 ||
      columnIndex >= table.columnCount) {
    return false;
  }

  bool hasNumericValue = false;

  for (final List<dynamic> row in table.rows) {
    if (columnIndex >= row.length) {
      continue;
    }
    final dynamic value = row[columnIndex];
    if (value == null) {
      continue;
    }
    if (value is num) {
      hasNumericValue = true;
      continue;
    }
    if (value is String) {
      final String trimmed = value.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final num? parsed = num.tryParse(trimmed);
      if (parsed != null) {
        hasNumericValue = true;
        continue;
      }
    }
    return false;
  }

  return hasNumericValue;
}

Alignment resolveColumnCellAlignment({
  required TableData table,
  required TableVisualTheme theme,
  required int columnIndex,
}) {
  return columnShouldCenter(
        table: table,
        theme: theme,
        columnIndex: columnIndex,
      )
      ? Alignment.center
      : Alignment.centerLeft;
}

TextAlign resolveColumnTextAlign({
  required TableData table,
  required TableVisualTheme theme,
  required int columnIndex,
}) {
  return columnShouldCenter(
        table: table,
        theme: theme,
        columnIndex: columnIndex,
      )
      ? TextAlign.center
      : TextAlign.left;
}

List<Alignment> resolveColumnCellAlignments({
  required TableData table,
  required TableVisualTheme theme,
}) {
  final int columnCount = table.columnCount;
  return List<Alignment>.generate(
    columnCount,
    (index) => resolveColumnCellAlignment(
      table: table,
      theme: theme,
      columnIndex: index,
    ),
    growable: false,
  );
}

List<TextAlign> resolveColumnTextAlignments({
  required TableData table,
  required TableVisualTheme theme,
}) {
  final int columnCount = table.columnCount;
  return List<TextAlign>.generate(
    columnCount,
    (index) =>
        resolveColumnTextAlign(table: table, theme: theme, columnIndex: index),
    growable: false,
  );
}

