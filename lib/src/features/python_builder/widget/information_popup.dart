import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class InformationPopup extends StatelessWidget {
  final VoidCallback? onClose;

  const InformationPopup({
    super.key,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Absorb tap events to prevent dismissing when clicking inside popup
      child: Container(
        margin: EdgeInsets.fromLTRB(11.w, 0, 11.w, 11.h),
        child: GlassBox(
          radius: 36,
          width: double.infinity,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Background color overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36.r),
                    color: const Color(0x8004578C), // #04578C80
                  ),
                ),
              ),
              // Content box with padding
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      Row(
                        children: [
                          // Left side - Icon and text
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.compilledFaildIcon,
                                width: 16.w,
                                height: 16.h,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'COMPILATION FAILED',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  height: 1.3,
                                  letterSpacing: 12.sp * 0.04,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          // Right side - Steps text
                          const Spacer(),
                          Text(
                            'STEPS 0/17',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              height: 1.3,
                              letterSpacing: 12.sp * 0.04,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      // Progress bar
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Progress bar track
                          Container(
                            width: double.infinity,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E4969), // #1E4969
                              borderRadius: BorderRadius.circular(11.r),
                            ),
                          ),
                          // Progress indicator (dart)
                          Positioned(
                            left: 0,
                            top: -2.h,
                            child: Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: Colors.white, // #FFFFFF
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      // INFORMATION section
                      Row(
                        children: [
                          Text(
                            'INFORMATION',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              height: 1.3,
                              letterSpacing: 12.sp * 0.04,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF1C4F75),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      // Content section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header text
                          Text(
                            'Here\'s what might help you fix it:',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              height: 1.4,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          // First point
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 2.w,
                                  height: 2.h,
                                  margin: EdgeInsets.only(top: 5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    'Check your variable names — make sure they match exactly.',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      height: 1.4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3.h),
                          // Second point
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 2.w,
                                  height: 2.h,
                                  margin: EdgeInsets.only(top: 5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    'Watch out for missing colons (:) or parentheses.',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      height: 1.4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3.h),
                          // Third point
                          Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 2.w,
                                  height: 2.h,
                                  margin: EdgeInsets.only(top: 5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    'Try running smaller parts of your code to isolate the issue.',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp,
                                      height: 1.4,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      // Row with 2 columns
                      Row(
                        children: [
                            ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                              child: RippleService.wrapWithRipple(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                },
                                borderRadius: 50.r,
                                rippleColor: Colors.white.withOpacity(0.2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.r),
                                    color: const Color(0x1AFFFFFF), // #FFFFFF1A
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x800A101D), // #0A101D80
                                        offset: const Offset(0, 14),
                                        blurRadius: 14,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Content with padding
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              AppIcons.editIcon,
                                              width: 16.w,
                                              height: 16.h,
                                              colorFilter: const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              'EDITOR',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                                height: 1.3,
                                                letterSpacing: 12.sp * 0.04,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
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
                                      // Left gradient border
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        bottom: 0,
                                        width: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
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
                            ),
                          ),
                          // Spacer
                          const Spacer(),
                          // Right column - INFO button
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                              child: RippleService.wrapWithRipple(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                },
                                borderRadius: 50.r,
                                rippleColor: Colors.black.withOpacity(0.2),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.r),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0x800A101D),
                                        offset: const Offset(0, 14),
                                        blurRadius: 14,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Content with padding
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              AppIcons.infoIcon,
                                              width: 16.w,
                                              height: 16.h,
                                              colorFilter: const ColorFilter.mode(
                                                Color(0xFF000000),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              'INFO',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                                height: 1.3,
                                                letterSpacing: 12.sp * 0.04,
                                                color: const Color(0xFF000000),
                                              ),
                                            ),
                                          ],
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
                                      // Left gradient border
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        bottom: 0,
                                        width: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
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
                            ),
                          ),
                        ],  
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

