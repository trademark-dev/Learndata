import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class LearnItemWidget extends StatelessWidget {
  final String text;
  final List<String> highlightedKeywords;
  
  const LearnItemWidget({
    super.key,
    required this.text,
    this.highlightedKeywords = const [],
  });

  List<TextSpan> _buildTextSpans() {
    List<TextSpan> spans = [];
    String remainingText = text;
    
    // Find all highlighted keywords and their positions
    List<Map<String, dynamic>> highlights = [];
    for (String keyword in highlightedKeywords) {
      int index = remainingText.indexOf(keyword);
      if (index != -1) {
        highlights.add({
          'keyword': keyword,
          'start': index,
          'end': index + keyword.length,
        });
      }
    }
    
    // Sort by position
    highlights.sort((a, b) => a['start'].compareTo(b['start']));
    
    int currentPos = 0;
    for (var highlight in highlights) {
      int start = highlight['start'];
      int end = highlight['end'];
      
      // Add normal text before highlight
      if (start > currentPos) {
        spans.add(TextSpan(
          text: remainingText.substring(currentPos, start),
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
            height: 1.3,
            color: Colors.white,
          ),
        ));
      }
      
      // Add highlighted text
      spans.add(TextSpan(
        text: remainingText.substring(start, end),
        style: TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
          fontSize: 13.sp,
          height: 1.4,
          color: AppColors.blue, // #68C5FF
        ),
      ));
      
      currentPos = end;
    }
    
    // Add remaining text
    if (currentPos < remainingText.length) {
      spans.add(TextSpan(
        text: remainingText.substring(currentPos),
        style: TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          height: 1.3,
          color: Colors.white,
        ),
      ));
    }
    
    return spans.isEmpty ? [
      TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          height: 1.3,
          color: Colors.white,
        ),
      )
    ] : spans;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Gray circle icon on left
        SvgPicture.asset(
          AppIcons.grayCircle,
          width: 15.w,
          height: 15.h,
        ),
        SizedBox(width: 13.w),
        // Box with full width
        Expanded(
          child: GlassBox(
            radius: 8,
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: _buildTextSpans(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

