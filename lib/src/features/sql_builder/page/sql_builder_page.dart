import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/fonts.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/back_top_bar.dart';
import 'package:d99_learn_data_enginnering/src/features/sql_builder/widgets/skip_challenge_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/sql_builder/widgets/sql_builder_container.dart';
import 'package:d99_learn_data_enginnering/src/features/sql_builder/widgets/sql_builder_toolbar.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';
import 'package:d99_learn_data_enginnering/src/features/home/page/home_page.dart';

class SqlBuilderPage extends StatefulWidget {
  const SqlBuilderPage({super.key});

  @override
  State<SqlBuilderPage> createState() => _SqlBuilderPageState();
}

class _SqlBuilderPageState extends State<SqlBuilderPage>
    with SingleTickerProviderStateMixin {
  bool _showPopup = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    StatusBarService.setTransparentStatusBar();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at current position
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onInfoThreeDotsTap() {
    setState(() {
      _showPopup = true;
    });
    _slideController.forward();
  }

  void _onCancel() {
    _slideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showPopup = false;
        });
      }
    });
  }

  void _onSkipAway() {
    _slideController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    });
  }

  Widget _buildFieldBox(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 2.h, 8.w, 2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: const Color(0x997A5299), // #7A529999
            border: Border.all(
              color: const Color(0xFFE5E6EB).withOpacity(0.075),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontFamily: AppFonts.geistMono,
                  fontWeight: AppFonts.regular,
                  fontSize: 13.sp,
                  color: const Color(0xFFEA74FF), // #EA74FF
                ),
              ),
              // Gradient border overlay
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   right: 0,
              //   height: 1,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //         colors: [
              //           const Color(0xFFE5E6EB).withOpacity(0.075),
              //           const Color(0xFFE5E6EB).withOpacity(0),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedBox(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          padding: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: const Color(0xFF0B2742), // #0B2742
            border: Border.all(
              color: const Color(0xFFE5E6EB).withOpacity(0.075),
              width: 1,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.geistMono,
              fontWeight: AppFonts.regular,
              fontSize: 13.sp,
              height: 1.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
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
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 390.h), // Space for toolbar with tabs
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: BackTopBar(
                        title: 'SQL BUILDER',
                        showSettingsIcon: false,
                        customRightIcon: SvgPicture.asset(
                          AppIcons.infoThreeDots,
                          width: 24.w,
                          height: 24.h,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        onCustomIconTap: _onInfoThreeDotsTap,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    // Content box with question
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: GlassBox(
                        radius: 16,
                            width: double.infinity,
                                  padding: EdgeInsets.all(12.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Q:',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Text(
                                              'Retrieve the order_id, status, and region for orders that have been completed in the US.',
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
                                    ],
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    // Gradient border line (full width)
                    Stack(
                      children: [
                        // Background color
                        Container(
                          height: 2.h,
                          color: const Color(0x08B9CEF1), // #B9CEF108
                        ),
                        // Gradient border overlay
                        Container(
                          height: 2.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFFE5E6EB).withOpacity(0.075), // rgba(229, 230, 235, 0.075)
                                const Color(0xFFE5E6EB).withOpacity(0), // rgba(229, 230, 235, 0)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // Container box
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SqlBuilderContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // SELECT keyword
                            Text(
                              'SELECT',
                              style: TextStyle(
                                fontFamily: AppFonts.geistMono,
                                fontWeight: AppFonts.bold,
                                fontSize: 13.sp,
                                height: 1.4,
                                color: const Color(0xFF68C5FF), // #68C5FF
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // Field boxes row
                            Padding(
                              padding: EdgeInsets.only(left: 24.w),
                              child: Row(
                                children: [
                                  _buildFieldBox('order_id'),
                                  SizedBox(width: 6.w),
                                  _buildFieldBox('status'),
                                  SizedBox(width: 6.w),
                                  _buildFieldBox('region'),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // FROM box
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 5.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: const Color(0x1A009CFF), // #009CFF1A
                                    border: Border.all(
                                      color: const Color(0xFFE5E6EB).withOpacity(0.075),
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'FROM',
                                            style: TextStyle(
                                              fontFamily: AppFonts.geistMono,
                                              fontWeight: AppFonts.bold,
                                              fontSize: 13.sp,
                                              height: 1.4,
                                              color: const Color(0xFF68C5FF), // #68C5FF
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          _buildFieldBox('orders'),
                                        ],
                                      ),
                                      // Top gradient border
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // WHERE container (full width)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: const Color(0x1A009CFF), // #009CFF1A
                                    border: Border.all(
                                      color: const Color(0xFFE5E6EB).withOpacity(0.075),
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Content box with padding
                                      Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // WHERE text in separate row
                                            Text(
                                              'WHERE',
                                              style: TextStyle(
                                                fontFamily: AppFonts.geistMono,
                                                fontWeight: AppFonts.bold,
                                                fontSize: 13.sp,
                                                height: 1.4,
                                                color: const Color(0xFF68C5FF), // #68C5FF
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            // Status, =, and completed row wrapped in box
                                            Container(
                                              padding: EdgeInsets.all(2.w),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF17517D), // #17517D
                                                borderRadius: BorderRadius.circular(6.r),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  _buildFieldBox('status'),
                                                  SizedBox(width: 8.w),
                                                  Text(
                                                    '=',
                                                    style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 13.sp,
                                                      height: 1.4,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  _buildCompletedBox('\'completed\''),
                                                ],
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
                                      // Bottom gradient border
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
                                                const Color(0xFFE5E6EB).withOpacity(0),
                                                const Color(0xFFE5E6EB).withOpacity(0.075),
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // UNION box (outside container)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: const Color(0x1A009CFF), // #009CFF1A
                              border: Border.all(
                                color: const Color(0xFFE5E6EB).withOpacity(0.075),
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Content box with padding
                                // width double.infinity
                                Container(
                                  width: 54.w,
                                  padding: EdgeInsets.all(8.w),
                                  child: Text('UNION', style: TextStyle(
                                    fontFamily: AppFonts.geistMono,
                                    fontWeight: AppFonts.bold,
                                    fontSize: 13.sp,
                                    color: const Color(0xFF68C5FF), // #68C5FF
                                  ),
                                )),
                                
                                // Bottom gradient border
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
                                          const Color(0xFFE5E6EB).withOpacity(0),
                                          const Color(0xFFE5E6EB).withOpacity(0.075),
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
                    SizedBox(height: 8.h),
                    // Duplicate SELECT container
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SqlBuilderContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // SELECT keyword
                            Text(
                              'SELECT',
                              style: TextStyle(
                                fontFamily: AppFonts.geistMono,
                                fontWeight: AppFonts.bold,
                                fontSize: 13.sp,
                                height: 1.4,
                                color: const Color(0xFF68C5FF), // #68C5FF
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // Field boxes row
                            Padding(
                              padding: EdgeInsets.only(left: 24.w),
                              child: Row(
                                children: [
                                  _buildFieldBox('order_id'),
                                  SizedBox(width: 6.w),
                                  _buildFieldBox('status'),
                                  SizedBox(width: 6.w),
                                  _buildFieldBox('region'),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // FROM box
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 5.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: const Color(0x1A009CFF), // #009CFF1A
                                    border: Border.all(
                                      color: const Color(0xFFE5E6EB).withOpacity(0.075),
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'FROM',
                                            style: TextStyle(
                                              fontFamily: AppFonts.geistMono,
                                              fontWeight: AppFonts.bold,
                                              fontSize: 13.sp,
                                              height: 1.4,
                                              color: const Color(0xFF68C5FF), // #68C5FF
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          _buildFieldBox('orders'),
                                        ],
                                      ),
                                      // Top gradient border
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            // WHERE container (full width)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    color: const Color(0x1A009CFF), // #009CFF1A
                                    border: Border.all(
                                      color: const Color(0xFFE5E6EB).withOpacity(0.075),
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Content box with padding
                                      Padding(
                                        padding: EdgeInsets.all(8.w),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // WHERE text in separate row
                                            Text(
                                              'WHERE',
                                              style: TextStyle(
                                                fontFamily: AppFonts.geistMono,
                                                fontWeight: AppFonts.bold,
                                                fontSize: 13.sp,
                                                height: 1.4,
                                                color: const Color(0xFF68C5FF), // #68C5FF
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            // Status, =, and completed row wrapped in box
                                            Container(
                                              padding: EdgeInsets.all(2.w),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF17517D), // #17517D
                                                borderRadius: BorderRadius.circular(6.r),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  _buildFieldBox('status'),
                                                  SizedBox(width: 8.w),
                                                  Text(
                                                    '=',
                                                    style: TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 13.sp,
                                                      height: 1.4,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  _buildCompletedBox('\'completed\''),
                                                ],
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
                                      // Bottom gradient border
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
                                                const Color(0xFFE5E6EB).withOpacity(0),
                                                const Color(0xFFE5E6EB).withOpacity(0.075),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SQL Builder Toolbar - fixed at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SqlBuilderToolbar(
                  onUndo: () {
                    // Handle undo action
                  },
                  onRedo: () {
                    // Handle redo action
                  },
                  onTableIcon: () {
                    // Handle table icon action
                  },
                  onRun: () {
                    // Handle run action
                  },
                ),
              ),
              // Popup overlay
              if (_showPopup)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SkipChallengePopup(
                      onCancel: _onCancel,
                      onSkipAway: _onSkipAway,
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