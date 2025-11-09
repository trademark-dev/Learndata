import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/custom_button.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class LessonWidget extends StatefulWidget {
  const LessonWidget({super.key});

  @override
  State<LessonWidget> createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation for progress bar from 0 to 50%
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    
    // Start animation when widget builds
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      radius: 16,
          width: double.infinity,
      padding: EdgeInsets.zero,
      child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CURRENT LESSON',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                  height: 1.3,
                                  letterSpacing: 10.sp * 0.02,
                                  color: AppColors.textLightBlue,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'SQL: Query Structure',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  height: 1.3,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // RESUME button at top right
                        CustomButton(
                          text: 'RESUME',
                          icon: AppIcons.puseIcon,
                          iconWidth: 16,
                          iconHeight: 16,
                          onPressed: null,
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    // Progress bar section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            height: 1.3,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '50%',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            height: 1.3,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // Progress bar - simple solution
                    Container(
                      height: 4.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11.r),
                        color: AppColors.progressBackground,
                      ),
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Row(
                            children: [
                              // Filled portion - animated from 0% to 50%
                              Expanded(
                                flex: (200 * _progressAnimation.value).round(),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(11.r),
                                    bottomLeft: Radius.circular(11.r),
                                    topRight: Radius.circular(11.r),
                                    bottomRight: Radius.circular(11.r),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.progressDarkBlue,
                                          AppColors.progressLightBlue,
                                        ],
                                        stops: const [0.5036, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Unfilled portion - remaining space
                              Expanded(
                                flex: (200 * (1 - _progressAnimation.value)).round(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(11.r),
                                      bottomRight: Radius.circular(11.r),
                                    ),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        // First column - Completed
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '15',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    height: 1.3,
                                    color: AppColors.statsTextColor,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp,
                                    height: 1.3,
                                    color: AppColors.statsLabelColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Divider between first and second
                        Container(
                          width: 1,
                          height: 40.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.statsBorderColor.withOpacity(0),
                                AppColors.statsBorderColor.withOpacity(1),
                              ],
                            ),
                          ),
                        ),
                        // Second column - Streaks
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '12',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    height: 1.3,
                                    color: AppColors.statsTextColor,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'Streaks',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp,
                                    height: 1.3,
                                    color: AppColors.statsLabelColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Divider between second and third
                        Container(
                          width: 1,
                          height: 40.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppColors.statsBorderColor.withOpacity(0),
                                AppColors.statsBorderColor.withOpacity(1),
                              ],
                            ),
                          ),
                        ),
                        // Third column - Total XP
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '180',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    height: 1.3,
                                    color: AppColors.statsTextColor,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'Total XP',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.sp,
                                    height: 1.3,
                                    color: AppColors.statsLabelColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 10.h), // Add bottom spacing instead of Spacer
                  ],
        ),
      ),
    );
  }
}
