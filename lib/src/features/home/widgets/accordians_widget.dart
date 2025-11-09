import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/features/home/widgets/lesson_item_card.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';
class AccordiansWidget extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  final String completedText;
  final String percentage;
  final double progressValue;
  final int numberOfLessons;
  final List<Map<String, String>> lessonItems;
  
  const AccordiansWidget({
    super.key,
    this.imagePath = 'assets/images/sqlImage.png',
    this.title = 'SQL',
    this.description = 'Master query logic and database \nthinking.',
    this.completedText = '1 of 13 completed',
    this.percentage = '8%',
    this.progressValue = 0.08,
    this.numberOfLessons = 4,
    this.lessonItems = const [],
  });

  @override
  State<AccordiansWidget> createState() => _AccordiansWidgetState();
}

class _AccordiansWidgetState extends State<AccordiansWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Animation for progress bar from 0 to progress value
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.progressValue).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    // Animation for accordion expansion
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    // Start progress animation when widget builds
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  void _toggleAccordion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      radius: 16,
          width: double.infinity,
      padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Main content Row
              Row(
                children: [
                  // Left column with image - 110x110
                  SizedBox(
                    width: 110.w,
                    child: Image.asset(
                      widget.imagePath,
                      width: 110.w,
                      height: 110.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Right column with content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 14.w,
                        right: 14.w,
                        top: 10.h,
                        bottom: 14.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.sp,
                                  height: 1.3,
                                  letterSpacing: 13.sp * 0.04,
                                  color: Colors.white,
                                ),
                              ),
                              // SizedBox(width: 20.w),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _toggleAccordion,
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: AnimatedRotation(
                                      duration: const Duration(milliseconds: 300),
                                      turns: _isExpanded ? 0.5 : 0,
                                      child: SvgPicture.asset(
                                        AppIcons.dropdownArrow,
                                        width: 16.w,
                                        height: 16.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Description text
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              height: 1.3,
                              color: Color(0xFF80858D), // #80858D
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Progress text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.completedText,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  height: 1.3,
                                  color: Colors.white, // #FFFFFF
                                ),
                              ),
                              Text(
                                widget.percentage,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  height: 1.3,
                                  color: Colors.white, // #FFFFFF
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          // Progress bar with animation
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
                                    // Filled portion - animated from 0% to 8%
                                    Expanded(
                                      flex:
                                          (100 *
                                                  _progressAnimation.value /
                                                  widget.progressValue)
                                              .round(),
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
                                      flex:
                                          (100 *
                                                  (1 -
                                                      _progressAnimation
                                                          .value) /
                                                  widget.progressValue)
                                              .round(),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Expandable lessons section - appears after Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: SizeTransition(
                  sizeFactor: _expandAnimation,
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      // 4 LESSONS text with gradient line
                      Row(
                        children: [
                          Text(
                            '${widget.numberOfLessons} LESSONS',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                              height: 1.3,
                              letterSpacing: 10.sp * 0.02,
                              color: AppColors.blue,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1A2E45),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      // Lesson items
                      ...widget.lessonItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final lesson = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < widget.lessonItems.length - 1 ? 6.h : 0,
                          ),
                          child: LessonItemCard(
                            title: lesson['title'] ?? '',
                            percentage: lesson['percentage'] ?? '0%',
                            hasTick: lesson['hasTick'] == 'true',
                            isLocked: lesson['isLocked'] == 'true',
                            backgroundColor: Colors.transparent,
                            showDashedLine: false,
                            route: lesson['route'],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
