import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class QuizAnswerItem extends StatelessWidget {
  final String label; // A, B, C, D
  final String text;
  final bool isSelected;
  final Color? selectedBackgroundColor;
  final VoidCallback? onTap;

  const QuizAnswerItem({
    super.key,
    required this.label,
    required this.text,
    this.isSelected = false,
    this.selectedBackgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circle with label
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x1AFFFFFF), // #FFFFFF1A
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Text box
          Expanded(
            child: GlassBox(
              radius: 8,
              width: double.infinity,
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  // Background color overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: isSelected && selectedBackgroundColor != null
                            ? selectedBackgroundColor!
                            : const Color(0x1A009CFF), // #009CFF1A
                      ),
                    ),
                  ),
                  // Content with padding
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        height: 1.4,
                        color: const Color(0xFFCED1D5), // #CED1D5
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
