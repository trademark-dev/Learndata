import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/fonts.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';

class SqlBuilderCanvas extends StatelessWidget {
  final List<String> blocks;
  final ValueChanged<String> onBlockDropped;
  final ValueChanged<int>? onRemoveBlock;
  final VoidCallback? onClear;

  const SqlBuilderCanvas({
    super.key,
    required this.blocks,
    required this.onBlockDropped,
    this.onRemoveBlock,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DragTarget<String>(
          onWillAccept: (_) => true,
          onAccept: onBlockDropped,
          builder: (context, candidateData, rejectedData) {
            final isActive = candidateData.isNotEmpty;
            return GlassBox(
              radius: 16,
              width: constraints.maxWidth,
              padding: EdgeInsets.zero,
              child: Stack(
            children: [
              AnimatedContainer(
                padding: EdgeInsets.all(16.w),
                duration: const Duration(milliseconds: 200),
                constraints: BoxConstraints(minHeight: 160.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (blocks.isNotEmpty && onClear != null)
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: onClear,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
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
                    if (blocks.isNotEmpty && onClear != null)
                      SizedBox(height: 14.h),
                    if (blocks.isEmpty && candidateData.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppIcons.dropIcon,
                              width: 48.w,
                              height: 48.w,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              'Drag blocks here',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                fontSize: 13.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Drop from the palette to start building your query.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 12.sp,
                                height: 1.4,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          ...blocks
                              .asMap()
                              .entries
                              .map(
                                (entry) => _CanvasChip(
                                  label: entry.value,
                                  onRemove: onRemoveBlock != null
                                      ? () => onRemoveBlock!(entry.key)
                                      : null,
                                ),
                              )
                              .toList(),
                          ...candidateData
                              .whereType<String>()
                              .map(
                                (value) => _CanvasChip(
                                  label: value,
                                  isPreview: true,
                                ),
                              ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
              ),
            );
          },
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
    final chipContent = Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: LinearGradient(
          colors: isPreview
              ? [
                  const Color(0xFF68C5FF).withOpacity(0.35),
                  const Color(0xFFEA74FF).withOpacity(0.35),
                ]
              : [
                  const Color(0xFF093B5A),
                  const Color(0x80093B5A),
                ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(isPreview ? 0.6 : 0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.geistMono,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          height: 1.2,
          color: Colors.white,
        ),
      ),
    );

    if (onRemove == null || isPreview) {
      return chipContent;
    }

    return GestureDetector(
      onTap: onRemove,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          chipContent,
          Positioned(
            top: -6.h,
            right: -6.w,
            child: Container(
              width: 16.w,
              height: 16.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.close,
                size: 10.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

