import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_builder_drag_data.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/model/python_canvas_token.dart';

class PythonBuilderDataPanel extends StatelessWidget {
  const PythonBuilderDataPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DataTableMeta> tables = [
      const _DataTableMeta(
        name: 'orders',
        columns: ['order_id', 'status', 'region', 'profit'],
      ),
      const _DataTableMeta(
        name: 'customers',
        columns: ['customer_id', 'first_name', 'last_name', 'country'],
      ),
    ];

    return GlassBox(
      radius: 16,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      backgroundOpacity: 0.08,
      edgeOpacity: 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DATA',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: tables
                .map((table) => Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: _DataColumn(table: table),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _DataColumn extends StatelessWidget {
  const _DataColumn({required this.table});

  final _DataTableMeta table;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          table.name,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
        SizedBox(height: 6.h),
        ...table.columns.map(
          (column) => Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: _DataColumnChip(label: column),
          ),
        ),
      ],
    );
  }
}

class _DataColumnChip extends StatelessWidget {
  const _DataColumnChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Draggable<PythonBuilderDragData>(
      data: PythonBuilderDragData(
        label: label,
        kind: PythonCanvasTokenKind.variable, // Use variable for column names
      ),
      feedback: _DataChipFeedback(label: label),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: _DataChipBody(label: label),
      ),
      child: _DataChipBody(label: label),
    );
  }
}

class _DataChipBody extends StatelessWidget {
  const _DataChipBody({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      radius: 6,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      backgroundOpacity: 0.16,
      edgeOpacity: 0.45,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Geist Mono',
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _DataChipFeedback extends StatelessWidget {
  const _DataChipFeedback({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: _DataChipBody(label: label),
    );
  }
}

class _DataTableMeta {
  const _DataTableMeta({required this.name, required this.columns});

  final String name;
  final List<String> columns;
}

