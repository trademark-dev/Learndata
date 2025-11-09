import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/quiz_header.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/custom_tabs.dart';
import 'package:d99_learn_data_enginnering/src/features/qiuze/widgets/quiz_answer_item.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/quiz_feedback_card.dart';

class TakeQuizPage extends StatefulWidget {
  const TakeQuizPage({super.key});

  @override
  State<TakeQuizPage> createState() => _TakeQuizPageState();
}

class _TakeQuizPageState extends State<TakeQuizPage> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  String? _selectedAnswer; // 'A', 'B', 'C', 'D'
  bool _showInfoPopup = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    StatusBarService.setTransparentStatusBar();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: Offset.zero, // Slide to position
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

  void _onAnswerSelected(String answer) async {
    // If C or D is clicked, just dismiss popup and reset selection
    if (answer == 'C' || answer == 'D') {
      if (_selectedAnswer != null) {
        await _slideController.reverse();
      }
      setState(() {
        _selectedAnswer = null; // Reset selection
      });
      return;
    }
    
    // For A or B, handle popup display
    // If a popup is already showing, dismiss it first
    if (_selectedAnswer != null) {
      await _slideController.reverse();
    }
    
    setState(() {
      _selectedAnswer = answer;
    });
    
    // Slide up new popup
    _slideController.forward();
  }

  void _onWhyPressed() async {
    // Dismiss current popup
    if (_selectedAnswer != null) {
      await _slideController.reverse();
    }
    
    // Show info popup
    setState(() {
      _selectedAnswer = null;
      _showInfoPopup = true;
    });
    
    _slideController.forward();
  }

  void _onInfoNextPressed() async {
    // Dismiss info popup
    if (_showInfoPopup) {
      await _slideController.reverse();
      setState(() {
        _showInfoPopup = false;
      });
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  List<TextSpan> _parseSQL(String sql) {
    List<TextSpan> spans = [];
    final keywordColor = const Color(0xFF68C5FF); // #68C5FF
    final defaultColor = const Color(0xFFEA74FF); // #EA74FF
    final stringColor = Colors.white;
    
    RegExp keywordRegex = RegExp(
      r'\b(SELECT|FROM|WHERE|AND|OR|AS|ORDER|BY|DISTINCT)\b',
      caseSensitive: false,
    );
    RegExp stringRegex = RegExp(r"'.*?'");
    
    int lastIndex = 0;
    
    // Find all strings first
    List<Match> stringMatches = stringRegex.allMatches(sql).toList();
    
    // Find all keywords
    List<Match> keywordMatches = keywordRegex.allMatches(sql).toList();
    
    // Combine and sort all matches
    List<Map<String, dynamic>> allMatches = [];
    for (var match in stringMatches) {
      allMatches.add({
        'start': match.start,
        'end': match.end,
        'type': 'string',
        'text': match.group(0)!,
      });
    }
    for (var match in keywordMatches) {
      allMatches.add({
        'start': match.start,
        'end': match.end,
        'type': 'keyword',
        'text': match.group(0)!,
      });
    }
    
    // Sort by start position
    allMatches.sort((a, b) => (a['start'] as int).compareTo(b['start'] as int));
    
    // Remove overlapping matches (keep strings over keywords)
    List<Map<String, dynamic>> filteredMatches = [];
    for (var match in allMatches) {
      bool overlaps = false;
      for (var existing in filteredMatches) {
        if ((match['start'] as int) < (existing['end'] as int) && 
            (match['end'] as int) > (existing['start'] as int) &&
            existing['type'] == 'string' && match['type'] == 'keyword') {
          overlaps = true;
          break;
        }
      }
      if (!overlaps) {
        filteredMatches.add(match);
      }
    }
    filteredMatches.sort((a, b) => (a['start'] as int).compareTo(b['start'] as int));
    
    // Build spans
    for (var match in filteredMatches) {
      final start = match['start'] as int;
      final end = match['end'] as int;
      final type = match['type'] as String;
      final text = match['text'] as String;
      
      // Add text before match
      if (start > lastIndex) {
        spans.add(TextSpan(
          text: sql.substring(lastIndex, start),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            height: 1.41,
            fontWeight: FontWeight.w400,
            color: defaultColor,
          ),
        ));
      }
      
      // Add the match
      if (type == 'keyword') {
        spans.add(TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: keywordColor,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            height: 1.41,
            fontWeight: FontWeight.w400,
            color: stringColor,
          ),
        ));
      }
      
      lastIndex = end;
    }
    
    // Add remaining text
    if (lastIndex < sql.length) {
      spans.add(TextSpan(
        text: sql.substring(lastIndex),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13.sp,
          height: 1.41,
          fontWeight: FontWeight.w400,
          color: defaultColor,
        ),
      ));
    }
    
    return spans;
  }

  Widget _buildDistinctButton({required bool isCorrect, required String icon}) {
    return Container(
      width: 85.w,
      height: 20.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.r),
        color: isCorrect ? const Color(0xFF4AA7E1) : const Color(0xFF8B5152), // #4AA7E1 or #8B5152
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DISTINCT',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
                height: 1.41,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset(
              icon,
              width: 11.w,
              height: 11.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First line: SELECT CustomerID, Amount AS Total [DISTINCT button]
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: _parseSQL('SELECT CustomerID, Amount AS Total'),
              ),
            ),
            SizedBox(width: 8.w),
            _buildDistinctButton(
              isCorrect: true,
              icon: AppIcons.queryTickico,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // FROM Orders
        RichText(
          text: TextSpan(
            children: _parseSQL('FROM Orders'),
          ),
        ),
        SizedBox(height: 8.h),
        // WHERE clause with second DISTINCT
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: _selectedTabIndex == 0
                    ? _parseSQL('WHERE Amount > 100 OR Status = \'Pending\'\nAND OrderDate >= \'2025-01-01\'')
                    : _parseSQL('WHERE (Amount > 100 OR Status = \'Pending\')\nAND OrderDate >= \'2025-01-01\''),
              ),
            ),
            SizedBox(width: 8.w),
            _buildDistinctButton(
              isCorrect: false,
              icon: AppIcons.queryCross,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // ORDER BY
        RichText(
          text: TextSpan(
            children: _parseSQL('ORDER BY CustomerID;'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate progress: 4 out of 13
    const int currentQuestion = 4;
    const int totalQuestions = 13;
    final double progressValue = currentQuestion / totalQuestions;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: QuizHeader(
                    currentProgress: '$currentQuestion/$totalQuestions',
                    progressValue: progressValue,
                  ),
                ),
                SizedBox(height: 20.h),
                // Main content with 20.w horizontal margins
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading
                      Center(
                        child: Text(
                          'What\'s wrong with this query?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            height: 1.3,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Custom tabs
                      CustomTabs(
                        tab1Label: 'Without Parenthesis',
                        tab2Label: 'With Parenthesis',
                        selectedIndex: _selectedTabIndex,
                        onTabChanged: _onTabChanged,
                        content: _buildQueryContent(),
                      ),
                      SizedBox(height: 16.h),
                      // ANSWER section with gradient line
                      Row(
                        children: [
                          Text(
                            'ANSWER',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              height: 1.3,
                              letterSpacing: 12.sp * 0.04,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF1A2E45),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Quiz answer items
                      QuizAnswerItem(
                        label: 'A',
                        text: 'The DISTINCT keyword is in the wrong position; parentheses are needed around the WHERE conditions to enforce correct precedence.',
                        isSelected: _selectedAnswer == 'A',
                        selectedBackgroundColor: _selectedAnswer == 'A'
                            ? const Color(0xFF1DB2DC) // Correct popup color
                            : null,
                        onTap: () => _onAnswerSelected('A'),
                      ),
                      SizedBox(height: 8.h),
                      QuizAnswerItem(
                        label: 'B',
                        text: 'AS cannot be used in SELECT; ORDER BY must come before WHERE.',
                        isSelected: _selectedAnswer == 'B',
                        selectedBackgroundColor: _selectedAnswer == 'B'
                            ? const Color(0xFF9D3B3C) // Wrong popup color
                            : null,
                        onTap: () => _onAnswerSelected('B'),
                      ),
                      SizedBox(height: 8.h),
                      QuizAnswerItem(
                        label: 'C',
                        text: 'There is no problem; this query will execute and return correct results.',
                        isSelected: _selectedAnswer == 'C',
                        onTap: () => _onAnswerSelected('C'),
                      ),
                      SizedBox(height: 8.h),
                      QuizAnswerItem(
                        label: 'D',
                        text: 'DISTINCT should replace ORDER BY; logical operators do not need parentheses.',
                        isSelected: _selectedAnswer == 'D',
                        onTap: () => _onAnswerSelected('D'),
                      ),
                      SizedBox(height: 100.h), // Space for feedback card
                    ],
                  ),
                ),
              ],
            ),
          ),
              // Feedback card at bottom
              if (_selectedAnswer != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: QuizFeedbackCard(
                      type: _selectedAnswer == 'A'
                          ? FeedbackType.correct
                          : FeedbackType.wrong,
                      onWhyPressed: _onWhyPressed,
                      onNextPressed: () {
                        // Handle NEXT button press
                      },
                      onHintPressed: () {
                        // Handle HINT button press
                      },
                      onTryAgainPressed: () {
                        // Handle TRY AGAIN button press
                      },
                    ),
                  ),
                ),
              // Info popup at bottom
              if (_showInfoPopup)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: QuizFeedbackCard(
                      type: FeedbackType.info,
                      onWhyPressed: null,
                      onNextPressed: _onInfoNextPressed,
                      onHintPressed: null,
                      onTryAgainPressed: null,
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

