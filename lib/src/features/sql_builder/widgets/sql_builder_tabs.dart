import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';

class SqlBuilderTabs extends StatefulWidget {
  final List<String> tabs;
  final Function(int) onTabSelected;

  const SqlBuilderTabs({
    super.key,
    required this.tabs,
    required this.onTabSelected,
  });

  @override
  State<SqlBuilderTabs> createState() => _SqlBuilderTabsState();
}

class _SqlBuilderTabsState extends State<SqlBuilderTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82.w,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: const Color(0x0AE5E6EB), // #E5E6EB0A
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: List.generate(widget.tabs.length, (index) {
          final isLast = index == widget.tabs.length - 1;
          final isActive = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _selectedIndex = index;
              });
              widget.onTabSelected(index);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(8.w, 7.h, 8.w, 7.h),
              decoration: BoxDecoration(
                color: const Color(0x05009CFF), // #009CFF05
                border: Border(
                  right: BorderSide(
                    color: const Color(0x0AE5E6EB), // #E5E6EB0A
                    width: 1,
                  ),
                  bottom: isLast
                      ? BorderSide.none
                      : BorderSide(
                          color: const Color(0x0AE5E6EB), // #E5E6EB0A
                          width: 1,
                        ),
                ),
              ),
              child: Stack(
                children: [
                  // Text
                  Text(
                    widget.tabs[index],
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      height: 1.0,
                      color: Colors.white,
                    ),
                  ),
                  // Active tab gradient background
                  if (isActive)
                    Positioned.fill(
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Color(0xFF093B5A), // #093B5A
                                  Color(0x00093B5A), // rgba(9, 59, 90, 0)
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
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

