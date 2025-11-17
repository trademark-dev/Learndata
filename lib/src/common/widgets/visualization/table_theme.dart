import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'table_models.dart';

Color darkenColor(Color color, double amount) {
  final HSLColor hsl = HSLColor.fromColor(color);
  final double lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
  return hsl.withLightness(lightness).toColor();
}

Color lightenColor(Color color, double amount) {
  final HSLColor hsl = HSLColor.fromColor(color);
  final double lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
  return hsl.withLightness(lightness).toColor();
}

Color saturateColor(Color color, double amount) {
  final HSLColor hsl = HSLColor.fromColor(color);
  final double saturation = (hsl.saturation + amount).clamp(0.0, 1.0);
  return hsl.withSaturation(saturation).toColor();
}

double clampDouble(double value, double min, double max) =>
    value.clamp(min, max).toDouble();

double clampOpacity(double value) => value.clamp(0.0, 1.0).toDouble();

class TableVisualTheme {
  final TableStyle style;
  final Color accent;
  final BorderRadius borderRadius;
  final double cellPaddingHorizontal;
  final double cellPaddingVertical;
  final double headerFontSize;
  final double cellFontSize;
  final double cellMinFontSize;
  final double dividerThickness;
  final double minRowHeight;
  final double baseCellOpacity;
  final double highlightCellOpacity;
  final double flashCellOpacity;
  final double flashSaturationBoost;
  final double tableTitleFontSize;
  final double tableTitleGap;
  final TextStyle headerTextStyle;
  final TextStyle cellTextStyle;
  final Color headerBackground;
  final Color primaryRowFill;
  final Color secondaryRowFill;
  final Color uniformRowFill;
  final Color dividerColor;
  final Color rowBorderColor;
  final Color tableBorderColor;
  final Color headerDividerColor;
  final Color headerTextColor;
  final Color cellTextColor;
  final Color stripeColor;
  final Color surfaceOverlayColor;
  final Color accentOverlayColor;
  final TextHeightBehavior textHeightBehavior;
  final bool centerNumericColumns;

  const TableVisualTheme({
    required this.style,
    required this.accent,
    required this.borderRadius,
    required this.cellPaddingHorizontal,
    required this.cellPaddingVertical,
    required this.headerFontSize,
    required this.cellFontSize,
    required this.cellMinFontSize,
    required this.dividerThickness,
    required this.minRowHeight,
    required this.baseCellOpacity,
    required this.highlightCellOpacity,
    required this.flashCellOpacity,
    required this.flashSaturationBoost,
    required this.tableTitleFontSize,
    required this.tableTitleGap,
    required this.headerTextStyle,
    required this.cellTextStyle,
    required this.headerBackground,
    required this.primaryRowFill,
    required this.secondaryRowFill,
    required this.uniformRowFill,
    required this.dividerColor,
    required this.rowBorderColor,
    required this.tableBorderColor,
    required this.headerDividerColor,
    required this.headerTextColor,
    required this.cellTextColor,
    required this.stripeColor,
    required this.surfaceOverlayColor,
    required this.accentOverlayColor,
    required this.textHeightBehavior,
    required this.centerNumericColumns,
  });

  bool get isOutputTable => style.role == TableRole.output;
  int? get joinKeyColumnIndex => style.joinKeyColumnIndex;
  Color get joinAccent => style.resolvedJoinKeyAccent();
  Color columnAccentFor(int index) => style.columnAccentFor(index);
  EdgeInsets get cellPadding => EdgeInsets.symmetric(
    horizontal: cellPaddingHorizontal,
    vertical: cellPaddingVertical,
  );
}

