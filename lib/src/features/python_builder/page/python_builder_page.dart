import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/fonts.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/back_top_bar.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/python_builder_toolbar.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/python_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/hint_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/run_result_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/compiled_failed_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/information_popup.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class PythonBuilderPage extends StatefulWidget {
  const PythonBuilderPage({super.key});

  @override
  State<PythonBuilderPage> createState() => _PythonBuilderPageState();
}

class _PythonBuilderPageState extends State<PythonBuilderPage>
    with TickerProviderStateMixin {
  bool _showPopup = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  bool _showHintPopup = false;
  late AnimationController _hintSlideController;
  late Animation<Offset> _hintSlideAnimation;

  bool _showRunResultPopup = false;
  late AnimationController _runResultSlideController;
  late Animation<Offset> _runResultSlideAnimation;

  bool _showCompiledFailedPopup = false;
  late AnimationController _compiledFailedSlideController;
  late Animation<Offset> _compiledFailedSlideAnimation;

  bool _showInformationPopup = false;
  late AnimationController _informationSlideController;
  late Animation<Offset> _informationSlideAnimation;

  @override
  void initState() {
    super.initState();
    StatusBarService.setTransparentStatusBar();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _hintSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _hintSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at current position
    ).animate(CurvedAnimation(
      parent: _hintSlideController,
      curve: Curves.easeOut,
    ));

    _runResultSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _runResultSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at current position
    ).animate(CurvedAnimation(
      parent: _runResultSlideController,
      curve: Curves.easeOut,
    ));

    _compiledFailedSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _compiledFailedSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at current position
    ).animate(CurvedAnimation(
      parent: _compiledFailedSlideController,
      curve: Curves.easeOut,
    ));

    _informationSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _informationSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from bottom
      end: Offset.zero, // End at current position
    ).animate(CurvedAnimation(
      parent: _informationSlideController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _hintSlideController.dispose();
    _runResultSlideController.dispose();
    _compiledFailedSlideController.dispose();
    _informationSlideController.dispose();
    super.dispose();
  }

  void _onInfoThreeDotsTap() {
    setState(() {
      _showPopup = true;
    });
    _fadeController.forward();
  }

  void _onSkip() {
    _fadeController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showPopup = false;
        });
      }
    });
  }

  void _onReset() {
    _fadeController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showPopup = false;
        });
      }
    });
  }

  void _onHints() {
    _fadeController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showPopup = false;
          _showHintPopup = true;
        });
        _hintSlideController.forward();
      }
    });
  }

  void _onCloseHint() {
    _hintSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showHintPopup = false;
        });
      }
    });
  }

  void _onNextHint() {
    _hintSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showHintPopup = false;
        });
      }
      // TODO: Show next hint
    });
  }

  void _onRun() {
    setState(() {
      _showRunResultPopup = true;
    });
    _runResultSlideController.forward();
  }

  void _onCloseRunResult() {
    _runResultSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showRunResultPopup = false;
        });
      }
    });
  }

  void _onShowCompiledFailed() {
    // Close the run result popup first
    _runResultSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showRunResultPopup = false;
          _showCompiledFailedPopup = true;
        });
        _compiledFailedSlideController.forward();
      }
    });
  }

  void _onCloseCompiledFailed() {
    _compiledFailedSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showCompiledFailedPopup = false;
        });
      }
    });
  }

  void _onShowInformation() {
    // Close the compiled failed popup first
    _compiledFailedSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showCompiledFailedPopup = false;
          _showInformationPopup = true;
        });
        _informationSlideController.forward();
      }
    });
  }

  void _onCloseInformation() {
    _informationSlideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showInformationPopup = false;
        });
      }
    });
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
          child: GestureDetector(
            onTap: () {
              if (_showPopup) {
                _fadeController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showPopup = false;
                    });
                  }
                });
              } else if (_showHintPopup) {
                _hintSlideController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showHintPopup = false;
                    });
                  }
                });
              } else if (_showRunResultPopup) {
                _runResultSlideController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showRunResultPopup = false;
                    });
                  }
                });
              } else if (_showCompiledFailedPopup) {
                _compiledFailedSlideController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showCompiledFailedPopup = false;
                    });
                  }
                });
              } else if (_showInformationPopup) {
                _informationSlideController.reverse().then((_) {
                  if (mounted) {
                    setState(() {
                      _showInformationPopup = false;
                    });
                  }
                });
              }
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 390.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: BackTopBar(
                        title: 'PYTHON BUILDER',
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
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                              'Write a loop to add an array of numbers',
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
                    // Variable boxes
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          // Var A box
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.r),
                                  color: const Color(0x99242D40), // #242D4099
                                ),
                                child: Stack(
                                  children: [
                                    // Content
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        6.w,
                                        5.h,
                                        6.w,
                                        5.h,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'var A:',
                                            style: TextStyle(
                                              fontFamily: AppFonts.geistMono,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              height: 1.0,
                                              color: const Color(
                                                0xFF74FFA3,
                                              ), // #74FFA3
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            '3',
                                            style: TextStyle(
                                              fontFamily: AppFonts.geistMono,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              height: 1.0,
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
                          SizedBox(width: 4.w),
                          // Var B box
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.r),
                                  color: const Color(0x99242D40), // #242D4099
                                ),
                                child: Stack(
                                  children: [
                                    // Content
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        6.w,
                                        5.h,
                                        6.w,
                                        5.h,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'var B:',
                                            style: TextStyle(
                                              fontFamily: AppFonts.geistMono,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              height: 1.0,
                                              color: const Color(
                                                0xFF74FFA3,
                                              ), // #74FFA3
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            '<var>',
                                            style: TextStyle(
                                              fontFamily: AppFonts.geistMono,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              height: 1.0,
                                              color: const Color(
                                                0xFF4C7F9E,
                                              ), // #4C7F9E
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
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
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
                                const Color(0xFFE5E6EB).withOpacity(
                                  0.075,
                                ), // rgba(229, 230, 235, 0.075)
                                const Color(
                                  0xFFE5E6EB,
                                ).withOpacity(0), // rgba(229, 230, 235, 0)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // Container with FOR/IN section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              color: const Color(0x99232834), // #23283499
                              border: Border.all(
                                color: const Color(
                                  0xFFE5E6EB,
                                ).withOpacity(0.101), // #E5E6EB1A
                                width: 0.5,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Content
                                Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'FOR',
                                            style: TextStyle(
                                              fontFamily: AppFonts.geistMono,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13.sp,
                                              height: 1.4,
                                              color: const Color(
                                                0xFFB9B9B9,
                                              ), // #B9B9B9
                                            ),
                                          ),
                                          SizedBox(width: 3.w),
                                          // Order button
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              50.r,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 32,
                                                sigmaY: 32,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(8.w),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0x999A4B4B,
                                                  ), // #9A4B4B99
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFE5E6EB,
                                                    ).withOpacity(0.075),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        50.r,
                                                      ),
                                                ),
                                                child: Text(
                                                  'order',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.geistMono,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13.sp,
                                                    height: 1.0,
                                                    color: const Color(
                                                      0xFFF75F5F,
                                                    ), // #F75F5F
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            'IN',
                                            style: TextStyle(
                                              fontFamily: AppFonts.geistMono,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13.sp,
                                              height: 1.4,
                                              color: const Color(
                                                0xFFB9B9B9,
                                              ), // #B9B9B9
                                            ),
                                          ),
                                          SizedBox(width: 3.w),
                                          // Orders box
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              50.r,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 32,
                                                sigmaY: 32,
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(8.w),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF0A1520,
                                                  ), // #0A1520
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFE5E6EB,
                                                    ).withOpacity(0.075),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        50.r,
                                                      ),
                                                ),
                                                child: Text(
                                                  'orders',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.geistMono,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13.sp,
                                                    height: 1.0,
                                                    color: const Color(
                                                      0xFF74FFA3,
                                                    ), // #74FFA3
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      // inser here all IF and ELSE content
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 24.w,
                                          right: 14.w,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                              sigmaX: 32,
                                              sigmaY: 32,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                                color: const Color(
                                                  0x66444C5E,
                                                ), // #444C5E66
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFE5E6EB,
                                                  ).withOpacity(
                                                    0.101,
                                                  ), // #E5E6EB1A
                                                  width: 0.5,
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  // Content
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                      8.w,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'IF',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppFonts
                                                                        .geistMono,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 13.sp,
                                                                height: 15 / 13,
                                                                color:
                                                                    const Color(
                                                                      0xFFB9B9B9,
                                                                    ), // #B9B9B9
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 7.w,
                                                            ),
                                                            // Inner container with order % 2 == 0 :
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    50.r,
                                                                  ),
                                                              child: BackdropFilter(
                                                                filter:
                                                                    ImageFilter.blur(
                                                                      sigmaX:
                                                                          32,
                                                                      sigmaY:
                                                                          32,
                                                                    ),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          50.r,
                                                                        ),
                                                                    color: const Color(
                                                                      0x99444C5E,
                                                                    ), // #444C5E99
                                                                    border: Border.all(
                                                                      color: const Color(
                                                                        0xFFE5E6EB,
                                                                      ).withOpacity(
                                                                        0.101,
                                                                      ), // #E5E6EB1A
                                                                      width:
                                                                          0.5,
                                                                    ),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      // Content
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              4.w,
                                                                          vertical:
                                                                              2.h,
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            // Wrapper box for order % 2
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(
                                                                                50.r,
                                                                              ),
                                                                              child: BackdropFilter(
                                                                                filter: ImageFilter.blur(
                                                                                  sigmaX:
                                                                                      32,
                                                                                  sigmaY:
                                                                                      32,
                                                                                ),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(
                                                                                    2.w,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color(
                                                                                      0xFF586072,
                                                                                    ), // #586072
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      50.r,
                                                                                    ),
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisSize:
                                                                                        MainAxisSize.min,
                                                                                    children: [
                                                                                      // Order box (smaller, 50 radius)
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(
                                                                                          50.r,
                                                                                        ),
                                                                                        child: BackdropFilter(
                                                                                          filter: ImageFilter.blur(
                                                                                            sigmaX:
                                                                                                32,
                                                                                            sigmaY:
                                                                                                32,
                                                                                          ),
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.all(
                                                                                              8.w,
                                                                                            ),
                                                                                            decoration: BoxDecoration(
                                                                                              color: const Color(
                                                                                                0x999A4B4B,
                                                                                              ), // #9A4B4B99
                                                                                              border: Border.all(
                                                                                                color: const Color(
                                                                                                  0xFFE5E6EB,
                                                                                                ).withOpacity(
                                                                                                  0.075,
                                                                                                ),
                                                                                                width:
                                                                                                    1,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(
                                                                                                50.r,
                                                                                              ),
                                                                                            ),
                                                                                            child: Text(
                                                                                              'order',
                                                                                              style: TextStyle(
                                                                                                fontFamily:
                                                                                                    AppFonts.geistMono,
                                                                                                fontWeight:
                                                                                                    FontWeight.w400,
                                                                                                fontSize:
                                                                                                    13.sp,
                                                                                                height:
                                                                                                    1.0,
                                                                                                color: const Color(
                                                                                                  0xFFF75F5F,
                                                                                                ), // #F75F5F
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width:
                                                                                            8.w,
                                                                                      ),
                                                                                      Text(
                                                                                        '%',
                                                                                        style: TextStyle(
                                                                                          fontFamily:
                                                                                              AppFonts.geistMono,
                                                                                          fontWeight:
                                                                                              FontWeight.w700,
                                                                                          fontSize:
                                                                                              13.sp,
                                                                                          color:
                                                                                              Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width:
                                                                                            8.w,
                                                                                      ),
                                                                                      // Number 2 box (circular)
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(
                                                                                          50.r,
                                                                                        ),
                                                                                        child: BackdropFilter(
                                                                                          filter: ImageFilter.blur(
                                                                                            sigmaX:
                                                                                                32,
                                                                                            sigmaY:
                                                                                                32,
                                                                                          ),
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.all(
                                                                                              8.w,
                                                                                            ),
                                                                                            decoration: BoxDecoration(
                                                                                              color: const Color(
                                                                                                0xFF0A1520,
                                                                                              ), // #0A1520
                                                                                              border: Border.all(
                                                                                                color: const Color(
                                                                                                  0xFFE5E6EB,
                                                                                                ).withOpacity(
                                                                                                  0.075,
                                                                                                ),
                                                                                                width:
                                                                                                    1,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(
                                                                                                50.r,
                                                                                              ),
                                                                                            ),
                                                                                            child: Text(
                                                                                              '2',
                                                                                              style: TextStyle(
                                                                                                fontFamily:
                                                                                                    AppFonts.geistMono,
                                                                                                fontWeight:
                                                                                                    FontWeight.w400,
                                                                                                fontSize:
                                                                                                    13.sp,
                                                                                                height:
                                                                                                    1.0,
                                                                                                color:
                                                                                                    Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width:
                                                                                  3.w,
                                                                            ),
                                                                            Text(
                                                                              '==',
                                                                              style: TextStyle(
                                                                                fontFamily:
                                                                                    AppFonts.geistMono,
                                                                                fontWeight:
                                                                                    FontWeight.w700,
                                                                                fontSize:
                                                                                    13.sp,
                                                                                color:
                                                                                    Colors.white,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width:
                                                                                  3.w,
                                                                            ),
                                                                            // Number 0 box (circular)
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(
                                                                                50.r,
                                                                              ),
                                                                              child: BackdropFilter(
                                                                                filter: ImageFilter.blur(
                                                                                  sigmaX:
                                                                                      32,
                                                                                  sigmaY:
                                                                                      32,
                                                                                ),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(
                                                                                    8.w,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color(
                                                                                      0xFF0A1520,
                                                                                    ), // #0A1520
                                                                                    border: Border.all(
                                                                                      color: const Color(
                                                                                        0xFFE5E6EB,
                                                                                      ).withOpacity(
                                                                                        0.075,
                                                                                      ),
                                                                                      width:
                                                                                          1,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      50.r,
                                                                                    ),
                                                                                  ),
                                                                                  child: Text(
                                                                                    '0',
                                                                                    style: TextStyle(
                                                                                      fontFamily:
                                                                                          AppFonts.geistMono,
                                                                                      fontWeight:
                                                                                          FontWeight.w400,
                                                                                      fontSize:
                                                                                          13.sp,
                                                                                      height:
                                                                                          1.0,
                                                                                      color:
                                                                                          Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              ':',
                                                                              style: TextStyle(
                                                                                fontFamily:
                                                                                    AppFonts.geistMono,
                                                                                fontWeight:
                                                                                    FontWeight.w700,
                                                                                fontSize:
                                                                                    13.sp,
                                                                                color:
                                                                                    Colors.white,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      // Top gradient border
                                                                      Positioned(
                                                                        top: 0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        height:
                                                                            1,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              begin:
                                                                                  Alignment.centerLeft,
                                                                              end:
                                                                                  Alignment.centerRight,
                                                                              colors: [
                                                                                Colors.transparent,
                                                                                Colors.white.withOpacity(
                                                                                  0.5,
                                                                                ),
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
                                                                        bottom:
                                                                            0,
                                                                        width:
                                                                            1,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              begin:
                                                                                  Alignment.topCenter,
                                                                              end:
                                                                                  Alignment.bottomCenter,
                                                                              colors: [
                                                                                Colors.transparent,
                                                                                Colors.white.withOpacity(
                                                                                  0.5,
                                                                                ),
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
                                                          ],
                                                        ),
                                                        SizedBox(height: 4.h),
                                                        // Indented row for total += order * 2
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 24.w,
                                                              ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  50.r,
                                                                ),
                                                            child: BackdropFilter(
                                                              filter:
                                                                  ImageFilter.blur(
                                                                    sigmaX: 32,
                                                                    sigmaY: 32,
                                                                  ),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        50.r,
                                                                      ),
                                                                  color: const Color(
                                                                    0x80444C5E,
                                                                  ), // #444C5E80
                                                                  border: Border.all(
                                                                    color: const Color(
                                                                      0xFFE5E6EB,
                                                                    ).withOpacity(
                                                                      0.101,
                                                                    ), // #E5E6EB1A
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                child: Stack(
                                                                  children: [
                                                                    // Content
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            4.w,
                                                                        vertical:
                                                                            2.h,
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          // total box
                                                                          ClipRRect(
                                                                            borderRadius: BorderRadius.circular(
                                                                              50.r,
                                                                            ),
                                                                            child: BackdropFilter(
                                                                              filter: ImageFilter.blur(
                                                                                sigmaX:
                                                                                    32,
                                                                                sigmaY:
                                                                                    32,
                                                                              ),
                                                                              child: Container(
                                                                                padding: EdgeInsets.all(
                                                                                  8.w,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(
                                                                                    0xFF0A1520,
                                                                                  ), // #0A1520
                                                                                  border: Border.all(
                                                                                    color: const Color(
                                                                                      0xFFE5E6EB,
                                                                                    ).withOpacity(
                                                                                      0.075,
                                                                                    ),
                                                                                    width:
                                                                                        1,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    50.r,
                                                                                  ),
                                                                                ),
                                                                                child: Text(
                                                                                  'total',
                                                                                  style: TextStyle(
                                                                                    fontFamily:
                                                                                        AppFonts.geistMono,
                                                                                    fontWeight:
                                                                                        FontWeight.w400,
                                                                                    fontSize:
                                                                                        13.sp,
                                                                                    height:
                                                                                        1.0,
                                                                                    color: const Color(
                                                                                      0xFF74FFA3,
                                                                                    ), // #74FFA3
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8.w,
                                                                          ),
                                                                          Text(
                                                                            '+=',
                                                                            style: TextStyle(
                                                                              fontFamily:
                                                                                  AppFonts.geistMono,
                                                                              fontWeight:
                                                                                  FontWeight.w700,
                                                                              fontSize:
                                                                                  13.sp,
                                                                              color:
                                                                                  Colors.white,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                3.w,
                                                                          ),
                                                                          // Wrapper for order * 2
                                                                          ClipRRect(
                                                                            borderRadius: BorderRadius.circular(
                                                                              50.r,
                                                                            ),
                                                                            child: BackdropFilter(
                                                                              filter: ImageFilter.blur(
                                                                                sigmaX:
                                                                                    32,
                                                                                sigmaY:
                                                                                    32,
                                                                              ),
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(
                                                                                  horizontal:
                                                                                      4.w,
                                                                                  vertical:
                                                                                      2.h,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    50.r,
                                                                                  ),
                                                                                  color: const Color(
                                                                                    0xFF4E5668,
                                                                                  ), // #4E5668
                                                                                  border: Border.all(
                                                                                    color: const Color(
                                                                                      0xFFE5E6EB,
                                                                                    ).withOpacity(
                                                                                      0.075,
                                                                                    ),
                                                                                    width:
                                                                                        1,
                                                                                  ),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisSize:
                                                                                      MainAxisSize.min,
                                                                                  children: [
                                                                                    // order box
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        50.r,
                                                                                      ),
                                                                                      child: BackdropFilter(
                                                                                        filter: ImageFilter.blur(
                                                                                          sigmaX:
                                                                                              32,
                                                                                          sigmaY:
                                                                                              32,
                                                                                        ),
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.all(
                                                                                            8.w,
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            color: const Color(
                                                                                              0x999A4B4B,
                                                                                            ), // #9A4B4B99
                                                                                            border: Border.all(
                                                                                              color: const Color(
                                                                                                0xFFE5E6EB,
                                                                                              ).withOpacity(
                                                                                                0.075,
                                                                                              ),
                                                                                              width:
                                                                                                  1,
                                                                                            ),
                                                                                            borderRadius: BorderRadius.circular(
                                                                                              50.r,
                                                                                            ),
                                                                                          ),
                                                                                          child: Text(
                                                                                            'order',
                                                                                            style: TextStyle(
                                                                                              fontFamily:
                                                                                                  AppFonts.geistMono,
                                                                                              fontWeight:
                                                                                                  FontWeight.w400,
                                                                                              fontSize:
                                                                                                  13.sp,
                                                                                              height:
                                                                                                  1.0,
                                                                                              color: const Color(
                                                                                                0xFFF75F5F,
                                                                                              ), // #F75F5F
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width:
                                                                                          8.w,
                                                                                    ),
                                                                                    Text(
                                                                                      '*',
                                                                                      style: TextStyle(
                                                                                        fontFamily:
                                                                                            AppFonts.geistMono,
                                                                                        fontWeight:
                                                                                            FontWeight.w700,
                                                                                        fontSize:
                                                                                            13.sp,
                                                                                        color:
                                                                                            Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width:
                                                                                          8.w,
                                                                                    ),
                                                                                    // Number 2 box
                                                                                    ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        50.r,
                                                                                      ),
                                                                                      child: BackdropFilter(
                                                                                        filter: ImageFilter.blur(
                                                                                          sigmaX:
                                                                                              32,
                                                                                          sigmaY:
                                                                                              32,
                                                                                        ),
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.all(
                                                                                            8.w,
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            color: const Color(
                                                                                              0xFF0A1520,
                                                                                            ), // #0A1520
                                                                                            border: Border.all(
                                                                                              color: const Color(
                                                                                                0xFFE5E6EB,
                                                                                              ).withOpacity(
                                                                                                0.075,
                                                                                              ),
                                                                                              width:
                                                                                                  1,
                                                                                            ),
                                                                                            borderRadius: BorderRadius.circular(
                                                                                              50.r,
                                                                                            ),
                                                                                          ),
                                                                                          child: Text(
                                                                                            '2',
                                                                                            style: TextStyle(
                                                                                              fontFamily:
                                                                                                  AppFonts.geistMono,
                                                                                              fontWeight:
                                                                                                  FontWeight.w400,
                                                                                              fontSize:
                                                                                                  13.sp,
                                                                                              height:
                                                                                                  1.0,
                                                                                              color:
                                                                                                  Colors.white,
                                                                                            ),
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
                                                                    // Top gradient border
                                                                    Positioned(
                                                                      top: 0,
                                                                      left: 0,
                                                                      right: 0,
                                                                      height: 1,
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                            begin:
                                                                                Alignment.centerLeft,
                                                                            end:
                                                                                Alignment.centerRight,
                                                                            colors: [
                                                                              Colors.transparent,
                                                                              Colors.white.withOpacity(
                                                                                0.5,
                                                                              ),
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
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                            colors: [
                                                                              Colors.transparent,
                                                                              Colors.white.withOpacity(
                                                                                0.5,
                                                                              ),
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

                                                        SizedBox(height: 4.h),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'ELSE',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppFonts
                                                                        .geistMono,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 13.sp,
                                                                height: 15 / 13,
                                                                color:
                                                                    const Color(
                                                                      0xFFB9B9B9,
                                                                    ), // #B9B9B9
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 7.w,
                                                            ),
                                                            // Inner container with order % 2 == 0 :
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    50.r,
                                                                  ),
                                                              child: BackdropFilter(
                                                                filter:
                                                                    ImageFilter.blur(
                                                                      sigmaX:
                                                                          32,
                                                                      sigmaY:
                                                                          32,
                                                                    ),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          50.r,
                                                                        ),
                                                                    color: const Color(
                                                                      0x99444C5E,
                                                                    ), // #444C5E99
                                                                    border: Border.all(
                                                                      color: const Color(
                                                                        0xFFE5E6EB,
                                                                      ).withOpacity(
                                                                        0.101,
                                                                      ), // #E5E6EB1A
                                                                      width:
                                                                          0.5,
                                                                    ),
                                                                  ),
                                                                  child: Stack(
                                                                    children: [
                                                                      // Content
                                                                      Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              4.w,
                                                                          vertical:
                                                                              2.h,
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            // Wrapper box for order % 2
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(
                                                                                50.r,
                                                                              ),
                                                                              child: BackdropFilter(
                                                                                filter: ImageFilter.blur(
                                                                                  sigmaX:
                                                                                      32,
                                                                                  sigmaY:
                                                                                      32,
                                                                                ),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(
                                                                                    2.w,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color(
                                                                                      0xFF586072,
                                                                                    ), // #586072
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      50.r,
                                                                                    ),
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisSize:
                                                                                        MainAxisSize.min,
                                                                                    children: [
                                                                                      // Order box (smaller, 50 radius)
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(
                                                                                          50.r,
                                                                                        ),
                                                                                        child: BackdropFilter(
                                                                                          filter: ImageFilter.blur(
                                                                                            sigmaX:
                                                                                                32,
                                                                                            sigmaY:
                                                                                                32,
                                                                                          ),
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.all(
                                                                                              8.w,
                                                                                            ),
                                                                                            decoration: BoxDecoration(
                                                                                              color: const Color(
                                                                                                0x999A4B4B,
                                                                                              ), // #9A4B4B99
                                                                                              border: Border.all(
                                                                                                color: const Color(
                                                                                                  0xFFE5E6EB,
                                                                                                ).withOpacity(
                                                                                                  0.075,
                                                                                                ),
                                                                                                width:
                                                                                                    1,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(
                                                                                                50.r,
                                                                                              ),
                                                                                            ),
                                                                                            child: Text(
                                                                                              'order',
                                                                                              style: TextStyle(
                                                                                                fontFamily:
                                                                                                    AppFonts.geistMono,
                                                                                                fontWeight:
                                                                                                    FontWeight.w400,
                                                                                                fontSize:
                                                                                                    13.sp,
                                                                                                height:
                                                                                                    1.0,
                                                                                                color: const Color(
                                                                                                  0xFFF75F5F,
                                                                                                ), // #F75F5F
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width:
                                                                                            8.w,
                                                                                      ),
                                                                                      Text(
                                                                                        '%',
                                                                                        style: TextStyle(
                                                                                          fontFamily:
                                                                                              AppFonts.geistMono,
                                                                                          fontWeight:
                                                                                              FontWeight.w700,
                                                                                          fontSize:
                                                                                              13.sp,
                                                                                          color:
                                                                                              Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width:
                                                                                            8.w,
                                                                                      ),
                                                                                      // Number 2 box (circular)
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(
                                                                                          50.r,
                                                                                        ),
                                                                                        child: BackdropFilter(
                                                                                          filter: ImageFilter.blur(
                                                                                            sigmaX:
                                                                                                32,
                                                                                            sigmaY:
                                                                                                32,
                                                                                          ),
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.all(
                                                                                              8.w,
                                                                                            ),
                                                                                            decoration: BoxDecoration(
                                                                                              color: const Color(
                                                                                                0xFF0A1520,
                                                                                              ), // #0A1520
                                                                                              border: Border.all(
                                                                                                color: const Color(
                                                                                                  0xFFE5E6EB,
                                                                                                ).withOpacity(
                                                                                                  0.075,
                                                                                                ),
                                                                                                width:
                                                                                                    1,
                                                                                              ),
                                                                                              borderRadius: BorderRadius.circular(
                                                                                                50.r,
                                                                                              ),
                                                                                            ),
                                                                                            child: Text(
                                                                                              '2',
                                                                                              style: TextStyle(
                                                                                                fontFamily:
                                                                                                    AppFonts.geistMono,
                                                                                                fontWeight:
                                                                                                    FontWeight.w400,
                                                                                                fontSize:
                                                                                                    13.sp,
                                                                                                height:
                                                                                                    1.0,
                                                                                                color:
                                                                                                    Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width:
                                                                                  3.w,
                                                                            ),
                                                                            Text(
                                                                              '==',
                                                                              style: TextStyle(
                                                                                fontFamily:
                                                                                    AppFonts.geistMono,
                                                                                fontWeight:
                                                                                    FontWeight.w700,
                                                                                fontSize:
                                                                                    13.sp,
                                                                                color:
                                                                                    Colors.white,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width:
                                                                                  3.w,
                                                                            ),
                                                                            // Number 0 box (circular)
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(
                                                                                50.r,
                                                                              ),
                                                                              child: BackdropFilter(
                                                                                filter: ImageFilter.blur(
                                                                                  sigmaX:
                                                                                      32,
                                                                                  sigmaY:
                                                                                      32,
                                                                                ),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(
                                                                                    8.w,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color(
                                                                                      0xFF0A1520,
                                                                                    ), // #0A1520
                                                                                    border: Border.all(
                                                                                      color: const Color(
                                                                                        0xFFE5E6EB,
                                                                                      ).withOpacity(
                                                                                        0.075,
                                                                                      ),
                                                                                      width:
                                                                                          1,
                                                                                    ),
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      50.r,
                                                                                    ),
                                                                                  ),
                                                                                  child: Text(
                                                                                    '0',
                                                                                    style: TextStyle(
                                                                                      fontFamily:
                                                                                          AppFonts.geistMono,
                                                                                      fontWeight:
                                                                                          FontWeight.w400,
                                                                                      fontSize:
                                                                                          13.sp,
                                                                                      height:
                                                                                          1.0,
                                                                                      color:
                                                                                          Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              ':',
                                                                              style: TextStyle(
                                                                                fontFamily:
                                                                                    AppFonts.geistMono,
                                                                                fontWeight:
                                                                                    FontWeight.w700,
                                                                                fontSize:
                                                                                    13.sp,
                                                                                color:
                                                                                    Colors.white,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      // Top gradient border
                                                                      Positioned(
                                                                        top: 0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        height:
                                                                            1,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              begin:
                                                                                  Alignment.centerLeft,
                                                                              end:
                                                                                  Alignment.centerRight,
                                                                              colors: [
                                                                                Colors.transparent,
                                                                                Colors.white.withOpacity(
                                                                                  0.5,
                                                                                ),
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
                                                                        bottom:
                                                                            0,
                                                                        width:
                                                                            1,
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            gradient: LinearGradient(
                                                                              begin:
                                                                                  Alignment.topCenter,
                                                                              end:
                                                                                  Alignment.bottomCenter,
                                                                              colors: [
                                                                                Colors.transparent,
                                                                                Colors.white.withOpacity(
                                                                                  0.5,
                                                                                ),
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
                                                          ],
                                                        ),
                                                        SizedBox(height: 4.h),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 24.w,
                                                              ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  50.r,
                                                                ),
                                                            child: BackdropFilter(
                                                              filter:
                                                                  ImageFilter.blur(
                                                                    sigmaX: 32,
                                                                    sigmaY: 32,
                                                                  ),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        50.r,
                                                                      ),
                                                                  color: const Color(
                                                                    0x80444C5E,
                                                                  ), // #444C5E80
                                                                  border: Border.all(
                                                                    color: const Color(
                                                                      0xFFE5E6EB,
                                                                    ).withOpacity(
                                                                      0.101,
                                                                    ), // #E5E6EB1A
                                                                    width: 0.5,
                                                                  ),
                                                                ),
                                                                child: Stack(
                                                                  children: [
                                                                    // Content
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            4.w,
                                                                        vertical:
                                                                            2.h,
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          // total box
                                                                          ClipRRect(
                                                                            borderRadius: BorderRadius.circular(
                                                                              50.r,
                                                                            ),
                                                                            child: BackdropFilter(
                                                                              filter: ImageFilter.blur(
                                                                                sigmaX:
                                                                                    32,
                                                                                sigmaY:
                                                                                    32,
                                                                              ),
                                                                              child: Container(
                                                                                padding: EdgeInsets.all(
                                                                                  8.w,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(
                                                                                    0xFF0A1520,
                                                                                  ), // #0A1520
                                                                                  border: Border.all(
                                                                                    color: const Color(
                                                                                      0xFFE5E6EB,
                                                                                    ).withOpacity(
                                                                                      0.075,
                                                                                    ),
                                                                                    width:
                                                                                        1,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    50.r,
                                                                                  ),
                                                                                ),
                                                                                child: Text(
                                                                                  'total',
                                                                                  style: TextStyle(
                                                                                    fontFamily:
                                                                                        AppFonts.geistMono,
                                                                                    fontWeight:
                                                                                        FontWeight.w400,
                                                                                    fontSize:
                                                                                        13.sp,
                                                                                    height:
                                                                                        1.0,
                                                                                    color: const Color(
                                                                                      0xFF74FFA3,
                                                                                    ), // #74FFA3
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8.w,
                                                                          ),
                                                                          Text(
                                                                            '+=',
                                                                            style: TextStyle(
                                                                              fontFamily:
                                                                                  AppFonts.geistMono,
                                                                              fontWeight:
                                                                                  FontWeight.w700,
                                                                              fontSize:
                                                                                  13.sp,
                                                                              color:
                                                                                  Colors.white,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8.w,
                                                                          ),
                                                                          // order box
                                                                          ClipRRect(
                                                                            borderRadius: BorderRadius.circular(
                                                                              50.r,
                                                                            ),
                                                                            child: BackdropFilter(
                                                                              filter: ImageFilter.blur(
                                                                                sigmaX:
                                                                                    32,
                                                                                sigmaY:
                                                                                    32,
                                                                              ),
                                                                              child: Container(
                                                                                padding: EdgeInsets.all(
                                                                                  8.w,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(
                                                                                    0x999A4B4B,
                                                                                  ), // #9A4B4B99
                                                                                  border: Border.all(
                                                                                    color: const Color(
                                                                                      0xFFE5E6EB,
                                                                                    ).withOpacity(
                                                                                      0.075,
                                                                                    ),
                                                                                    width:
                                                                                        1,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    50.r,
                                                                                  ),
                                                                                ),
                                                                                child: Text(
                                                                                  'order',
                                                                                  style: TextStyle(
                                                                                    fontFamily:
                                                                                        AppFonts.geistMono,
                                                                                    fontWeight:
                                                                                        FontWeight.w400,
                                                                                    fontSize:
                                                                                        13.sp,
                                                                                    height:
                                                                                        1.0,
                                                                                    color: const Color(
                                                                                      0xFFF75F5F,
                                                                                    ), // #F75F5F
                                                                                  ),
                                                                                ),
                                                                              ),
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
                                                                            begin:
                                                                                Alignment.centerLeft,
                                                                            end:
                                                                                Alignment.centerRight,
                                                                            colors: [
                                                                              Colors.transparent,
                                                                              Colors.white.withOpacity(
                                                                                0.5,
                                                                              ),
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
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                            colors: [
                                                                              Colors.transparent,
                                                                              Colors.white.withOpacity(
                                                                                0.5,
                                                                              ),
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
                                                          begin:
                                                              Alignment
                                                                  .centerLeft,
                                                          end:
                                                              Alignment
                                                                  .centerRight,
                                                          colors: [
                                                            Colors.transparent,
                                                            Colors.white
                                                                .withOpacity(
                                                                  0.5,
                                                                ),
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
                                                          begin:
                                                              Alignment
                                                                  .topCenter,
                                                          end:
                                                              Alignment
                                                                  .bottomCenter,
                                                          colors: [
                                                            Colors.transparent,
                                                            Colors.white
                                                                .withOpacity(
                                                                  0.5,
                                                                ),
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
                    SizedBox(height: 8.h),
                    // PRINT section
                    Padding(
                      padding: EdgeInsets.only(left: 24.w, right: 14.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: const Color(0x99232834), // #23283499
                              border: Border.all(
                                color: const Color(0xFFE5E6EB).withOpacity(0.101), // #E5E6EB1A
                                width: 0.5,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Content
                                Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'PRINT',
                                        style: TextStyle(
                                          fontFamily: AppFonts.geistMono,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.sp,
                                          height: 1.4,
                                          color: const Color(0xFFB9B9B9), // #B9B9B9
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '(',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      // total box
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50.r),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                                          child: Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF0A1520), // #0A1520
                                              border: Border.all(
                                                color: const Color(0xFFE5E6EB).withOpacity(0.075),
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(50.r),
                                            ),
                                            child: Text(
                                              'total',
                                              style: TextStyle(
                                                fontFamily: AppFonts.geistMono,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.sp,
                                                height: 1.0,
                                                color: const Color(0xFF74FFA3), // #74FFA3
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        ')',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.sp,
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
                  ],
                ),
              ),
              // Python Builder Toolbar - fixed at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PythonBuilderToolbar(
                  onUndo: () {
                    // Handle undo action
                  },
                  onRedo: () {
                    // Handle redo action
                  },
                  onTableIcon: () {
                    // Handle table icon action
                  },
                  onRun: _onRun,
                ),
              ),
              // Popup overlay
              if (_showPopup)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 0.h + 4.h, // SafeArea + 10 spacing + icon height
                  right: 0,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: PythonPopup(
                      onSkip: _onSkip,
                      onHints: _onHints,
                      onReset: _onReset,
                    ),
                  ),
                ),
              // Hint popup overlay
              if (_showHintPopup)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _hintSlideAnimation,
                    child: HintPopup(
                      onClose: _onCloseHint,
                      onNextHint: _onNextHint,
                    ),
                  ),
                ),
              // Run result popup overlay
              if (_showRunResultPopup)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _runResultSlideAnimation,
                    child: RunResultPopup(
                      onClose: _onCloseRunResult,
                      onShowCompiledFailed: _onShowCompiledFailed,
                    ),
                  ),
                ),
              // Compiled failed popup overlay
              if (_showCompiledFailedPopup)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _compiledFailedSlideAnimation,
                    child: CompiledFailedPopup(
                      onClose: _onCloseCompiledFailed,
                      onShowInformation: _onShowInformation,
                    ),
                  ),
                ),
              // Information popup overlay
              if (_showInformationPopup)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _informationSlideAnimation,
                    child: InformationPopup(
                      onClose: _onCloseInformation,
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
}
