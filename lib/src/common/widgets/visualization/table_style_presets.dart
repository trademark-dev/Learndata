import 'package:flutter/material.dart';

import 'table_models.dart';

class TableStylePalette {
  const TableStylePalette._();

  static const Color _sharedHeaderBorder = Color(0x12FFFFFF);
  static const Color _sharedRowBorder = Color(0x14FFFFFF);
  static const Color _sharedDivider = Color(0x0DFFFFFF);
  static const Color _sharedTableBorder = Color(0x26E5E6EB);
  static const Color _sharedTextColor = Color(0xFFFFFFFF);

  static const Color _primaryAccent = Color(0xFF68C5FF);
  static const Color _primaryHeaderBackground = Color(0xCC11446A);
  static const Color _primaryRowBackground = Color(0x1A009CFF);
  static const Color _primaryZebraBackground = _primaryRowBackground;

  static const Color _secondaryAccent = Color(0xFF5FE7C7);
  static const Color _secondaryHeaderBackground = Color(0xCC10453A);
  static const Color _secondaryRowBackground = Color(0x14CFF4E7);
  static const Color _secondaryZebraBackground = _secondaryRowBackground;

  static const Color _tertiaryAccent = Color(0xFFC5A2FF);
  static const Color _tertiaryHeaderBackground = Color(0xCC3B2361);
  static const Color _tertiaryRowBackground = Color(0x14E7D5FF);
  static const Color _tertiaryZebraBackground = _tertiaryRowBackground;

  static const Color _outputAccent = Color(0xFF68C5FF);
  static const Color _outputHeaderBackground = Color(0xCC103A62);
  static const Color _outputRowBackground = Color(0x14ACD3FF);
  static const Color _outputZebraBackground = _outputRowBackground;

  static TableStyle inputPrimary({
    int? joinKeyColumnIndex,
    double? framePadding,
    Color? joinKeyAccentColor,
  }) {
    final Color joinAccent = joinKeyAccentColor ?? _primaryAccent;
    return TableStyle(
      accentColor: _primaryAccent,
      joinKeyColumnIndex: joinKeyColumnIndex,
      framePadding: framePadding ?? 2.0,
      role: TableRole.input,
      joinKeyAccentColor: joinAccent,
      headerBackground: _primaryHeaderBackground,
      headerBorderColor: _sharedHeaderBorder,
      rowBackground: _primaryRowBackground,
      zebraBackground: _primaryZebraBackground,
      rowBorderColor: _sharedRowBorder,
      dividerColor: _sharedDivider,
      tableBorderColor: _sharedTableBorder,
      headerTextColor: _sharedTextColor,
      cellTextColor: _sharedTextColor,
    );
  }

  static TableStyle inputSecondary({
    int? joinKeyColumnIndex,
    double? framePadding,
    Color? joinKeyAccentColor,
  }) {
    final Color joinAccent = joinKeyAccentColor ?? _secondaryAccent;
    return TableStyle(
      accentColor: _secondaryAccent,
      joinKeyColumnIndex: joinKeyColumnIndex,
      framePadding: framePadding ?? 2.0,
      role: TableRole.input,
      joinKeyAccentColor: joinAccent,
      headerBackground: _secondaryHeaderBackground,
      headerBorderColor: _sharedHeaderBorder,
      rowBackground: _secondaryRowBackground,
      zebraBackground: _secondaryZebraBackground,
      rowBorderColor: _sharedRowBorder,
      dividerColor: _sharedDivider,
      tableBorderColor: _sharedTableBorder,
      headerTextColor: _sharedTextColor,
      cellTextColor: _sharedTextColor,
    );
  }

  static TableStyle inputTertiary({
    int? joinKeyColumnIndex,
    double? framePadding,
    Color? joinKeyAccentColor,
  }) {
    final Color joinAccent = joinKeyAccentColor ?? _tertiaryAccent;
    return TableStyle(
      accentColor: _tertiaryAccent,
      joinKeyColumnIndex: joinKeyColumnIndex,
      framePadding: framePadding ?? 2.0,
      role: TableRole.input,
      joinKeyAccentColor: joinAccent,
      headerBackground: _tertiaryHeaderBackground,
      headerBorderColor: _sharedHeaderBorder,
      rowBackground: _tertiaryRowBackground,
      zebraBackground: _tertiaryZebraBackground,
      rowBorderColor: _sharedRowBorder,
      dividerColor: _sharedDivider,
      tableBorderColor: _sharedTableBorder,
      headerTextColor: _sharedTextColor,
      cellTextColor: _sharedTextColor,
    );
  }

