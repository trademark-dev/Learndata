import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class RunResultPopup extends StatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onShowCompiledFailed;

  const RunResultPopup({
    super.key,
    this.onClose,
    this.onShowCompiledFailed,
  });

  @override
  State<RunResultPopup> createState() => _RunResultPopupState();
}

class _RunResultPopupState extends State<RunResultPopup> {
  bool _isPlaying = false; // Start with play icon

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
                                AppIcons.blurTick,
                                width: 16.w,
                                height: 16.h,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'COMPILATION SUCCESSFUL',
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
                      // Row with 2 columns
                      Row(
                        children: [
                          // Left column - EDITOR button
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
                                        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
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
                          // Right column - Playback controls
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.playBackicon,
                                  width: 24.w,
                                  height: 24.h,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                SvgPicture.asset(
                                  AppIcons.playBackCircal,
                                  width: 24.w,
                                  height: 24.h,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                SvgPicture.asset(
                                  AppIcons.playNextCircal,
                                  width: 24.w,
                                  height: 24.h,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                SvgPicture.asset(
                                  AppIcons.playNextIcon,
                                  width: 24.w,
                                  height: 24.h,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                // Play/Pause button
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    if (!_isPlaying) {
                                      // If was not playing, now playing - show compiled failed popup
                                      widget.onShowCompiledFailed?.call();
                                    } else {
                                      // If was playing, now pausing - just toggle state
                                      setState(() {
                                        _isPlaying = !_isPlaying;
                                      });
                                    }
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        width: 46.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50.r),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0x1AFFFFFF), // rgba(255, 255, 255, 0.1)
                                              Color(0x1AFFFFFF), // rgba(255, 255, 255, 0.1)
                                            ],
                                          ),
                                         
                                        ),
                                        child: Stack(
                                          children: [
                                            // Icon
                                            Center(
                                              child: SvgPicture.asset(
                                                _isPlaying ? AppIcons.pauseIconSvg : AppIcons.playicon,
                                                width: 16.w,
                                                height: 16.h,
                                                colorFilter: const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                            // Gradient border - top
                                           
                                            // Gradient border - left side
                                           
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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

