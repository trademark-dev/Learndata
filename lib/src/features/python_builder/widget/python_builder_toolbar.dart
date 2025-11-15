import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/all_types_python_widgets.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';
import 'package:d99_learn_data_enginnering/src/features/python_builder/model/block_metadata.dart';

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
    'Operators',
    'Data',
    'Strings',
    'Functions',
    'Itertools',
    'Errors',
    'Variables',
  ];

  Widget _buildDraggable({
    required String data,
    required Widget Function() builder,
  }) {
    final Widget chip = builder();
    return LongPressDraggable<String>(
      data: data,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: _PythonDragFeedbackChip(label: data),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: chip,
      ),
      child: chip,
    );
  }

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

  Widget _buildTabsSection(double height) {
    return SizedBox(
      width: 82.w,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x05009CFF), // #009CFF05
          border: Border(
            right: BorderSide(
              color: const Color(0xFFE6E6EB).withOpacity(0.04), // #E5E6EB0A
              width: 1,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children:
                _tabs
                    .asMap()
                    .entries
                    .map((entry) => _buildTabItem(entry.value, entry.key))
                    .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMathContent() {
    final mathItems = [
      'SUM',
      'MIN',
      'MAX',
      'ABS',
      'ROUND',
      'FLOOR',
      'CEIL',
      'POW',
      'DIVMOD',
      'SQRT',
      'LOG',
      'EXP',
      'FACTORIAL',
      'CLAMP',
      'RANGE',
      'HYPOT',
      'COMPLEX',
      'FRACTION',
      'DECIMAL',
    ];
    return _buildGridContent(mathItems);
  }

  Widget _buildChip(String label) {
    final upperLabel = label.toUpperCase();
    if (BlockMetadata.digitPattern.hasMatch(label)) {
      return ToolBarDigitChip(text: label);
    }
    if (BlockMetadata.symbolLabels.contains(label)) {
      return ToolBarOperatorChip(symbol: label);
    }
    if (BlockMetadata.labelOnlyLabels.contains(upperLabel)) {
      return ToolBarLabelChip(label: upperLabel);
    }
    if (BlockMetadata.twoParamLabels.contains(upperLabel)) {
      return ToolBarTwoParameterBox(label: upperLabel);
    }
    return ToolBarOneParameterBox(label: upperLabel);
  }

  Widget _buildClauseItem(String label) {
    return _buildDraggable(
      data: label,
      builder: () => _buildChip(label),
    );
  }

  Widget _buildLogicContent() {
    final logicItems = [
      'IF',
      'ELIF',
      'ELSE',
      'MATCH',
      'CASE',
      'FOR',
      'WHILE',
      'BREAK',
      'CONTINUE',
      'PASS',
      'AND',
      'OR',
      'NOT',
      'IN',
      'NOT IN',
      'IS',
      'IS NOT',
      'TRUE',
      'FALSE',
      'NONE',
      'ALL',
      'ANY',
      'BOOL',
    ];
    return _buildGridContent(logicItems);
  }

  Widget _buildOperatorsContent() {
    return _buildGridContent(BlockMetadata.operatorTokens);
  }

  Widget _buildDataContent() {
    final dataItems = [
      'LIST',
      'TUPLE',
      'DICT',
      'SET',
      'FROZENSET',
      'RANGE',
      'ENUMERATE',
      'ZIP',
      'MAP',
      'FILTER',
      'SORTED',
      'REVERSED',
      'SLICE',
      'APPEND',
      'EXTEND',
      'INSERT',
      'POP',
      'REMOVE',
      'CLEAR',
      'COPY',
      'UPDATE',
      'ITEMS',
      'VALUES',
      'KEYS',
      'DEFAULTDICT',
      'COUNTER',
      'GROUPBY',
    ];
    return _buildGridContent(dataItems);
  }

  Widget _buildStringsContent() {
    final stringItems = [
      'STR',
      'LEN',
      'SPLIT',
      'JOIN',
      'FORMAT',
      'FSTRING',
      'LOWER',
      'UPPER',
      'TITLE',
      'STRIP',
      'REPLACE',
      'STARTSWITH',
      'ENDSWITH',
      'FIND',
      'COUNT',
      'SLICE',
      'ENCODE',
      'DECODE',
      'REGEX',
      'SUB',
    ];
    return _buildGridContent(stringItems);
  }

  Widget _buildFunctionsContent() {
    final funcItems = [
      'DEF',
      'RETURN',
      'LAMBDA',
      'YIELD',
      'YIELD FROM',
      'ASYNC',
      'AWAIT',
      'GLOBAL',
      'NONLOCAL',
      'DECORATOR',
      'CALLABLE',
      'ARGS',
      'KWARGS',
      'IMPORT',
      'FROM',
      'AS',
      'WITH',
      'PASS',
      'ASSERT',
      'RAISE',
      'DOCSTRING',
    ];
    return _buildGridContent(funcItems);
  }

  Widget _buildItertoolsContent() {
    final List<String> itertoolsItems = [
      'ITER',
      'NEXT',
      'RANGE',
      'ZIP',
      'MAP',
      'FILTER',
      'CHAIN',
      'CYCLE',
      'PRODUCT',
      'PERMUTATIONS',
      'COMBINATIONS',
      'ACCUMULATE',
      'GROUPBY',
      'COUNT',
      'ISLICE',
      'TAKEWHILE',
      'DROPWHILE',
      'ENUMERATE',
      'LISTCOMPREHENSION',
      'GENEXPR',
    ];
    return _buildGridContent(itertoolsItems);
  }

  Widget _buildErrorsContent() {
    final List<String> errorItems = [
      'TRY',
      'EXCEPT',
      'FINALLY',
      'ELSE',
      'RAISE',
      'ASSERT',
      'ERROR',
      'WARNING',
      'VALUEERROR',
      'TYPEERROR',
      'KEYERROR',
      'INDEXERROR',
      'IOERROR',
      'IMPORTERROR',
      'ATTRIBUTEERROR',
      'RUNTIMEERROR',
      'TRACEBACK',
      'LOG',
    ];
    return _buildGridContent(errorItems);
  }

  Widget _buildVariablesContent() {
    final List<String> variableItems = [
      'VAR',
      'INT',
      'FLOAT',
      'BOOL',
      'STR',
      'LIST',
      'DICT',
      'SET',
      'TUPLE',
      'CONST',
      'CLASS',
      'SELF',
      'INIT',
      'ATTRIBUTE',
      'PROPERTY',
      'STATIC',
      'CLASSMETHOD',
      'DATACLASS',
      'TYPEHINT',
      'OPTIONAL',
      'UNION',
      'TYPEVAR',
    ];
    return _buildGridContent(variableItems);
  }

  Widget _buildGridContent(List<String> items) {
    if (items.isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.all(17.w),
      child: Wrap(
        spacing: 6.w,
        runSpacing: 6.h,
        children: items.map(_buildClauseItem).toList(),
      ),
    );
  }

  Widget _buildContentSection(double height) {
    Widget content =
        _selectedTabIndex == 0
            ? _buildMathContent()
            : _selectedTabIndex == 1
                ? _buildLogicContent()
                : _selectedTabIndex == 2
                    ? _buildOperatorsContent()
                    : _selectedTabIndex == 3
                        ? _buildDataContent()
                        : _selectedTabIndex == 4
                            ? _buildStringsContent()
                            : _selectedTabIndex == 5
                                ? _buildFunctionsContent()
                                : _selectedTabIndex == 6
                                    ? _buildItertoolsContent()
                                    : _selectedTabIndex == 7
                                        ? _buildErrorsContent()
                                        : _selectedTabIndex == 8
                                            ? _buildVariablesContent()
                                            : const SizedBox();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          // color: const Color(0x05009CFF), // #009CFF05
        ),
        child: SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: content,
          ),
        ),
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
    final bool undoEnabled = widget.onUndo != null;
    final bool redoEnabled = widget.onRedo != null;

    return Row(
      children: [
        // Left section - Undo and Redo icons
        GestureDetector(
          onTap: undoEnabled
              ? () {
                  HapticFeedback.lightImpact();
                  widget.onUndo?.call();
                }
              : null,
          child: Opacity(
            opacity: undoEnabled ? 1.0 : 0.35,
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
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: redoEnabled
              ? () {
                  HapticFeedback.lightImpact();
                  widget.onRedo?.call();
                }
              : null,
          child: Opacity(
            opacity: redoEnabled ? 1.0 : 0.35,
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
    final double toolbarBodyHeight = 320.h;

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
          height: toolbarBodyHeight,
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
              _buildTabsSection(toolbarBodyHeight),
              // Right content section
              _buildContentSection(toolbarBodyHeight),
            ],
          ),
        ),
      ],
    );
  }
}

class _PythonDragFeedbackChip extends StatelessWidget {
  final String label;

  const _PythonDragFeedbackChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4BEDC2),
              Color(0xFF67A6FF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B253C).withOpacity(0.55),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.35),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
