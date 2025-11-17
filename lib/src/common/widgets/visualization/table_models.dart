import 'dart:ui' show Color, Rect;

class FlashState {
  final Color? color;
  final int? columnIndex;

  const FlashState({this.color, this.columnIndex});
}

class ColumnData {
  final String name;

  const ColumnData({required this.name});
}

class TableData {
  final String name;
  final List<ColumnData> columns;
  final List<List<dynamic>> rows;
  final TableStyle style;

  const TableData({
    required this.name,
    required this.columns,
    required this.rows,
    required this.style,
  });

  int get rowCount => rows.length;
  int get columnCount => columns.length;
}

enum TableRole { input, output }

class TableStyle {
  final Color accentColor;
  final List<Color> columnAccentColors;
  final int? joinKeyColumnIndex;
  final double framePadding;
  final TableRole role;
  final Color? joinKeyAccentColor;
  final Color? headerBackground;
  final Color? headerBorderColor;
  final Color? rowBackground;
  final Color? zebraBackground;
  final Color? rowBorderColor;
  final Color? dividerColor;
  final Color? tableBorderColor;
  final Color? headerTextColor;
  final Color? cellTextColor;

  const TableStyle({
    required this.accentColor,
    this.columnAccentColors = const <Color>[],
    this.joinKeyColumnIndex,
    this.framePadding = 2.0,
    this.role = TableRole.input,
    this.joinKeyAccentColor,
    this.headerBackground,
    this.headerBorderColor,
    this.rowBackground,
    this.zebraBackground,
    this.rowBorderColor,
    this.dividerColor,
    this.tableBorderColor,
    this.headerTextColor,
    this.cellTextColor,
  });

  Color columnAccentFor(int columnIndex) {
    if (columnAccentColors.isEmpty) {
      return accentColor;
    }
    if (columnIndex < 0) {
      return columnAccentColors.first;
    }
    if (columnIndex >= columnAccentColors.length) {
      return columnAccentColors.last;
    }
    return columnAccentColors[columnIndex];
  }

  Color resolvedJoinKeyAccent() => joinKeyAccentColor ?? accentColor;
}

class TableCellValue {
  final dynamic value;
  final Color? accentOverride;
  final Color? textColorOverride;
  final bool isPlaceholder;

  const TableCellValue(
    this.value, {
    this.accentOverride,
    this.textColorOverride,
    this.isPlaceholder = false,
  });

  @override
  String toString() => value?.toString() ?? '';
}

typedef CellGeometryCallback = void Function(CellGeometry geometry);

class CellGeometry {
  final int tableIndex;
  final int rowIndex;
  final int columnIndex;
  final Rect globalRect;

  const CellGeometry({
    required this.tableIndex,
    required this.rowIndex,
    required this.columnIndex,
    required this.globalRect,
  });
}

class ScanHighlight {
  final int tableIndex;
  final int rowIndex;
  final int? columnIndex;
  final bool isOutput;

  const ScanHighlight({
    required this.tableIndex,
    required this.rowIndex,
    this.columnIndex,
    this.isOutput = false,
  });
}

class FlashInstruction {
  final int tableIndex;
  final int rowIndex;
  final int? columnIndex;
  final bool isOutput;
  final int cycles;
  final Duration totalDuration;
  final Duration startDelay;
  final bool stayOnAfter;
  final Color? color;

  const FlashInstruction({
    required this.tableIndex,
    required this.rowIndex,
    this.columnIndex,
    this.isOutput = false,
    this.cycles = 2,
    this.totalDuration = const Duration(milliseconds: 500),
    this.startDelay = Duration.zero,
    this.stayOnAfter = false,
    this.color,
  });
}

class CellTransferInstruction {
  final int fromTableIndex;
  final int fromRowIndex;
  final int fromColumnIndex;
  final int toTableIndex;
  final int toRowIndex;
  final int toColumnIndex;
  final dynamic value;
  final Duration duration;
  final Duration startDelay;
  final bool holdAtDestination;

  const CellTransferInstruction({
    required this.fromTableIndex,
    required this.fromRowIndex,
    required this.fromColumnIndex,
    required this.toTableIndex,
    required this.toRowIndex,
    required this.toColumnIndex,
    required this.value,
    this.duration = const Duration(milliseconds: 600),
    this.startDelay = const Duration(milliseconds: 120),
    this.holdAtDestination = true,
  });
}

class FrameData {
  final List<ScanHighlight> highlights;
  final List<List<dynamic>>? outputRows;
  final String description;
  final Duration holdDelay;
  final List<FlashInstruction> flashes;
  final List<CellTransferInstruction> transfers;
  final Map<int, Set<int>> mutedRows; // tableIndex -> Set of row indices

  const FrameData({
    required this.highlights,
    this.outputRows,
    required this.description,
    this.holdDelay = Duration.zero,
    this.flashes = const [],
    this.transfers = const [],
    this.mutedRows = const {},
  });
}