  static TableStyle output({
    int? joinKeyColumnIndex,
    List<Color>? columnAccentColors,
    double? framePadding,
    Color? joinKeyAccentColor,
  }) {
    final Color keyAccent = joinKeyAccentColor ?? _primaryAccent;
    final List<Color> baseAccents =
        (columnAccentColors == null || columnAccentColors.isEmpty)
            ? <Color>[
              keyAccent,
              _primaryAccent,
              _secondaryAccent,
              _outputAccent,
            ]
            : columnAccentColors;

    final Color boostedAccent = _boostColor(
      _outputAccent,
      saturationDelta: 0.08,
      valueDelta: 0.12,
    );
    final Color boostedKeyAccent = _boostColor(
      keyAccent,
      saturationDelta: 0.08,
      valueDelta: 0.12,
    );
    final List<Color> boostedAccents =
        baseAccents
            .map(
              (color) =>
                  _boostColor(color, saturationDelta: 0.08, valueDelta: 0.12),
            )
            .toList();

    final Color boostedHeaderBackground = _boostColor(
      _outputHeaderBackground,
      saturationDelta: 0.05,
      valueDelta: 0.08,
    );
    final Color boostedRowBackground = _boostColor(
      _outputRowBackground,
      saturationDelta: 0.02,
      valueDelta: 0.15,
    );
    final Color boostedZebraBackground = _boostColor(
      _outputZebraBackground,
      saturationDelta: 0.02,
      valueDelta: 0.15,
    );

    return TableStyle(
      accentColor: boostedAccent,
      columnAccentColors: boostedAccents,
      joinKeyColumnIndex: joinKeyColumnIndex,
      framePadding: framePadding ?? 3.0,
      role: TableRole.output,
      joinKeyAccentColor: boostedKeyAccent,
      headerBackground: boostedHeaderBackground,
      headerBorderColor: _sharedHeaderBorder,
      rowBackground: boostedRowBackground,
      zebraBackground: boostedZebraBackground,
      rowBorderColor: _sharedRowBorder,
      dividerColor: _sharedDivider,
      tableBorderColor: _sharedTableBorder,
      headerTextColor: _sharedTextColor,
      cellTextColor: _sharedTextColor,
    );
  }

  static TableStyle outputFromInputs({
    required List<TableStyle> inputStyles,
    required List<int> columnSourceIndices,
    int? joinKeyColumnIndex,
    double? framePadding,
    Color? joinKeyAccentColor,
  }) {
    if (inputStyles.isEmpty) {
      return output(
        joinKeyColumnIndex: joinKeyColumnIndex,
        framePadding: framePadding,
        joinKeyAccentColor: joinKeyAccentColor,
      );
    }

    final int joinSourceIndex =
        (joinKeyColumnIndex != null &&
                joinKeyColumnIndex >= 0 &&
                joinKeyColumnIndex < columnSourceIndices.length)
            ? columnSourceIndices[joinKeyColumnIndex]
            : 0;

    final TableStyle joinSourceStyle =
        (joinSourceIndex >= 0 && joinSourceIndex < inputStyles.length)
            ? inputStyles[joinSourceIndex]
            : inputStyles.first;

    final Color resolvedJoinAccent =
        joinKeyAccentColor ?? joinSourceStyle.accentColor;

    final List<Color> columnAccents = <Color>[];
    for (int i = 0; i < columnSourceIndices.length; i++) {
      final int sourceIndex = columnSourceIndices[i];
      final TableStyle sourceStyle =
          (sourceIndex >= 0 && sourceIndex < inputStyles.length)
              ? inputStyles[sourceIndex]
              : inputStyles.first;
      columnAccents.add(sourceStyle.accentColor);
    }

    if (joinKeyColumnIndex != null &&
        joinKeyColumnIndex >= 0 &&
        joinKeyColumnIndex < columnAccents.length) {
      columnAccents[joinKeyColumnIndex] = resolvedJoinAccent;
    }

    return output(
      joinKeyColumnIndex: joinKeyColumnIndex,
      framePadding: framePadding,
      joinKeyAccentColor: resolvedJoinAccent,
      columnAccentColors: columnAccents,
    );
  }

  static TableStyle forInputPosition(
    int position, {
    int? joinKeyColumnIndex,
    double? framePadding,
    Color? primaryJoinAccent,
  }) {
    switch (position) {
      case 0:
        return inputPrimary(
          joinKeyColumnIndex: joinKeyColumnIndex,
          framePadding: framePadding,
          joinKeyAccentColor: primaryJoinAccent,
        );
      case 1:
        return inputSecondary(
          joinKeyColumnIndex: joinKeyColumnIndex,
          framePadding: framePadding,
          joinKeyAccentColor: primaryJoinAccent,
        );
      case 2:
        return inputTertiary(
          joinKeyColumnIndex: joinKeyColumnIndex,
          framePadding: framePadding,
          joinKeyAccentColor: primaryJoinAccent,
        );
      default:
        return inputTertiary(
          joinKeyColumnIndex: joinKeyColumnIndex,
          framePadding: framePadding,
          joinKeyAccentColor: primaryJoinAccent,
        );
    }
  }

  static Color _boostColor(
    Color color, {
    double saturationDelta = 0.1,
    double valueDelta = 0.1,
  }) {
    final HSVColor hsv = HSVColor.fromColor(color);
    final double newSaturation = (hsv.saturation + saturationDelta).clamp(
      0.0,
      1.0,
    );
    final double newValue = (hsv.value + valueDelta).clamp(0.0, 1.0);
    return hsv
        .withSaturation(newSaturation)
        .withValue(newValue)
        .toColor()
        .withValues(alpha: color.a);
  }
}

