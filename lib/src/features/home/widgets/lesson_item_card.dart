import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';
import 'package:d99_learn_data_enginnering/src/features/select_skill/page/select_skill_page.dart';
import 'package:d99_learn_data_enginnering/src/features/lesson_visual/page/lesson_visual_page.dart';
import 'package:d99_learn_data_enginnering/src/features/qiuze/page/take_quiz_page.dart';
import 'package:d99_learn_data_enginnering/src/features/sql_builder/page/sql_builder_page.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/page/python_builder_page.dart';

class LessonItemCard extends StatelessWidget {
  final String title;
  final String percentage;
  final bool hasTick;
  final bool isLocked;
  final Color backgroundColor;
  final double borderWidth;
  final bool showDashedLine;
  final String? route;
  
  const LessonItemCard({
    super.key,
    required this.title,
    required this.percentage,
    this.hasTick = false,
    this.isLocked = false,
    this.backgroundColor = const Color(0xFF11446A),
    this.borderWidth = 1.0,
    this.showDashedLine = false,
    this.route,
  });

  Widget? _resolveDestination() {
    switch (route) {
      case '/lesson-visual':
        return const LessonVisualPage();
      case '/take-quiz':
        return const TakeQuizPage();
      case '/sql-builder':
        return const SqlBuilderPage();
      case '/python-builder':
        return const PythonBuilderPage();
      case '/select-skill':
      case null:
      case '':
        return const SelectSkill();
      default:
        return const SelectSkill();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Parse completion from percentage string like '100%'
    final String pctStr = percentage.trim().replaceAll('%', '');
    final int? pct = int.tryParse(pctStr);
    final bool isComplete = (pct != null && pct == 100);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: !isLocked
          ? () {
              final destination = _resolveDestination();
              if (destination != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => destination),
                );
              }
            }
          : null,
      child: Stack(
      children: [
        Row(
          children: [
            // Circle on left
            Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isComplete && !isLocked ? AppColors.blue : AppColors.circleDarkBg,
                border: !isComplete || isLocked ? Border.all(color: AppColors.blue, width: 3.2) : null,
              ),
              child: isComplete && !isLocked
                  ? Icon(
                      Icons.check,
                      size: 8.sp,
                      color: Colors.black,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            // Lesson item card
            Expanded(
              child: GlassBox(
                radius: 8,
                height: 36.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        height: 1.3,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        if (!isLocked)
                          Text(
                            percentage,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              height: 1.3,
                              color: Colors.white,
                            ),
                          ),
                        if (!isLocked) SizedBox(width: 6.w),
                        if (isLocked)
                          SvgPicture.asset(
                            AppIcons.lockIcon,
                            width: 16.w,
                            height: 16.h,
                          )
                        else
                          SvgPicture.asset(
                            AppIcons.rightArrow,
                            width: 16.w,
                            height: 16.h,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Dashed vertical line under circle
        if (showDashedLine)
          Positioned(
            left: 6.w,
            top: 12.h,
            child: CustomPaint(
              size: Size(0, 24.h),
              painter: DashedLinePainter(),
            ),
          ),
      ],
    ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + 2), paint);
      startY += 4;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

