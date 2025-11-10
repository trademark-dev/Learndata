import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/back_top_bar.dart';
import 'package:d99_learn_data_enginnering/src/features/sql_builder/widgets/skip_challenge_popup.dart';
import 'package:d99_learn_data_enginnering/src/features/sql_builder/widgets/sql_builder_canvas.dart';
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
  final List<String> _canvasBlocks = [];
  final List<List<String>> _undoStack = [];
  final List<List<String>> _redoStack = [];

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

  void _recordForUndo() {
    _undoStack.add(List<String>.from(_canvasBlocks));
    if (_undoStack.length > 50) {
      _undoStack.removeAt(0);
    }
  }

  void _handleBlockDropped(String block) {
    setState(() {
      _recordForUndo();
      _canvasBlocks.add(block);
      _redoStack.clear();
    });
  }

  void _removeCanvasBlock(int index) {
    if (index < 0 || index >= _canvasBlocks.length) return;
    setState(() {
      _recordForUndo();
      _canvasBlocks.removeAt(index);
      _redoStack.clear();
    });
  }

  void _clearCanvas() {
    if (_canvasBlocks.isEmpty) return;
    setState(() {
      _recordForUndo();
      _canvasBlocks.clear();
      _redoStack.clear();
    });
  }

  void _undo() {
    if (_undoStack.isEmpty) return;
    setState(() {
      _redoStack.add(List<String>.from(_canvasBlocks));
      final previous = _undoStack.removeLast();
      _canvasBlocks
        ..clear()
        ..addAll(previous);
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _undoStack.add(List<String>.from(_canvasBlocks));
      final next = _redoStack.removeLast();
      _canvasBlocks
        ..clear()
        ..addAll(next);
    });
  }

  bool get _canUndo => _undoStack.isNotEmpty;
  bool get _canRedo => _redoStack.isNotEmpty;

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
                    // Query builder canvas
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SqlBuilderCanvas(
                        blocks: _canvasBlocks,
                        onBlockDropped: _handleBlockDropped,
                        onRemoveBlock: _removeCanvasBlock,
                        onClear: _canvasBlocks.isNotEmpty ? _clearCanvas : null,
                      ),
                    ),
                    SizedBox(height: 18.h),
                  ],
                ),
              ),
              // SQL Builder Toolbar - fixed at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SqlBuilderToolbar(
                  onUndo: _canUndo ? _undo : null,
                  onRedo: _canRedo ? _redo : null,
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