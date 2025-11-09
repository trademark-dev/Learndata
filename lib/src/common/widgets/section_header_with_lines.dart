import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeaderWithLines extends StatelessWidget {
  final String title;
  final Color lineColor;

  const SectionHeaderWithLines({super.key, required this.title, this.lineColor = const Color(0xFF171D2A)});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left line (fades outward)
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  lineColor,
                  lineColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            height: 1.3,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 8.w),
        // Right line (fades outward)
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  lineColor,
                  lineColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


