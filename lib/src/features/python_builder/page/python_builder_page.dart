import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/back_top_bar.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/python_builder_toolbar.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/widget/python_builder_canvas.dart';
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

  final List<String> _canvasBlocks = [];
  final List<List<String>> _undoStack = [];
  final List<List<String>> _redoStack = [];

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

  Widget _buildQuestionCard() {
    return GlassBox(
      radius: 16,
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      child: Row(
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
              'Write a loop to add an array of numbers.',
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
    );
  }

  Widget _buildReferenceCard() {
    return GlassBox(
      radius: 16,
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need a hint?',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Drag blocks like FOR, IN, IF, and += from the palette to build the solution. '
            'Use undo or redo if you need to adjust the order of your blocks.',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              height: 1.45,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
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
                padding: EdgeInsets.only(bottom: 280.h),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _buildQuestionCard(),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: PythonBuilderCanvas(
                        blocks: _canvasBlocks,
                        onBlockDropped: _handleBlockDropped,
                        onRemoveBlock: _removeCanvasBlock,
                        onClear: _canvasBlocks.isNotEmpty ? _clearCanvas : null,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _buildReferenceCard(),
                    ),
                    SizedBox(height: 160.h),
                  ],
                ),
              ),
              // Python Builder Toolbar - fixed at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PythonBuilderToolbar(
                  onUndo: _canUndo ? _undo : null,
                  onRedo: _canRedo ? _redo : null,
                  onTableIcon: () {},
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
