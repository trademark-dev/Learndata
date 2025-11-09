import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/services/status_bar_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/back_top_bar.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/custom_tabs.dart';
import 'package:d99_learn_data_enginnering/src/features/lesson_visual/widgets/result_table.dart';
import 'package:d99_learn_data_enginnering/src/features/lesson_visual/widgets/take_quiz_card.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/branded_button.dart';
import 'package:d99_learn_data_enginnering/src/features/qiuze/page/take_quiz_page.dart';
import 'package:d99_learn_data_enginnering/src/features/sql_builder/page/sql_builder_page.dart';

class LessonVisualPage extends StatefulWidget {
  const LessonVisualPage({super.key});

  @override
  State<LessonVisualPage> createState() => _LessonVisualPageState();
}

class _LessonVisualPageState extends State<LessonVisualPage> {
  int _selectedTabIndex = 0;
  int _selectedTabIndex2 = 0;

  @override
  void initState() {
    super.initState();
    StatusBarService.setTransparentStatusBar();
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
      r'\b(SELECT|FROM|WHERE|AND|OR)\b',
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
            height: 1.4,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
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
            height: 1.4,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: keywordColor,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            height: 1.4,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
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
          height: 1.4,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: defaultColor,
        ),
      ));
    }
    
    return spans;
  }

  Widget _buildCodeContent() {
    final sql = _selectedTabIndex == 0
        ? '''SELECT name, age, city, status
FROM users
WHERE age > 18 OR city = 'Boston'
AND status = 'active';'''
        : '''SELECT name, age, city, status
FROM users
WHERE (age > 18 OR city = 'Boston')
AND status = 'active';''';
    
    return SelectableText.rich(
      TextSpan(children: _parseSQL(sql)),
    );
  }

  Widget _buildExplanationCodeContent() {
    final sql = _selectedTabIndex == 0
        ? '''(age > 18 AND status = 'active') OR city = 'Boston';'''
        : '''(age > 18 OR city = 'Boston') AND status = 'active';''';
    
    return SelectableText.rich(
      TextSpan(children: _parseSQL(sql)),
    );
  }

  List<TextSpan> _parseSQLWithoutTightSpacing(String sql) {
    List<TextSpan> spans = [];
    final keywordColor = const Color(0xFF68C5FF); // #68C5FF
    final defaultColor = const Color(0xFFEA74FF); // #EA74FF
    final stringColor = Colors.white;
    
    RegExp keywordRegex = RegExp(
      r'\b(SELECT|FROM|WHERE|AND|OR)\b',
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
            height: 1.4,
            fontWeight: FontWeight.w600,
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
            height: 1.4,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: keywordColor,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            height: 1.4,
            fontWeight: FontWeight.w600,
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
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: defaultColor,
        ),
      ));
    }
    
    return spans;
  }

  Widget _buildFixingLogicCodeContent() {
    final sql = _selectedTabIndex2 == 0
        ? '''age > 18 OR city = 'Boston' AND status = 'active';'''
        : '''(age > 18 OR city = 'Boston') AND status = 'active';''';
    
    return SelectableText.rich(
      TextSpan(children: _parseSQLWithoutTightSpacing(sql)),
    );
  }

  void _onTabChanged2(int index) {
    setState(() {
      _selectedTabIndex2 = index;
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const BackTopBar(title: 'LEARN SQL'),
                ),
                SizedBox(height: 28.h),
                // Main content with 20.w horizontal margins
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Heading
                      Text(
                        'Query Structure',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          height: 1.3,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Description text
                      Text(
                        'When writing queries, you often need to filter results using multiple conditions. SQL uses logical operators like AND and OR, which follow strict precedence rules — AND is evaluated before OR. This can cause unexpected results, so use parentheses to control how conditions are applied.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      // Custom tabs
                      CustomTabs(
                        tab1Label: 'Without Parenthesis',
                        tab2Label: 'With Parenthesis',
                        selectedIndex: _selectedTabIndex,
                        onTabChanged: _onTabChanged,
                        content: _buildCodeContent(),
                      ),
                      SizedBox(height: 14.h),
                      // RESULT section with gradient line
                      Row(
                        children: [
                          Text(
                            'RESULT',
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
                      SizedBox(height: 14.h),
                      // Result table
                      ResultTable(
                        headers: ['Name', 'Age', 'Height', 'Weight', 'City', 'Status'],
                        rows: [
                          ['Jeff', '22', '180', '65', 'US', 'Active'],
                          ['Anna', '25', '165', '60', 'UK', 'Active'],
                          ['Evelyn', '30', '175', '70', 'CA', 'Active'],
                          ['Mark', '28', '177', '56', 'US', 'Active'],
                          ['John', '35', '182', '80', 'US', 'Active'],
                          ['Laura', '28', '160', '55', 'FR', 'Active'],
                        ],
                        selectedRowIndex: 3, // Mark row is selected
                      ),
                      SizedBox(height: 14.h),
                      // WHY DOES THIS HAPPEN section with gradient line
                      Row(
                        children: [
                          Text(
                            'WHY DOES THIS HAPPEN?',
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
                      SizedBox(height: 14.h),
                      // Explanation text
                      Text(
                        'In SQL, AND has a higher precedence than OR.\nThat means this query is read as:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      // Custom tabs for explanation
                      CustomTabs(
                        tab1Label: 'Without Parenthesis',
                        tab2Label: 'With Parenthesis',
                        selectedIndex: _selectedTabIndex,
                        onTabChanged: _onTabChanged,
                        content: _buildExplanationCodeContent(),
                      ),
                      SizedBox(height: 14.h),
                      // Conclusion text
                      Text(
                        'So even users you didn\'t expect (like inactive users from Boston) appear in the result.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      // Take Quiz card
                      TakeQuizCard(
                        onStartPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TakeQuizPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 14.h),
                      // FIXING THE LOGIC section with gradient line
                      Row(
                        children: [
                          Text(
                            'FIXING THE LOGIC',
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
                      SizedBox(height: 14.h),
                      // Explanation text
                      Text(
                        'To make sure SQL reads it the way you intend, wrap your conditions like this:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      // Custom tabs for fixing logic
                      CustomTabs(
                        tab1Label: 'Without Parenthesis',
                        tab2Label: 'With Parenthesis',
                        selectedIndex: _selectedTabIndex2,
                        onTabChanged: _onTabChanged2,
                        content: _buildFixingLogicCodeContent(),
                      ),
                      SizedBox(height: 14.h),
                      // Conclusion text
                      Text(
                        'Now, the database first checks age or city, and then filters by active status — giving you exactly the users you want.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 28.h),
                      // Center gradient line
                      Container(
                        height: 1,
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              const Color(0xFF14263A), // #14263A
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      SizedBox(height: 28.h),
                      // Try It Out button
                      BrandedButton(
                        text: 'TRY IT OUT',
                        icon: AppIcons.tryItOut,
                        iconWidth: 18.w,
                        iconHeight: 18.w,
                        fullWidth: true,
                        gradientColors: const [
                          Color(0x80034F90), // rgba(3, 79, 144, 0.5)
                          Color(0x80009DFF), // rgba(0, 157, 255, 0.5)
                        ],
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SqlBuilderPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 23.h),
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
}
