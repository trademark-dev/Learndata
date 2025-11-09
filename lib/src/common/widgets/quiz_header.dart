import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';

class QuizHeader extends StatelessWidget {
  final String currentProgress; // e.g., "4/13"
  final double progressValue; // e.g., 0.3 for 30%

  const QuizHeader({
    super.key,
    required this.currentProgress,
    required this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: SvgPicture.asset(
            AppIcons.backIcon,
            width: 24.w,
            height: 24.h,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quiz',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        height: 1.3,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      currentProgress,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        height: 1.3,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 4.h),
              // Progress bar
              Container(
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11.r),
                  color: const Color(0x1AFFFFFF), // #FFFFFF1A
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final filledWidth = constraints.maxWidth * progressValue;
                    return Stack(
                      children: [
                        // Filled portion
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: filledWidth,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(11.r),
                              bottomLeft: Radius.circular(11.r),
                              topRight: progressValue >= 1.0 ? Radius.circular(11.r) : Radius.zero,
                              bottomRight: progressValue >= 1.0 ? Radius.circular(11.r) : Radius.zero,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF68C5FF), // #68C5FF
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        RippleService.wrapWithRipple(
          onTap: () {
            // Handle settings tap
          },
          borderRadius: 12.r,
          rippleColor: Colors.white.withOpacity(0.2),
          child: SvgPicture.asset(
            AppIcons.settingIcon,
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}

