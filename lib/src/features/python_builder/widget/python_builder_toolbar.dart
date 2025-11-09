import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';

class PythonBuilderToolbar extends StatefulWidget {
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final VoidCallback? onTableIcon;
  final VoidCallback? onRun;

  const PythonBuilderToolbar({
    super.key,
    this.onUndo,
    this.onRedo,
    this.onTableIcon,
    this.onRun,
  });

  @override
  State<PythonBuilderToolbar> createState() => _PythonBuilderToolbarState();
}

class _PythonBuilderToolbarState extends State<PythonBuilderToolbar> {
  bool _isTableIconClicked = false;
  int _selectedTabIndex = 0;

  final List<String> _tabs = [
    'Math',
    'Logic',
    'Data',
    'Strings',
    'Functions',
    'Itertools',
    'Errors',
    'Variables',
  ];

  Widget _buildTabItem(String tabName, int index) {
    final isActive = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFE5E6EB).withOpacity(0.1),
                  width: 1,
                ),
                right: BorderSide.none,
                bottom: index < _tabs.length - 1
                    ? BorderSide(
                        color: const Color(0xFFE6E6EB).withOpacity(0.04), // #E5E6EB0A
                        width: 1,
                      )
                    : BorderSide.none,
                left: BorderSide(
                  color: const Color(0xFFE5E6EB).withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Stack(
              children: [
                // Background gradient
                if (isActive)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.0, 1.0],
                          colors: [
                            Color(0xFF273239), // #273239
                            Color(0x00273239), // rgba(39, 50, 57, 0)
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x40000000), // #00000040
                            offset: const Offset(0, 4),
                            blurRadius: 32,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                // Content
                Padding(
                  padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 8.w),
                  child: Text(
                    tabName,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
                // Top gradient border (only for active tab)
                if (isActive)
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
                            const Color(0xFFE5E6EB).withOpacity(0.1),
                            const Color(0xFFE5E6EB).withOpacity(0.009),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Left gradient border (only for active tab)
                if (isActive)
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
                            const Color(0xFFE5E6EB).withOpacity(0.1),
                            const Color(0xFFE5E6EB).withOpacity(0.009),
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

  Widget _buildTabsSection() {
    return Container(
      width: 82.w,
      decoration: BoxDecoration(
        color: const Color(0x05009CFF), // #009CFF05
        border: Border(
          right: BorderSide(
            color: const Color(0xFFE6E6EB).withOpacity(0.04), // #E5E6EB0A
            width: 1,
          ),
        ),
      ),
      child: Column(
        children:
            _tabs
                .asMap()
                .entries
                .map((entry) => _buildTabItem(entry.value, entry.key))
                .toList(),
      ),
    );
  }

  Widget _buildMathContent() {
    final mathItems = ['IF', 'ELIF', 'ELSE', 'FOR', 'IN', 'WHILE'];
    return _buildGridContent(mathItems);
  }

  Widget _buildClauseItem(String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0x99232834), // #23283499
            borderRadius: BorderRadius.circular(50.r),
            border: Border.all(
              width: 1,
              color: const Color(0xFFE5E6EB).withOpacity(0.101), // #E5E6EB1A
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Geist Mono',
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    height: 15 / 12,
                    color: const Color(0xFFB9B9B9), // #B9B9B9
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  width: 18.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF141F2A), // #141F2A
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFF586067), // #586067
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xCC000000), // #000000CC
                        offset: const Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 0,
                        blurStyle: BlurStyle.inner,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogicContent() {
    final logicItems = ['AND', 'OR', 'NOT', 'IF', 'ELIF', 'ELSE'];
    return _buildGridContent(logicItems);
  }

  Widget _buildDataContent() {
    final dataItems = ['IN', 'IS', 'TRUE', 'FALSE', 'NONE', 'LIST'];
    return _buildGridContent(dataItems);
  }

  Widget _buildStringsContent() {
    final stringItems = ['IN', 'IS', 'TRUE', 'STR', 'LEN', 'SPLIT'];
    return _buildGridContent(stringItems);
  }

  Widget _buildFunctionsContent() {
    final funcItems = ['FALSE', 'NONE', 'BREAK', 'CONTINUE', 'DEF', 'RETURN'];
    return _buildGridContent(funcItems);
  }

  Widget _buildItertoolsContent() {
    final List<String> itertoolsItems = ['PASS', 'ITER', 'NEXT', 'RANGE', 'ZIP', 'MAP'];
    return _buildGridContent(itertoolsItems);
  }

  Widget _buildErrorsContent() {
    final List<String> errorItems = ['TRY', 'EXCEPT', 'FINALLY', 'RAISE', 'ASSERT', 'ERROR'];
    return _buildGridContent(errorItems);
  }

  Widget _buildVariablesContent() {
    final List<String> variableItems = ['VAR', 'INT', 'FLOAT', 'BOOL', 'DICT', 'TUPLE'];
    return _buildGridContent(variableItems);
  }

  Widget _buildGridContent(List<String> items) {
    if (items.isEmpty) {
      return const SizedBox();
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(17.w),
      itemCount: (items.length / 3).ceil(),
      itemBuilder: (context, rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(
            children: [
              // First item in row
              _buildClauseItem(items[rowIndex * 3]),
              SizedBox(width: 6.w),
              // Second item in row (if exists)
              if (rowIndex * 3 + 1 < items.length)
                _buildClauseItem(items[rowIndex * 3 + 1]),
              SizedBox(width: 6.w),
              // Third item in row (if exists)
              if (rowIndex * 3 + 2 < items.length)
                _buildClauseItem(items[rowIndex * 3 + 2]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          // color: const Color(0x05009CFF), // #009CFF05
        ),
        child:
            _selectedTabIndex == 0
                ? _buildMathContent()
                : _selectedTabIndex == 1
                ? _buildLogicContent()
                : _selectedTabIndex == 2
                ? _buildDataContent()
                : _selectedTabIndex == 3
                ? _buildStringsContent()
                : _selectedTabIndex == 4
                ? _buildFunctionsContent()
                : _selectedTabIndex == 5
                ? _buildItertoolsContent()
                : _selectedTabIndex == 6
                ? _buildErrorsContent()
                : _selectedTabIndex == 7
                ? _buildVariablesContent()
                : const SizedBox(),
      ),
    );
  }

  Widget _buildRunButton() {
    return RippleService.wrapWithRipple(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onRun?.call();
      },
      borderRadius: 6.r,
      rippleColor: Colors.white.withOpacity(0.2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: EdgeInsets.fromLTRB(8.w, 5.h, 8.w, 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0x80034F90), // rgba(3, 79, 144, 0.5)
                  Color(0x80009DFF), // rgba(0, 157, 255, 0.5)
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Content
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.runIcon,
                      width: 14.w,
                      height: 14.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'RUN',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        height: 1.3,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    SvgPicture.asset(
                      AppIcons.runArrowicon,
                      width: 16.w,
                      height: 16.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
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

  Widget _buildHeaderContent() {
    return Row(
      children: [
        // Left section - Undo and Redo icons
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onUndo?.call();
          },
          child: SvgPicture.asset(
            AppIcons.undowicon,
            width: 20.w,
            height: 20.h,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onRedo?.call();
          },
          child: SvgPicture.asset(
            AppIcons.redoIcon,
            width: 20.w,
            height: 20.h,
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        // Middle section - Spacer
        const Spacer(),
        // Right section - Table icon and RUN button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _isTableIconClicked = !_isTableIconClicked;
            });
            widget.onTableIcon?.call();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                width: 25.w,
                height: 25.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Icon - cover the container
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: SvgPicture.asset(
                          _isTableIconClicked
                              ? AppIcons.tableIconClick
                              : AppIcons.tableicon,
                          fit: BoxFit.cover,
                          colorFilter:
                              _isTableIconClicked
                                  ? null // No color filter for clicked icon
                                  : const ColorFilter.mode(
                                    AppColors.white,
                                    BlendMode.srcIn,
                                  ),
                        ),
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
        SizedBox(width: 8.w),
        _buildRunButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header section with its own blur
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF093B5A), // #093B5A
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x40000000), // #00000040
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: _buildHeaderContent(),
            ),
          ),
        ),
        // Bottom section - Tabs and Content
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.tabsContainer),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left tabs section
              _buildTabsSection(),
              // Right content section
              _buildContentSection(),
            ],
          ),
        ),
      ],
    );
  }
}
