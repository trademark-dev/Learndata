import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/back_top_bar.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/section_header_with_lines.dart';
import 'package:d99_learn_data_enginnering/src/features/select_skill/widgets/learn_item_card.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/branded_button.dart';
import 'package:d99_learn_data_enginnering/src/features/lesson_visual/page/lesson_visual_page.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class SelectSkill extends StatefulWidget {
  const SelectSkill({super.key});

  @override
  State<SelectSkill> createState() => _SelectSkillState();
}

class _SelectSkillState extends State<SelectSkill> {
  @override
  void initState() {
    super.initState();
    // Transparent status bar with white icons
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
            image: AssetImage(AppImages.otherPageBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const BackTopBar(),
              ),
              SizedBox(height: 22.h),

              // Heading section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 19.w),
                child: Center(
                  child: Text(
                    'Where do you want to start?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                      height: 1.3,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),

              // Subtext / description section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 19.w),
                child: Center(
                  child: Text(
                    'To start in the most helpful point for you, how much you do know about Query Structure?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      height: 1.4,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 22.h),

              // 3 level cards row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Beginner card (left)
                    Expanded(
                      child: GlassBox(
                        radius: 16,
                            padding: EdgeInsets.only(
                              top: 16.h,
                              bottom: 16.h,
                              left: 4.w,
                              right: 4.w,
                            ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.skillCardBgLightBlue,
                              borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icon
                                  Container(
                                    width: 44.w,
                                    height: 44.h,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x40000000), // #00000040
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      AppIcons.bignnerSvg,
                                    ),
                                  ),
                                  SizedBox(height: 13.h),
                                  // Title
                                  Text(
                                    'BEGINNER',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      height: 1.3,
                                      letterSpacing: 12.sp * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  // Subtitle
                                  Text(
                                    'Start your SQL\njourney',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.sp,
                                      height: 1.3,
                                      color: Color(0xFFB5BBC2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                                  ],
                                ),
                      ),
                    ),
                    SizedBox(width: 6.w),

                    // Intermediate card (center) - layered gradients
                    Expanded(
                      child: GlassBox(
                        radius: 16,
                        padding: EdgeInsets.zero,
                      child: Stack(
                        children: [
                            // Full background - full to corners
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Stack(
                                children: [
                                  // Full-bleed background image
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            AppImages.skilIntermediatBg,
                                          ),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Base light blue wash
                                  Positioned.fill(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0x05009CFF),
                                            Color(0x05009CFF),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Top transparent to blue shade at bottom
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: const [
                                            Color(0x000E425A),
                                            Color(0x00000000),
                                          ],
                                          stops: const [0.0, 0.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0x00000000),
                                            AppColors.skillCardBlueShade,
                                          ],
                                          stops: const [0.6, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                            // Foreground content with padding
                            Padding(
                            padding: EdgeInsets.only(
                              top: 16.h,
                              bottom: 6.h,
                              left: 4.w,
                              right: 4.w,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icon
                                  Container(
                                    width: 44.w,
                                    height: 44.h,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x40000000),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      AppIcons.intermediatSvg,
                                    ),
                                  ),
                                  SizedBox(height: 13.h),
                                  Text(
                                    'INTERMEDIATE',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      height: 1.3,
                                      letterSpacing: 12.sp * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Go deeper into\nSQL concepts',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.sp,
                                      height: 1.3,
                                      color: Color(0xFFB5BBC2),
                                    ),
                                  ),
                                  SizedBox(height: 14.h),
                                  SvgPicture.asset(
                                    AppIcons.downIconSvg,
                                    width: 10.018.w,
                                    height: 5.768.h,
                                    colorFilter: ColorFilter.mode(
                                      Color(0xFFB5BBC2),
                                      BlendMode.srcIn,
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
                    SizedBox(width: 6.w),

                    // Advance card (right)
                    Expanded(
                      child: GlassBox(
                        radius: 16,
                            padding: EdgeInsets.only(
                              top: 16.h,
                              bottom: 16.h,
                              left: 4.w,
                              right: 4.w,
                            ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.skillCardBgLightBlue,
                              borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 44.w,
                                    height: 44.h,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x40000000), // #00000040
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      AppIcons.advanceSvg,
                                    ),
                                  ),
                                  SizedBox(height: 13.h),
                                  Text(
                                    'ADVANCED',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      height: 1.3,
                                      letterSpacing: 12.sp * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    'Master advanced\nquery techniques',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.sp,
                                      height: 1.3,
                                      color: Color(0xFFB5BBC2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                                  ],
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),
              // Next section header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: const SectionHeaderWithLines(title: "What you'll learn"),
              ),
              // Expanded widget with margin - only this scrolls
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  child: const LearnItemCard(),
                ),
              ),
                ],
              ),
              // Floating branded button at bottom
              Positioned(
                bottom: 27.h,
                left: 0,
                right: 0,
                child: Center(
                  child: BrandedButton(
                    text: 'GET STARTED',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LessonVisualPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