TableVisualTheme resolveTableVisualTheme(
  TableStyle style, {
  double headerFontSize = 12.0,
  double cellFontSize = 12.0,
  double cellMinFontSize = 10.0,
  double dividerThickness = 0.75,
  double minRowHeight = 24.0,
  double cellPaddingHorizontal = 6.0,
  double cellPaddingVertical = 8.0,
  double tableCornerRadius = 8.0,
  double baseCellOpacity = 0.18,
  double highlightCellOpacity = 0.28,
  double flashCellOpacity = 0.48,
  double flashSaturationBoost = 0.28,
  double tableTitleFontSize = 14.0,
  double tableTitleGap = 6.0,
  bool centerNumericColumns = true,
}) {
  final Color accent = style.accentColor;
  final bool isOutputTable = style.role == TableRole.output;
  final double headerDarkenAmount = isOutputTable ? 0.32 : 0.38;
  final Color headerBackground =
      style.headerBackground ?? darkenColor(accent, headerDarkenAmount);

  final Color primaryRowFill =
      style.rowBackground ?? accent.withValues(alpha: 0.16);
  final Color secondaryRowFill =
      style.zebraBackground ??
      style.rowBackground ??
      accent.withValues(alpha: 0.08);
  final Color uniformRowFill =
      Color.lerp(primaryRowFill, secondaryRowFill, 0.35) ?? primaryRowFill;
  final double baseRowAlpha = math.min(1.0, uniformRowFill.a * 0.85);
  final Color dividerColor = lightenColor(
    uniformRowFill,
    0.1,
  ).withValues(alpha: baseRowAlpha);

  final Color rowBorderColor = Colors.white.withValues(alpha: 0.39);
  final Color tableBorderColor =
      style.tableBorderColor ?? Colors.white.withValues(alpha: 0.15);
  final Color headerDividerColor = style.headerBorderColor ?? rowBorderColor;
  final Color headerTextColor = style.headerTextColor ?? Colors.white;
  final Color cellTextColor = style.cellTextColor ?? Colors.white;

  final Color resolvedHeaderTextColor = headerTextColor.withValues(alpha: 1.0);
  final Color resolvedCellTextColor = cellTextColor.withValues(alpha: 1.0);

  final Color stripeBaseColor = lightenColor(
    accent,
    isOutputTable ? 0.26 : 0.22,
  );
  final Color stripeColor = saturateColor(
    stripeBaseColor,
    -0.55,
  ).withValues(alpha: isOutputTable ? 0.036 : 0.032);

  final double surfaceOpacity = clampDouble(baseCellOpacity - 0.06, 0.04, 0.24);
  final double accentOverlayOpacity = clampDouble(
    highlightCellOpacity - 0.12,
    0.04,
    0.24,
  );
  final Color surfaceOverlay =
      style.rowBackground ?? accent.withValues(alpha: surfaceOpacity);
  final Color accentOverlay = accent.withValues(alpha: accentOverlayOpacity);

  const TextHeightBehavior textHeightBehavior = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: true,
  );

  final TextStyle headerTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: headerFontSize,
    color: resolvedHeaderTextColor,
    letterSpacing: 0.2,
    height: 1.1,
    leadingDistribution: TextLeadingDistribution.even,
  );
  final TextStyle cellTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: cellFontSize,
    color: resolvedCellTextColor,
    letterSpacing: 0.15,
    height: 1.1,
    leadingDistribution: TextLeadingDistribution.even,
  );

  return TableVisualTheme(
    style: style,
    accent: accent,
    borderRadius: BorderRadius.circular(tableCornerRadius),
    cellPaddingHorizontal: cellPaddingHorizontal,
    cellPaddingVertical: cellPaddingVertical,
    headerFontSize: headerFontSize,
    cellFontSize: cellFontSize,
    cellMinFontSize: cellMinFontSize,
    dividerThickness: dividerThickness,
    minRowHeight: minRowHeight,
    baseCellOpacity: baseCellOpacity,
    highlightCellOpacity: highlightCellOpacity,
    flashCellOpacity: flashCellOpacity,
    flashSaturationBoost: flashSaturationBoost,
    tableTitleFontSize: tableTitleFontSize,
    tableTitleGap: tableTitleGap,
    headerTextStyle: headerTextStyle,
    cellTextStyle: cellTextStyle,
    headerBackground: headerBackground,
    primaryRowFill: primaryRowFill,
    secondaryRowFill: secondaryRowFill,
    uniformRowFill: uniformRowFill,
    dividerColor: dividerColor,
    rowBorderColor: rowBorderColor,
    tableBorderColor: tableBorderColor,
    headerDividerColor: headerDividerColor,
    headerTextColor: resolvedHeaderTextColor,
    cellTextColor: resolvedCellTextColor,
    stripeColor: stripeColor,
    surfaceOverlayColor: surfaceOverlay,
    accentOverlayColor: accentOverlay,
    textHeightBehavior: textHeightBehavior,
    centerNumericColumns: centerNumericColumns,
  );
}

