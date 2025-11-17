import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'table_components.dart';
import 'table_layout_utils.dart';
import 'table_models.dart';
import 'table_surface.dart';
import 'table_theme.dart';

const double kStaticTableVerticalInset = 4.0;
const double kStaticTableHorizontalInset = 8.0;
const double kStaticTableColumnSlack = 3.0;

typedef StaticTableCellBackgroundBuilder =
    Color? Function(int rowIndex, int columnIndex, String value);

@immutable
class StaticTableLayoutDetails {
  const StaticTableLayoutDetails({
    required this.columnWidths,
    required this.columnOffsets,
    required this.tableWidth,
    required this.tableHeight,
    required this.headerHeight,
    required this.rowHeight,
  });

  final List<double> columnWidths;
  final List<double> columnOffsets;
  final double tableWidth;
  final double tableHeight;
  final double headerHeight;
  final double rowHeight;

  StaticTableLayoutDetails copyWith({
    List<double>? columnWidths,
    List<double>? columnOffsets,
    double? tableWidth,
    double? tableHeight,
    double? headerHeight,
    double? rowHeight,
  }) {
    return StaticTableLayoutDetails(
      columnWidths: columnWidths ?? this.columnWidths,
      columnOffsets: columnOffsets ?? this.columnOffsets,
      tableWidth: tableWidth ?? this.tableWidth,
      tableHeight: tableHeight ?? this.tableHeight,
      headerHeight: headerHeight ?? this.headerHeight,
      rowHeight: rowHeight ?? this.rowHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StaticTableLayoutDetails &&
        listEquals(other.columnWidths, columnWidths) &&
        listEquals(other.columnOffsets, columnOffsets) &&
        other.tableWidth == tableWidth &&
        other.tableHeight == tableHeight &&
        other.headerHeight == headerHeight &&
        other.rowHeight == rowHeight;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(columnWidths),
    Object.hashAll(columnOffsets),
    tableWidth,
    tableHeight,
    headerHeight,
    rowHeight,
  );
}

class TableColumnConfig {
  final String header;
  final Alignment? headerAlignment;
  final TextAlign? headerTextAlign;
  final Alignment? cellAlignment;
  final TextAlign? cellTextAlign;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? cellPadding;
  final Alignment? cellContentAlignment;

  const TableColumnConfig({
    required this.header,
    this.headerAlignment,
    this.headerTextAlign,
    this.cellAlignment,
    this.cellTextAlign,
    this.headerPadding,
    this.cellPadding,
    this.cellContentAlignment,
  });
}

List<bool> _resolveCenteredColumnHints({
  required int columnCount,
  required List<List<String>> rows,
  required TableVisualTheme theme,
}) {
  if (!theme.centerNumericColumns || columnCount == 0) {
    return List<bool>.filled(columnCount, false, growable: false);
  }

  return List<bool>.generate(columnCount, (columnIndex) {
    bool hasNumericValue = false;

    for (final List<String> row in rows) {
      if (columnIndex >= row.length) {
        continue;
      }

      final String value = row[columnIndex].trim();
      if (value.isEmpty) {
        continue;
      }

      if (_stringLooksNumeric(value)) {
        hasNumericValue = true;
        continue;
      }

      return false;
    }

    return hasNumericValue;
  }, growable: false);
}

bool _stringLooksNumeric(String value) {
  final String trimmed = value.trim();
  if (trimmed.isEmpty) {
    return false;
  }

  final String sanitized = trimmed
      .replaceAll('−', '-')
      .replaceAll(RegExp(r'[,%\$]'), '')
      .replaceAll(RegExp(r'\s+'), '');

  if (sanitized.isEmpty) {
    return false;
  }

  final String unwrapped =
      sanitized.startsWith('(') &&
              sanitized.endsWith(')') &&
              sanitized.length > 2
          ? sanitized.substring(1, sanitized.length - 1)
          : sanitized;

  return num.tryParse(unwrapped) != null;
}

typedef StaticTableCellBuilder =
    Widget? Function(
      BuildContext context,
      int rowIndex,
      int columnIndex,
      String value,
    );

class StaticTable extends StatelessWidget {
  final TableStyle style;
  final List<TableColumnConfig> columns;
  final List<List<String>> rows;
  final double? rowHeight;
  final EdgeInsetsGeometry? padding;
  final bool zebraStripes;
  final StaticTableCellBuilder? cellBuilder;
  final double? widthOverride;
  final bool expandToMaxWidth;
  final StaticTableCellBackgroundBuilder? cellBackgroundBuilder;
  final ValueChanged<StaticTableLayoutDetails>? onLayout;

