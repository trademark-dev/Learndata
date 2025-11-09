import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

enum FeedbackType {
  correct,
  wrong,
  info,
}

class QuizFeedbackCard extends StatelessWidget {
  final FeedbackType type;
  final VoidCallback? onWhyPressed;
  final VoidCallback? onNextPressed;
  final VoidCallback? onHintPressed;
  final VoidCallback? onTryAgainPressed;

  const QuizFeedbackCard({
    super.key,
    required this.type,
    this.onWhyPressed,
    this.onNextPressed,
    this.onHintPressed,
    this.onTryAgainPressed,
  });

  Widget _buildContent() {
    if (type == FeedbackType.correct) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tick icon and "Correct Answer!" text
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.popupTickicon,
                width: 18.w,
                height: 18.h,
              ),
              SizedBox(width: 3.w),
              Text(
                'CORRECT ANSWER!',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  height: 1.3,
                  letterSpacing: 13.sp * 0.04,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Description text
          Text(
            'DISTINCT must come immediately after SELECT, not after WHERE.',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              height: 1.4,
              color: const Color(0xFFD2E2E9), // #D2E2E9
            ),
          ),
          SizedBox(height: 20.h),
          // WHY and NEXT buttons row
          Row(
            children: [
              // WHY button
              Expanded(
                child: _buildButton(
                  text: 'WHY',
                  backgroundColor: const Color(0x1AFFFFFF), // #FFFFFF1A
                  onPressed: onWhyPressed,
                ),
              ),
              SizedBox(width: 10.w),
              // NEXT button
              Expanded(
                child: _buildButton(
                  text: 'NEXT',
                  backgroundColor: const Color(0x801DB2DC), // #1DB2DC80
                  onPressed: onNextPressed,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (type == FeedbackType.wrong) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cross icon and "Not quite right" text
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.popupCrossicon,
                width: 18.w,
                height: 18.h,
              ),
              SizedBox(width: 3.w),
              Text(
                'NOT QUITE RIGHT',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  height: 1.3,
                  letterSpacing: 13.sp * 0.04,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Description text
          Text(
            'You\'re close! The parentheses are important here to make SQL evaluate in the right order.',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              height: 1.4,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.h),
          // HINT and TRY AGAIN buttons row
          Row(
            children: [
              // HINT button
              Expanded(
                child: _buildButton(
                  text: 'HINT',
                  backgroundColor: const Color(0x1AFFFFFF), // #FFFFFF1A
                  onPressed: onHintPressed,
                ),
              ),
              SizedBox(width: 10.w),
              // TRY AGAIN button
              Expanded(
                child: _buildButton(
                  text: 'TRY AGAIN',
                  backgroundColor: const Color(0xB2D63F41), // #D63F41B2
                  onPressed: onTryAgainPressed,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (type == FeedbackType.info) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top box with gradient background
          GlassBox(
            radius: 16,
            width: double.infinity,
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                // Background gradients
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0x1A009CFF), // rgba(0, 156, 255, 0.1) bottom
                          Color(0x1A009CFF), // rgba(0, 156, 255, 0.1) top
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x1AFFFFFF), // rgba(255, 255, 255, 0.1) top
                          Colors.transparent, // rgba(255, 255, 255, 0) bottom
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Circle with "A"
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                          child: Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0x1AFFFFFF), // #FFFFFF1A
                            ),
                            child: Center(
                              child: Text(
                                'A',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Text content
                      Expanded(
                        child: Text(
                          'The DISTINCT keyword is in the wrong position; parentheses are needed around the WHERE conditions to enforce correct precedence.',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
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
          ),
          SizedBox(height: 14.h),
          // Explanation section with header and line
          Row(
            children: [
              Text(
                'EXPLANATION',
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
                        const Color(0xFF1A2E45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Explanation text
          Text(
            'The DISTINCT keyword is used to retrieve unique values, but it must be placed right after SELECT to apply to the entire result set, not after WHERE, which filters rows. Placing it after WHERE is syntactically incorrect and changes the query\'s intent.',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              height: 1.4,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2.h),
          // Next button
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              width: 180.w,
              height: 33.h,
              child: RippleService.wrapWithRipple(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onNextPressed?.call();
                },
                borderRadius: 50.r,
                rippleColor: Colors.white.withOpacity(0.2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0x80034F90), // rgba(3, 79, 144, 0.5)
                            const Color(0x80009DFF), // rgba(0, 157, 255, 0.5)
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'NEXT',
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
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

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
          filter: ImageFilter.blur(
            sigmaX: backgroundColor == const Color(0xB2D63F41) ? 32 : 0,
            sigmaY: backgroundColor == const Color(0xB2D63F41) ? 32 : 0,
          ),
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
                // Top gradient border (lesson_widget.dart style)
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // Background color based on feedback type
    final Color backgroundColor = type == FeedbackType.wrong
        ? const Color(0xB29D3B3C) // #9D3B3CB2 for wrong (transparent)
        : type == FeedbackType.info
            ? const Color(0x8004578C) // #04578C80 for info (transparent)
            : const Color(0x801DB2DC); // #1DB2DC80 for correct (transparent)

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
                  color: backgroundColor,
                ),
              ),
            ),
            // Content box with padding
            Padding(
              padding: EdgeInsets.all(20.w),
              child: _buildContent(),
            ),
            // Icon in top right
            Positioned(
              top: 0,
              right: 0,
              child: type == FeedbackType.correct
                  ? SvgPicture.asset(
                      AppIcons.correctAns,
                      width: 120.w,
                      height: 99.h,
                      fit: BoxFit.contain,
                    )
                  : type == FeedbackType.wrong
                      ? Container(
                          width: 128.w,
                          height: 128.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFE5E6EB).withOpacity(0.075),
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40000000), // #00000040
                                offset: Offset(0, 4),
                                blurRadius: 32,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Icon - positioned on right side
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.wrongAns,
                                    width: 128.w,
                                    height: 128.h,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              // Border gradient effect (vertical gradient from top to bottom)
                              // The border itself has the gradient, we just overlay a subtle gradient for the border effect
                              // Top border gradient overlay
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(0xFFE5E6EB).withOpacity(0.075),
                                        const Color(0xFFE5E6EB).withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Left border gradient overlay
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
                                        const Color(0xFFE5E6EB).withOpacity(0.075),
                                        const Color(0xFFE5E6EB).withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Right border gradient overlay
                              Positioned(
                                top: 0,
                                right: 0,
                                bottom: 0,
                                width: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(0xFFE5E6EB).withOpacity(0.075),
                                        const Color(0xFFE5E6EB).withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom border gradient overlay
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(0xFFE5E6EB).withOpacity(0.075),
                                        const Color(0xFFE5E6EB).withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

