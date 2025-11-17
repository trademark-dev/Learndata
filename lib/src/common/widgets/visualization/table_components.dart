import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

const double kTableColumnDividerWidth = 1.0;

class TableHeaderRow extends StatelessWidget {
  final List<String> headers;
  final List<int> columnFlex;
  final double height;
  final Color backgroundColor;
  final BorderSide edgeBorder;
  final BorderSide bottomBorder;
  final Color dividerColor;
  final EdgeInsetsGeometry cellPadding;
  final TextStyle textStyle;
  final double minFontSize;
  final double maxFontSize;
  final Alignment cellAlignment;
  final TextAlign textAlign;
  final AutoSizeGroup? textGroup;
  final List<Alignment>? columnAlignments;
  final List<TextAlign>? columnTextAlignments;
  final List<Widget>? headerWidgets;
  final List<EdgeInsetsGeometry>? columnPaddings;
  final BorderRadius? borderRadius;
  final List<double>? columnWidths;

  const TableHeaderRow({
    super.key,
    required this.headers,
    required this.columnFlex,
    required this.height,
    required this.backgroundColor,
    required this.edgeBorder,
    required this.bottomBorder,
    required this.dividerColor,
    required this.cellPadding,
    required this.textStyle,
    required this.minFontSize,
    required this.maxFontSize,
    required this.cellAlignment,
    required this.textAlign,
    this.textGroup,
    this.columnAlignments,
    this.columnTextAlignments,
    this.headerWidgets,
    this.columnPaddings,
    this.borderRadius,
    this.columnWidths,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: edgeBorder,
          left: edgeBorder,
          right: edgeBorder,
          bottom: bottomBorder,
        ),
        borderRadius: borderRadius,
      ),
      child: Row(
        children: List.generate(headers.length, (index) {
          Widget buildCell(Widget child) {
            final bool useFixedWidths =
                columnWidths != null && columnWidths!.length == headers.length;
            if (useFixedWidths) {
              final double width = columnWidths![index];
              return SizedBox(width: width, child: child);
            }
            return Expanded(flex: columnFlex[index], child: child);
          }

          final bool isLast = index == headers.length - 1;
          final Alignment alignment =
              columnAlignments != null && index < columnAlignments!.length
                  ? columnAlignments![index]
                  : cellAlignment;
          final TextAlign columnTextAlign =
              columnTextAlignments != null &&
                      index < columnTextAlignments!.length
                  ? columnTextAlignments![index]
                  : textAlign;
          final Widget? customHeader =
              headerWidgets != null && index < headerWidgets!.length
                  ? headerWidgets![index]
                  : null;
          final EdgeInsetsGeometry resolvedPadding =
              columnPaddings != null && index < columnPaddings!.length
                  ? columnPaddings![index]
                  : cellPadding;
          final Widget cell = Container(
            alignment: alignment,
            padding: resolvedPadding,
            decoration: BoxDecoration(
              border: Border(
                right:
                    isLast
                        ? BorderSide.none
                        : BorderSide(
                          color: dividerColor,
                          width: kTableColumnDividerWidth,
                        ),
              ),
            ),
            child:
                customHeader == null
                    ? AutoSizeText(
                      headers[index],
                      group: textGroup,
                      minFontSize: minFontSize,
                      maxFontSize: maxFontSize,
                      stepGranularity: 0.25,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      textAlign: columnTextAlign,
                      style: textStyle,
                    )
                    : DefaultTextStyle.merge(
                      style: textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: customHeader,
                    ),
          );

          return buildCell(cell);
        }),
      ),
    );
  }
}

