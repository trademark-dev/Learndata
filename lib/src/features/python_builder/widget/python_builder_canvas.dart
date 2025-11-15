import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/fonts.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/all_types_python_widgets.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/model/block_metadata.dart';

class CanvasDropDetails {
  final int rowIndex;
  final bool insertAsNewRow;

  const CanvasDropDetails({
    required this.rowIndex,
    this.insertAsNewRow = false,
  });
}

class PythonBuilderCanvas extends StatelessWidget {
  final List<List<String>> rows;
  final void Function(String block, CanvasDropDetails details) onBlockDropped;
  final void Function(int rowIndex, int blockIndex)? onRemoveBlock;
  final VoidCallback? onClear;

  const PythonBuilderCanvas({
    super.key,
    required this.rows,
    required this.onBlockDropped,
    this.onRemoveBlock,
    this.onClear,
  });

  bool get _hasRows => rows.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GlassBox(
          radius: 16,
          width: constraints.maxWidth,
          padding: EdgeInsets.zero,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(10.w),
            constraints: BoxConstraints(minHeight: 160.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_hasRows && onClear != null)
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: onClear,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.white.withOpacity(0.08),
                        ),
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 11.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_hasRows && onClear != null) SizedBox(height: 10.h),
                if (!_hasRows)
                  _EmptyCanvasDropTarget(
                    onAccept: (value) => onBlockDropped(
                      value,
                      const CanvasDropDetails(
                        rowIndex: 0,
                        insertAsNewRow: true,
                      ),
                    ),
                  )
                else
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(
                        rows.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == rows.length - 1 ? 12.h : 8.h,
                          ),
                          child: _RowDropTarget(
                            blocks: rows[index],
                            onDrop: (block) => onBlockDropped(
                              block,
                              CanvasDropDetails(rowIndex: index),
                            ),
                            onRemove: onRemoveBlock != null
                                ? (chipIndex) =>
                                    onRemoveBlock!(index, chipIndex)
                                : null,
                          ),
                        ),
                      ),
                      _AddLineDropTarget(
                        onDrop: (block) => onBlockDropped(
                          block,
                          CanvasDropDetails(
                            rowIndex: rows.length,
                            insertAsNewRow: true,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RowDropTarget extends StatelessWidget {
  final List<String> blocks;
  final ValueChanged<String> onDrop;
  final ValueChanged<int>? onRemove;

  const _RowDropTarget({
    required this.blocks,
    required this.onDrop,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAccept: (_) => true,
      onAccept: onDrop,
      builder: (context, candidateData, rejectedData) {
        final List<String> previews =
            candidateData.whereType<String>().toList();
        final List<Widget> chipWidgets = [
          ...blocks.asMap().entries.map(
                (entry) => _CanvasChip(
                  label: entry.value,
                  onRemove: onRemove != null
                      ? () => onRemove!(entry.key)
                      : null,
                ),
              ),
          ...previews.map(
            (value) => _CanvasChip(
              label: value,
              isPreview: true,
            ),
          ),
        ];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
          constraints: BoxConstraints(minHeight: 8.h),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10.r),
          //   color: isActive
          //       ? Colors.white.withOpacity(0.06)
          //       : Colors.white.withOpacity(0.02),
          //   border: Border.all(
          //     color: isActive
          //         ? Colors.white.withOpacity(0.35)
          //         : Colors.white.withOpacity(0.08),
          //     width: 1,
          //   ),
          // ),
          child: chipWidgets.isEmpty
              ? const SizedBox.shrink()
              : Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12.w,
                  runSpacing: 10.h,
                  children: chipWidgets,
                ),
        );
      },
    );
  }
}

class _AddLineDropTarget extends StatelessWidget {
  final ValueChanged<String> onDrop;