  const StaticTable({
    super.key,
    required this.style,
    required this.columns,
    required this.rows,
    this.rowHeight,
    this.padding,
    this.zebraStripes = false,
    this.cellBuilder,
    this.widthOverride,
    this.expandToMaxWidth = false,
    this.cellBackgroundBuilder,
    this.onLayout,
  });

  @override
  Widget build(BuildContext context) {
    if (columns.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final TableVisualTheme theme = resolveTableVisualTheme(style);
        final AutoSizeGroup headerGroup = AutoSizeGroup();
        final int rowCount = rows.length;
        final List<String> headers =
            columns.map((TableColumnConfig column) => column.header).toList();
        final TextDirection textDirection = Directionality.of(context);
        final Color baseCellBackground = theme.accent.withValues(
          alpha: theme.baseCellOpacity,
        );

        final int columnCount = columns.length;

        final EdgeInsetsGeometry tablePaddingGeometry =
            padding ??
            const EdgeInsets.symmetric(
              vertical: kStaticTableVerticalInset,
              horizontal: kStaticTableHorizontalInset,
            );
        final EdgeInsets resolvedTablePadding = tablePaddingGeometry.resolve(
          textDirection,
        );
        final double horizontalPaddingTotal =
            resolvedTablePadding.left + resolvedTablePadding.right;

        final EdgeInsets defaultHeaderPadding = EdgeInsets.symmetric(
          horizontal: theme.cellPaddingHorizontal,
          vertical: theme.cellPaddingVertical,
        );
        final EdgeInsets defaultCellPadding = EdgeInsets.symmetric(
          horizontal: theme.cellPaddingHorizontal,
          vertical: theme.cellPaddingVertical,
        );

        final double textScaleFactor = MediaQuery.textScaleFactorOf(context);


        final List<EdgeInsetsGeometry> headerPaddingOverrides =
            List<EdgeInsetsGeometry>.generate(
              columnCount,
              (index) => columns[index].headerPadding ?? defaultHeaderPadding,
              growable: false,
            );

        final List<EdgeInsetsGeometry> cellPaddingOverrides =
            List<EdgeInsetsGeometry>.generate(
              columnCount,
              (index) => columns[index].cellPadding ?? defaultCellPadding,
              growable: false,
            );

        List<EdgeInsets> resolvedHeaderPaddings = headerPaddingOverrides
            .map((padding) => padding.resolve(textDirection))
            .toList(growable: false);
        List<EdgeInsets> resolvedCellPaddings = cellPaddingOverrides
            .map((padding) => padding.resolve(textDirection))
            .toList(growable: false);

        if (kStaticTableColumnSlack > 0) {
          final double halfSlack = kStaticTableColumnSlack / 2;
          resolvedHeaderPaddings = resolvedHeaderPaddings
              .map(
                (padding) => EdgeInsets.fromLTRB(
                  padding.left + halfSlack,
                  padding.top,
                  padding.right + halfSlack,
                  padding.bottom,
                ),
              )
              .toList(growable: false);
          resolvedCellPaddings = resolvedCellPaddings
              .map(
                (padding) => EdgeInsets.fromLTRB(
                  padding.left + halfSlack,
                  padding.top,
                  padding.right + halfSlack,
                  padding.bottom,
                ),
              )
              .toList(growable: false);
        }

        final List<double> paddingSums = List<double>.generate(columnCount, (
          index,
        ) {
          final double headerSum =
              resolvedHeaderPaddings[index].left +
              resolvedHeaderPaddings[index].right;
          final double cellSum =
              resolvedCellPaddings[index].left +
              resolvedCellPaddings[index].right;
          final double dividerAllowance =
              index < columnCount - 1 ? kTableColumnDividerWidth : 0.0;
          return math.max(headerSum, cellSum) + dividerAllowance;
        }, growable: false);

        final List<bool> centeredColumnHints = _resolveCenteredColumnHints(
          columnCount: columnCount,
          rows: rows,
          theme: theme,
        );

        final List<Alignment> headerAlignments = List<Alignment>.generate(
          columnCount,
          (index) {
            final TableColumnConfig config = columns[index];
            if (config.headerAlignment != null) {
              return config.headerAlignment!;
            }
            if (config.cellAlignment != null) {
              return config.cellAlignment!;
            }
            return centeredColumnHints[index]
                ? Alignment.center
                : Alignment.centerLeft;
          },
          growable: false,
        );

        final List<TextAlign> headerTextAlignments = List<TextAlign>.generate(
          columnCount,
          (index) {
            final TableColumnConfig config = columns[index];
            if (config.headerTextAlign != null) {
              return config.headerTextAlign!;
            }
            if (config.cellTextAlign != null) {
              return config.cellTextAlign!;
            }
            return centeredColumnHints[index]
                ? TextAlign.center
                : TextAlign.left;
          },
          growable: false,
        );

        final List<Alignment> cellAlignments = List<Alignment>.generate(
          columnCount,
          (index) {
            final TableColumnConfig config = columns[index];
            if (config.cellAlignment != null) {
              return config.cellAlignment!;
            }
            return centeredColumnHints[index]
                ? Alignment.center
                : Alignment.centerLeft;
          },
          growable: false,
        );

        final List<Alignment> cellContentAlignments = List<Alignment>.generate(
          columnCount,
          (index) {
            final TableColumnConfig config = columns[index];
            if (config.cellContentAlignment != null) {
              return config.cellContentAlignment!;
            }
            return cellAlignments[index];
          },
          growable: false,
        );

        final List<TextAlign> cellTextAlignments = List<TextAlign>.generate(
          columnCount,
          (index) {
            final TableColumnConfig config = columns[index];
            if (config.cellTextAlign != null) {
              return config.cellTextAlign!;
            }
            return centeredColumnHints[index]
                ? TextAlign.center
                : TextAlign.left;
          },
          growable: false,
        );

    final double cellLineHeightMultiplier =
      theme.cellTextStyle.height ?? 1.0;
    final double effectiveCellContentHeight =
      theme.cellFontSize * cellLineHeightMultiplier;
    // Reserve enough vertical space for full glyph ascenders/descenders.
        final double targetRowHeight = math.max(
      effectiveCellContentHeight + (theme.cellPaddingVertical * 2),
          theme.minRowHeight,
        );
        double resolvedRowHeight = rowHeight ?? targetRowHeight;
        resolvedRowHeight = resolvedRowHeight.clamp(
          theme.minRowHeight,
          double.infinity,
        );

        final double headerHeight = resolvedRowHeight;
        final double bodyHeight = resolvedRowHeight * rowCount;
        final double tableHeight = headerHeight + bodyHeight;

        ColumnLayoutMetrics layout = computeMeasuredColumnLayout(
          headers: headers,
          rows: rows,
          headerTextStyle: theme.headerTextStyle,
          cellTextStyle: theme.cellTextStyle,
          horizontalPadding: theme.cellPaddingHorizontal,
          columnPaddingOverrides: paddingSums,
          textDirection: textDirection,
          minFlex: 12,
          maxFlex: 96,
          textScaleFactor: textScaleFactor,
        );
        List<int> columnFlex = layout.flex;
        List<double> columnWidths = List<double>.from(
          layout.widths,
          growable: false,
        );
        double totalColumnWidth = layout.totalWidth;

        final bool hasBoundedWidth =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite;
        final double availableWidth =
            hasBoundedWidth
                ? math.max(constraints.maxWidth - horizontalPaddingTotal, 0.0)
                : totalColumnWidth;

        double targetWidth = totalColumnWidth;
        if (widthOverride != null && widthOverride!.isFinite) {
          double desiredWidth = widthOverride!;
          if (hasBoundedWidth) {
            desiredWidth = desiredWidth.clamp(0.0, availableWidth);
          }
          targetWidth = math.max(totalColumnWidth, desiredWidth);
        } else if (expandToMaxWidth && hasBoundedWidth) {
          targetWidth = math.max(totalColumnWidth, availableWidth);
        }

        final double extraWidth = math.max(0.0, targetWidth - totalColumnWidth);
        if (extraWidth > 0.5 && columns.isNotEmpty) {
          final double extraPerColumn = extraWidth / columns.length;
          final double halfExtra = extraPerColumn / 2;
          resolvedHeaderPaddings = resolvedHeaderPaddings
              .map(
                (padding) => EdgeInsets.fromLTRB(
                  padding.left + halfExtra,
                  padding.top,
                  padding.right + halfExtra,
                  padding.bottom,
                ),
              )
              .toList(growable: false);
          resolvedCellPaddings = resolvedCellPaddings
              .map(
                (padding) => EdgeInsets.fromLTRB(
                  padding.left + halfExtra,
                  padding.top,
                  padding.right + halfExtra,
                  padding.bottom,
                ),
              )
              .toList(growable: false);

          final List<double> expandedPaddingSums = List<double>.generate(
            columns.length,
            (index) {
              final double headerSum =
                  resolvedHeaderPaddings[index].left +
                  resolvedHeaderPaddings[index].right;
              final double cellSum =
                  resolvedCellPaddings[index].left +
                  resolvedCellPaddings[index].right;
              final double dividerAllowance =
                  index < columns.length - 1 ? kTableColumnDividerWidth : 0.0;
              return math.max(headerSum, cellSum) + dividerAllowance;
            },
            growable: false,
          );

          layout = computeMeasuredColumnLayout(
            headers: headers,
            rows: rows,
            headerTextStyle: theme.headerTextStyle,
            cellTextStyle: theme.cellTextStyle,
            horizontalPadding: theme.cellPaddingHorizontal,
            columnPaddingOverrides: expandedPaddingSums,
            textDirection: textDirection,
            minFlex: 12,
            maxFlex: 96,
            textScaleFactor: textScaleFactor,
          );
          columnFlex = layout.flex;
          columnWidths = List<double>.from(layout.widths, growable: false);
          totalColumnWidth = layout.totalWidth;
        }

        double columnWidthsSum = columnWidths.fold<double>(
          0.0,
          (sum, width) => sum + width,
        );
        final bool needsHorizontalScroll =
            hasBoundedWidth &&
            availableWidth > 0.0 &&
            columnWidthsSum > availableWidth + 0.5;

        final double desiredTableWidth =
            needsHorizontalScroll
                ? columnWidthsSum
                : math.max(columnWidthsSum, targetWidth);

        if (!needsHorizontalScroll &&
            desiredTableWidth > columnWidthsSum + 0.5) {
          final double addPerColumn =
              (desiredTableWidth - columnWidthsSum) / columns.length;
          columnWidths = columnWidths
              .map((width) => width + addPerColumn)
              .toList(growable: false);
          columnWidthsSum = columnWidths.fold<double>(
            0.0,
            (sum, width) => sum + width,
          );
        }

        final double tableWidth = columnWidthsSum;
        totalColumnWidth = columnWidthsSum;

        final List<EdgeInsetsGeometry> effectiveHeaderPaddings =
            resolvedHeaderPaddings
                .map<EdgeInsetsGeometry>((padding) => padding)
                .toList(growable: false);
        final List<EdgeInsetsGeometry> effectiveCellPaddings =
            resolvedCellPaddings
                .map<EdgeInsetsGeometry>((padding) => padding)
                .toList(growable: false);

        final Widget headerRow = TableHeaderRow(
          headers: headers,
          columnFlex: columnFlex,
          height: headerHeight,
          backgroundColor: theme.headerBackground,
          edgeBorder: BorderSide.none,
          bottomBorder: BorderSide(
            color: theme.headerDividerColor,
            width: theme.dividerThickness,
          ),
          dividerColor: theme.dividerColor,
          cellPadding: defaultHeaderPadding,
          textStyle: theme.headerTextStyle,
          minFontSize: theme.cellMinFontSize,
          maxFontSize: theme.headerFontSize,
          cellAlignment: Alignment.centerLeft,
          textAlign: TextAlign.left,
          textGroup: headerGroup,
          columnAlignments: headerAlignments,
          columnTextAlignments: headerTextAlignments,
          columnPaddings: effectiveHeaderPaddings,
          columnWidths: columnWidths,
          borderRadius: BorderRadius.only(
            topLeft: theme.borderRadius.topLeft,
            topRight: theme.borderRadius.topRight,
          ),
        );

        Widget buildRow(int rowIndex) {
          final List<String> rowValues = rows[rowIndex];
          final bool isLast = rowIndex == rowCount - 1;
          final Color rowBackground =
              zebraStripes
                  ? (rowIndex.isEven
                      ? theme.primaryRowFill
                      : theme.secondaryRowFill)
                  : theme.uniformRowFill;
          final StrutStyle cellStrutStyle = StrutStyle(
            fontSize: theme.cellFontSize,
            height: theme.cellTextStyle.height,
            forceStrutHeight: false,
          );

          return Container(
            decoration: BoxDecoration(
              color: rowBackground,
              border: Border(
                bottom:
                    isLast
                        ? BorderSide.none
                        : BorderSide(
                          color: theme.rowBorderColor,
                          width: theme.dividerThickness,
                        ),
              ),
            ),
            child: Row(
              children: List.generate(columns.length, (columnIndex) {
                final String value =
                    columnIndex < rowValues.length
                        ? rowValues[columnIndex]
                        : '';
                final bool isLastColumn = columnIndex == columns.length - 1;
                final Widget? customCell = cellBuilder?.call(
                  context,
                  rowIndex,
                  columnIndex,
                  value,
                );

                final Color cellBackground =
                    cellBackgroundBuilder?.call(rowIndex, columnIndex, value) ??
                    baseCellBackground;

                // Check if value represents null
                final bool isNull = value == 'NULL';
                final String displayValue = isNull ? 'null' : value;
                
                final Widget cell = Container(
                  alignment: cellAlignments[columnIndex],
                  padding: effectiveCellPaddings[columnIndex],
                  decoration: BoxDecoration(
                    color: cellBackground,
                    border: Border(
                      right:
                          isLastColumn
                              ? BorderSide.none
                              : BorderSide(
                                color: theme.dividerColor,
                                width: kTableColumnDividerWidth,
                              ),
                    ),
                  ),
                  child: Align(
                    alignment: cellContentAlignments[columnIndex],
                    child: DefaultTextStyle.merge(
                      style: isNull
                          ? theme.cellTextStyle.copyWith(
                              color: theme.cellTextStyle.color?.withValues(alpha: 0.4),
                            )
                          : theme.cellTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: cellTextAlignments[columnIndex],
                      textHeightBehavior: theme.textHeightBehavior,
                      child:
                          customCell ??
                          AutoSizeText(
                            displayValue,
                            maxLines: 1,
                            minFontSize: theme.cellMinFontSize,
                            maxFontSize: theme.cellFontSize,
                            overflow: TextOverflow.ellipsis,
                            textAlign: cellTextAlignments[columnIndex],
                            strutStyle: cellStrutStyle,
                          ),
                    ),
                  ),
                );

                if (columnIndex < columnWidths.length) {
                  return SizedBox(
                    width: columnWidths[columnIndex],
                    child: cell,
                  );
                }

                return Expanded(flex: columnFlex[columnIndex], child: cell);
              }),
            ),
          );
        }

        final Widget body =
            rowCount == 0
                ? const SizedBox.shrink()
                : ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemExtent: resolvedRowHeight,
                  itemCount: rowCount,
                  itemBuilder: (context, index) => buildRow(index),
                );

        final Widget tableContent = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            headerRow,
            SizedBox(
              height: bodyHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: theme.rowBorderColor,
                      width: theme.dividerThickness,
                    ),
                  ),
                ),
                child: body,
              ),
            ),
          ],
        );

        final Widget tableCore = ClipRRect(
          borderRadius: theme.borderRadius,
          clipBehavior: Clip.none,
          child: SizedBox(
            width: tableWidth,
            height: tableHeight,
            child: tableContent,
          ),
        );

        final Widget themedTable = TableSurface(
          theme: theme,
          width: tableWidth,
          height: tableHeight,
          child: tableCore,
        );

        final Widget tableDisplay =
            needsHorizontalScroll
                ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: themedTable,
                )
                : Align(alignment: Alignment.centerLeft, child: themedTable);

        if (onLayout != null) {
          final List<double> offsets = List<double>.generate(
            columnWidths.length,
            (int index) {
              if (index == 0) {
                return 0.0;
              }
              return columnWidths
                  .sublist(0, index)
                  .fold<double>(0.0, (double sum, double width) => sum + width);
            },
            growable: false,
          );
          final StaticTableLayoutDetails details = StaticTableLayoutDetails(
            columnWidths: List<double>.unmodifiable(columnWidths),
            columnOffsets: List<double>.unmodifiable(offsets),
            tableWidth: tableWidth,
            tableHeight: tableHeight,
            headerHeight: headerHeight,
            rowHeight: resolvedRowHeight,
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (onLayout != null) {
              onLayout!(details);
            }
          });
        }

        return Padding(padding: resolvedTablePadding, child: tableDisplay);
      },
    );
  }
}

