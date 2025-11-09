import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';

class SqlBuilderToolbar extends StatefulWidget {
  final VoidCallback? onUndo;
  final VoidCallback? onRedo;
  final VoidCallback? onTableIcon;
  final VoidCallback? onRun;

  const SqlBuilderToolbar({
    super.key,
    this.onUndo,
    this.onRedo,
    this.onTableIcon,
    this.onRun,
  });

  @override
  State<SqlBuilderToolbar> createState() => _SqlBuilderToolbarState();
}

class _SqlBuilderToolbarState extends State<SqlBuilderToolbar> {
  bool _isTableIconClicked = false;
  int _selectedTabIndex = 0;
  
  final List<String> _tabs = [
    'Clauses',
    'Logic',
    'Aggregation',
    'Column',
    'Case',
    'Data',
    'Comparison',
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
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: 14.h, bottom: 14.h, left: 8.w),
        decoration: BoxDecoration(
          gradient:
              isActive
                  ? LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 1.0],
                    colors: [
                      const Color(0xFF093B5A), // #093B5A
                      const Color(0x00093B5A), // rgba(9, 59, 90, 0)
                    ],
                  )
                  : null,
          border:
              index < _tabs.length - 1
                  ? Border(
                    bottom: BorderSide(
                      color: const Color(
                        0xFFE6E6EB,
                      ).withOpacity(0.04), // #E5E6EB0A
                      width: 1,
                    ),
                  )
                  : null,
          boxShadow:
              isActive
                  ? [
                    BoxShadow(
                      color: const Color(0x40000000), // #00000040
                      offset: const Offset(0, 4),
                      blurRadius: 32,
                      spreadRadius: 0,
                    ),
                  ]
                  : null,
        ),
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

  Widget _buildClausesContent() {
    final clausesItems = ['OPERATOR', 'FROM', 'GROUP BY', 'ORDER BY', 'WHERE'];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      itemCount: (clausesItems.length / 2).ceil(),
      itemBuilder: (context, rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(
            children: [
              // First item in row
              _buildClauseItem(clausesItems[rowIndex * 2]),
              SizedBox(width: 6.w),
              // Second item in row (if exists)
              if (rowIndex * 2 + 1 < clausesItems.length)
                _buildClauseItem(clausesItems[rowIndex * 2 + 1]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClauseItem(String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x1A009CFF), // #009CFF1A
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          width: 1,
          color: const Color(0xFFE5E6EB).withOpacity(0.075),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 4.h),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Geist Mono',
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    height: 15 / 12,
                    color: const Color(0xFF68C5FF), // #68C5FF
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  width: 17.w,
                  height: 17.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF09253F), // #09253F
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFF184F7E), // #184F7E
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
                  child: Stack(
                    children: [
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
                                const Color(
                                  0x66184F7E,
                                ), // rgba(24, 79, 126, 0.4)
                                const Color(0xFF184F7E), // #184F7E
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
    );
  }

  Widget _buildComparisonContent() {
    final comparisonItems = [
      '=',
      '<>',
      '!=',
      '>',
      '<',
      '<=',
      '>=',
      'BETWEEN',
      'NOT BETWEEN',
      'IN',
      'NOT IN',
      'LIKE',
      'NOT LIKE',
      'IS NULL',
      'IS NOT NULL',
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      itemCount: (comparisonItems.length / 2).ceil(),
      itemBuilder: (context, rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(
            children: [
              // First item in row
              _buildComparisonItem(comparisonItems[rowIndex * 2]),
              SizedBox(width: 6.w),
              // Second item in row (if exists)
              if (rowIndex * 2 + 1 < comparisonItems.length)
                _buildComparisonItem(comparisonItems[rowIndex * 2 + 1]),
            ],
          ),
        );
      },
    );
  }

  bool _isSymbol(String text) {
    const symbols = ['=', '<>', '!=', '>', '<', '<=', '>='];
    return symbols.contains(text);
  }

  Widget _buildComparisonItem(String operator) {
    final isSymbol = _isSymbol(operator);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x1A009CFF), // #009CFF1A
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          width: 1,
          color: const Color(0xFFE5E6EB).withOpacity(0.075),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 4.h),
            child: Row(
              children: [
                _buildInputBox(),
                SizedBox(width: 4.w),
                Text(
                  operator,
                  style: TextStyle(
                    fontFamily: 'Roboto Mono',
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    height: 15 / 12,
                    color: isSymbol ? AppColors.white : const Color(0xFF68C5FF),
                  ),
                ),
                SizedBox(width: 4.w),
                if (operator != 'IS NULL' && operator != 'IS NOT NULL')
                  _buildInputBox(),
              ],
            ),
          ),
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
    );
  }

  Widget _buildInputBox() {
    return Container(
      width: 17.w,
      height: 17.h,
      decoration: BoxDecoration(
        color: const Color(0xFF09253F), // #09253F
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          width: 1,
          color: const Color(0xFF184F7E), // #184F7E
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
      child: Stack(
        children: [
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
                    const Color(0x66184F7E), // rgba(24, 79, 126, 0.4)
                    const Color(0xFF184F7E), // #184F7E
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogicContent() {
    final logicItems = ['AND', 'OR', 'NOT', 'XOR'];
    return _buildGridContent(logicItems);
  }

  Widget _buildAggregationContent() {
    final aggItems = ['COUNT', 'SUM', 'AVG', 'MIN', 'MAX'];
    return _buildGridContent(aggItems);
  }

  Widget _buildColumnContent() {
    final columnItems = ['*', 'DISTINCT', 'TOP', 'LIMIT'];
    return _buildGridContent(columnItems);
  }

  Widget _buildCaseContent() {
    final caseItems = ['CASE', 'WHEN', 'THEN', 'ELSE', 'END'];
    return _buildGridContent(caseItems);
  }

  Widget _buildDataContent() {
    final dataItems = [
      'INT',
      'VARCHAR',
      'DATE',
      'TIMESTAMP',
      'BOOLEAN',
      'DECIMAL',
    ];
    return _buildGridContent(dataItems);
  }

  Widget _buildGridContent(List<String> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      itemCount: (items.length / 2).ceil(),
      itemBuilder: (context, rowIndex) {
        return Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(
            children: [
              _buildClauseItem(items[rowIndex * 2]),
              SizedBox(width: 6.w),
              if (rowIndex * 2 + 1 < items.length)
                _buildClauseItem(items[rowIndex * 2 + 1]),
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
                ? _buildClausesContent()
                : _selectedTabIndex == 1
                ? _buildLogicContent()
                : _selectedTabIndex == 2
                ? _buildAggregationContent()
                : _selectedTabIndex == 3
                ? _buildColumnContent()
                : _selectedTabIndex == 4
                ? _buildCaseContent()
                : _selectedTabIndex == 5
                ? _buildDataContent()
                : _selectedTabIndex == 6
                ? _buildComparisonContent()
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
                // Top gradient border
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   right: 0,
                //   height: 1,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //         begin: Alignment.centerLeft,
                //         end: Alignment.centerRight,
                //         colors: [
                //           Colors.transparent,
                //           Colors.white.withOpacity(0.5),
                //           Colors.transparent,
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
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