  const _AddLineDropTarget({required this.onDrop});

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAccept: (_) => true,
      onAccept: onDrop,
      builder: (context, candidateData, rejectedData) {
        final bool isActive = candidateData.isNotEmpty;
        final List<String> previews =
            candidateData.whereType<String>().toList();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isActive
                  ? Colors.white.withOpacity(0.45)
                  : Colors.white.withOpacity(0.16),
              width: 1,
            ),
            color: isActive
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.015),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.keyboard_return,
                size: 16.sp,
                color: Colors.white.withOpacity(0.75),
              ),
              SizedBox(width: 8.w),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  'Drop here to start a new line',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ),
              if (previews.isNotEmpty) ...[
                SizedBox(width: 8.w),
                _CanvasChip(
                  label: previews.first,
                  isPreview: true,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _EmptyCanvasDropTarget extends StatelessWidget {
  final ValueChanged<String> onAccept;

  const _EmptyCanvasDropTarget({required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAccept: (_) => true,
      onAccept: onAccept,
      builder: (context, candidateData, rejectedData) {
        final bool isActive = candidateData.isNotEmpty;
        final List<String> previews =
            candidateData.whereType<String>().toList();

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 12.w),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(12.r),
          //   border: Border.all(
          //     color: isActive
          //         ? Colors.white.withOpacity(0.45)
          //         : Colors.white.withOpacity(0.12),
          //     width: 1,
          //   ),
          //   color: isActive
          //       ? Colors.white.withOpacity(0.05)
          //       : Colors.transparent,
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppIcons.pythonIcon,
                width: 48.w,
                height: 48.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                isActive ? 'Release to drop' : 'Drag blocks here',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Drop snippets from the palette to assemble your Python logic.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 12.sp,
                  height: 1.4,
                  color: Colors.white.withOpacity(0.75),
                ),
              ),
              if (previews.isNotEmpty) ...[
                SizedBox(height: 12.h),
                _CanvasChip(
                  label: previews.first,
                  isPreview: true,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _CanvasChip extends StatelessWidget {
  final String label;
  final VoidCallback? onRemove;
  final bool isPreview;

  const _CanvasChip({
    required this.label,
    this.onRemove,
    this.isPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = _buildChipContent();

    if (isPreview) {
      content = Opacity(opacity: 0.6, child: content);
    }

    if (onRemove == null || isPreview) {
      return content;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onRemove,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(
            top: -8.h,
            right: -8.w,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onRemove,
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(
                  Icons.close,
                  size: 14.sp,
                  color: const Color.fromARGB(255, 255, 71, 71),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipContent() {
    final Widget? specialChip = _buildSpecialChip();
    if (specialChip != null) {
      return specialChip;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.geistMono,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          height: 1.2,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget? _buildSpecialChip() {
    final _PairConnectorDescriptor? pairDescriptor =
        _PairConnectorDescriptor.tryParse(label);
    if (pairDescriptor != null) {
      return ToolBarPairConnector(
        label: pairDescriptor.label,
        orderText: pairDescriptor.orderText,
      );
    }
    final ParameterizedBlockDescriptor? parameterizedDescriptor =
        ParameterizedBlockSerializer.tryParse(label);
    if (parameterizedDescriptor != null) {
      final String originalLabel = parameterizedDescriptor.label;
      final String upperLabel = originalLabel.toUpperCase();
      final bool isTwoParamKeyword =
          BlockMetadata.twoParamLabels.contains(upperLabel);
      final bool isOperator = BlockMetadata.symbolLabels.contains(originalLabel);

      if (isTwoParamKeyword || isOperator) {
        return ToolBarTwoParameterConnector(
          leftValue: parameterizedDescriptor.parameterAt(0) ?? 'order',
          label: isOperator ? originalLabel : upperLabel,
          rightValue: parameterizedDescriptor.parameterAt(1) ?? 'order',
        );
      }
      return _buildOneParamChip(
        displayLabel: upperLabel,
        rawLabel: originalLabel,
        parameter: parameterizedDescriptor.parameterAt(0),
      );
    }
    return null;
  }

  Widget _buildOneParamChip({
    required String displayLabel,
    required String rawLabel,
    required String? parameter,
  }) {
    final lowerParam = parameter?.toLowerCase() ?? '';
    if (lowerParam == 'order') {
      return ToolBarPairConnector(label: displayLabel, orderText: 'order');
    }
    if (lowerParam == 'orders') {
      return ToolBarPairConnector(label: displayLabel, orderText: 'orders');
    }
    if (lowerParam == 'total') {
      return ToolBarPairConnector(label: displayLabel, orderText: 'total');
    }
    if (BlockMetadata.digitPattern.hasMatch(lowerParam)) {
      return ToolBarPairConnector(
        label: displayLabel,
        orderText: lowerParam,
      );
    }

    return ToolBarOneParameterBox(
      label: displayLabel,
      parameterValue: parameter,
    );
  }
}

class _PairConnectorDescriptor {
  final String label;
  final String orderText;

  const _PairConnectorDescriptor({
    required this.label,
    required this.orderText,
  });

  static _PairConnectorDescriptor? tryParse(String raw) {
    final String trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    const String prefix = 'pair_connector::';
    final String lower = trimmed.toLowerCase();
    if (!lower.startsWith(prefix)) return null;

    final String remainder = trimmed.substring(prefix.length);
    final List<String> parts = remainder.split('::');
    if (parts.isEmpty) return null;

    final String label = parts.first.isEmpty ? 'FOR' : parts.first;
    final String orderText =
        parts.length > 1 && parts[1].isNotEmpty ? parts[1] : 'order';

    return _PairConnectorDescriptor(
      label: label,
      orderText: orderText,
    );
  }
}

