import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/main_top_bar.dart';
import 'package:d99_learn_data_enginnering/src/features/home/widgets/lesson_widget.dart';
import 'package:d99_learn_data_enginnering/src/features/home/widgets/accordians_widget.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Set transparent status bar with white icons
    StatusBarService.setTransparentStatusBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.appBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
              // 20px spacing above header
              SizedBox(height: 10.h),
              
              // Main top bar
              const MainTopBar(),
              
              // 20px spacing below header
              SizedBox(height: 20.h),
              
              // Lesson widget with 18px margins
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: const LessonWidget(),
              ),

              SizedBox(height: 18.h),
              
              // Streak row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: Row(
                  children: [
                    // Emotion icon
                    SvgPicture.asset(
                      AppIcons.emotion,
                      width: 13.w,
                      height: 16.h,
                    ),
                    SizedBox(width: 4.w),
                    // 4-Day text
                    Text(
                      '4-DAY',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        height: 1.3,
                        letterSpacing: 12.sp * 0.04,
                        color: Color(0xFF68C5FF), // #68C5FF
                      ),
                    ),
                    SizedBox(width: 5.w),
                    // Streak text
                    Text(
                      'STREAK',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        height: 1.3,
                        letterSpacing: 12.sp * 0.04,
                        color: Colors.white, // #FFFFFF
                      ),
                     ),
                     // Right side content
                     Spacer(),
                     SvgPicture.asset(
                       AppIcons.days4,
                      //  width: 80.w, // Set a specific width
                       height: 14.h,
                      //  fit: BoxFit.contain, // This doesn't work with SVG, but won't error
                     ),
                   ],
                 ),
               ),

              SizedBox(height: 12.h),
              
              // SQL Accordians widget with 18px margins
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: AccordiansWidget(
                  imagePath: AppImages.sqlImage,
                  title: 'SQL',
                  description: 'Master query logic and database \nthinking.',
                  completedText: '1 of 13 completed',
                  percentage: '8%',
                  progressValue: 0.08,
                  numberOfLessons: 5,
                  lessonItems: [
                    {'title': 'Query Structure', 'percentage': '50%', 'hasTick': 'true', 'isLocked': 'false'},
                    {'title': 'Filtering', 'percentage': '0%', 'hasTick': 'true', 'isLocked': 'false'},
                    {'title': 'Sorting', 'percentage': '20%', 'hasTick': 'true', 'isLocked': 'false'},
                    {'title': 'Aggregation', 'percentage': '100%', 'hasTick': 'true', 'isLocked': 'false'},
                    {'title': 'Joins', 'percentage': '50%', 'hasTick': 'true', 'isLocked': 'false'},
                  ],
                ),
              ),

              SizedBox(height: 12.h),
              
              // Python Accordians widget with 18px margins
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: AccordiansWidget(
                  imagePath: AppImages.pythonImage,
                  title: 'PYTHON',
                  description: 'Write clean, efficient, and make \nreusable code.',
                  completedText: '2 of 4 completed',
                  percentage: '50%',
                  progressValue: 0.50,
                  numberOfLessons: 4,
                  lessonItems: [
                    {'title': 'Python Basics', 'percentage': '100%', 'hasTick': 'true', 'isLocked': 'false', 'route': '/python-builder'},
                    {'title': 'Advanced Python', 'percentage': '20%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'Python Functions', 'percentage': '0%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'Data Structures', 'percentage': '0%', 'hasTick': 'true', 'isLocked': 'true'},
                  ],
                ),
              ),

              SizedBox(height: 12.h),
              
              // BIG DATA Accordians widget with 18px margins
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: AccordiansWidget(
                  imagePath: AppImages.bigData,
                  title: 'BIG DATA',
                  description: 'Understand data at scale and real-world use cases.',
                  completedText: '3 of 5 completed',
                  percentage: '60%',
                  progressValue: 0.60,
                  numberOfLessons: 5,
                  lessonItems: [
                    {'title': 'Introduction to Big Data', 'percentage': '100%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'Distributed Systems', 'percentage': '100%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'Data Processing', 'percentage': '50%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'Data Storage', 'percentage': '0%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'Analytics & Insights', 'percentage': '0%', 'hasTick': 'true', 'isLocked': 'true'},
                  ],
                ),
              ),

              SizedBox(height: 12.h),
              
              // INTERVIEW Accordians widget with 18px margins
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                child: AccordiansWidget(
                  imagePath: AppImages.interview,
                  title: 'INTERVIEW',
                  description: 'Query and filter data with real examples',
                  completedText: '2 of 5 completed',
                  percentage: '40%',
                  progressValue: 0.40,
                  numberOfLessons: 5,
                  lessonItems: [
                    {'title': 'SQL Queries', 'percentage': '100%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'Database Design', 'percentage': '100%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'Data Modeling', 'percentage': '0%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'System Design', 'percentage': '0%', 'hasTick': 'true', 'isLocked': 'true'},
                    {'title': 'Best Practices', 'percentage': '0%', 'hasTick': 'true', 'isLocked': 'true'},
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
