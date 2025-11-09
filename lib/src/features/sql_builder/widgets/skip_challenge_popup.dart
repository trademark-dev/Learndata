import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class SkipChallengePopup extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSkipAway;

  const SkipChallengePopup({
    super.key,
    this.onCancel,
    this.onSkipAway,
  });

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required VoidCallback? onPressed,
  }) {
    return RippleService.wrapWithRipple(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed?.call();
      },
      borderRadius: 50.r,
      rippleColor: Colors.white.withOpacity(0.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            height: 33.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: backgroundColor,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Content
                Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      height: 1.3,
                      letterSpacing: 13.sp * 0.04,
                      color: Colors.white,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: const Color(0x801DB2DC), // #1DB2DC80 for correct (transparent)
                ),
              ),
            ),
            // Content box with padding
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // "Skip this challenge?" text
                  Text(
                    'Skip this challenge?',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      height: 1.3,
                      letterSpacing: 13.sp * 0.04,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  // Description text
                  Text(
                    'Completing it helps you earn XP and progress in your SQL mastery. Do you still want to skip?',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      height: 1.4,
                      color: const Color(0xFFD2E2E9), // #D2E2E9
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // CANCEL and SKIP AWAY buttons row
                  Row(
                    children: [
                      // CANCEL button
                      Expanded(
                        child: _buildButton(
                          text: 'CANCEL',
                          backgroundColor: const Color(0x1AFFFFFF), // #FFFFFF1A
                          onPressed: onCancel,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // SKIP AWAY button
                      Expanded(
                        child: _buildButton(
                          text: 'SKIP AWAY',
                          backgroundColor: const Color(0x801DB2DC), // #1DB2DC80
                          onPressed: onSkipAway,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Icon on right side
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(
                AppIcons.arrowPopupIcon,
                width: 128.w,
                height: 128.h,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

