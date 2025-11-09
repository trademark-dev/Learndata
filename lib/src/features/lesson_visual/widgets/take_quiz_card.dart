import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';
import 'package:flutter/services.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class TakeQuizCard extends StatelessWidget {
  final VoidCallback? onStartPressed;

  const TakeQuizCard({
    super.key,
    this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      radius: 16,
      width: double.infinity,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Base gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x000E375A), // rgba(14, 55, 90, 0) at 0%
                    Color(0x000E375A), // rgba(14, 55, 90, 0) at 39%
                    Color(0xFF0E375A), // #0E375A at 100%
                  ],
                  stops: [0.0, 0.39, 1.0],
                ),
              ),
            ),
          ),
          // Base light blue wash overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x0F009CFF), // rgba(0, 156, 255, 0.06)
                    Color(0x0F009CFF), // rgba(0, 156, 255, 0.06)
                  ],
                ),
              ),
            ),
          ),
          // Content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left section - Text and button with Stack for positioning
              Expanded(
                child: SizedBox(
                  height: 147.h, // Match image height for proper alignment
                  child: Stack(
                    children: [
                      // Text content at top
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 16.h, 0, 0),
                            child: Text(
                              'Take a Quiz',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                height: 1.3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Description
                          Padding(
                            padding: EdgeInsets.only(left: 16.w),
                            child: Text(
                              'Practice makes perfect — run your logic through a quiz!',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                height: 1.3,
                                color: const Color(0xFFCDCED1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // START button - positioned at bottom left
                      Positioned(
                        left: 16.w,
                        bottom: 16.h,
                        child: RippleService.wrapWithRipple(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            onStartPressed?.call();
                          },
                          borderRadius: 100.r,
                          rippleColor: Colors.white.withOpacity(0.2),
                          child: Stack(
                            children: [
                              Container(
                                height: 33.h,
                                width: 99.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.r),
                                  color: const Color(0x1AFFFFFF), // #FFFFFF1A
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'START',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      height: 1.3,
                                      letterSpacing: 12.sp * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              // Top gradient border
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom gradient border
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withOpacity(0.5),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              // Right section - Image
              Image.asset(
                AppImages.takeQuiz,
                width: 156.w,
                height: 147.h,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
