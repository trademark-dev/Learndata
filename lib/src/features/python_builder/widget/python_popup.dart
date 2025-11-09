import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class PythonPopup extends StatelessWidget {
  final VoidCallback? onSkip;
  final VoidCallback? onHints;
  final VoidCallback? onReset;

  const PythonPopup({
    super.key,
    this.onSkip,
    this.onHints,
    this.onReset,
  });

  Widget _buildMenuItem({
    required String iconPath,
    required String text,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 18.w,
              height: 18.h,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Absorb tap events to prevent dismissing when clicking inside popup
      child: Container(
        width: 200.w,
        margin: EdgeInsets.fromLTRB(0, 0, 14.w, 0),
        child: GlassBox(
          radius: 10,
          width: 200.w,
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Background color overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0x8004578C), // #04578C80
                  ),
                ),
              ),
              // Content box with padding
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 0.w, 8.w, 0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Skip menu item
                    _buildMenuItem(
                      iconPath: AppIcons.skipIcon,
                      text: 'Skip',
                      onTap: onSkip,
                    ),
                    SizedBox(height: 0.h),
                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0xFF185079).withOpacity(0),
                            const Color(0xFF185079),
                            const Color(0xFF185079).withOpacity(0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    SizedBox(height: 0.h),
                    // Hints menu item
                    _buildMenuItem(
                      iconPath: AppIcons.hintIcon,
                      text: 'Hints',
                      onTap: onHints,
                    ),
                    SizedBox(height: 0.h),
                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0xFF185079).withOpacity(0),
                            const Color(0xFF185079),
                            const Color(0xFF185079).withOpacity(0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    SizedBox(height: 0.h),
                    // Reset menu item
                    _buildMenuItem(
                      iconPath: AppIcons.resetIcon,
                      text: 'Reset',
                      onTap: onReset,
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

