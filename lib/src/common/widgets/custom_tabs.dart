import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class CustomTabs extends StatelessWidget {
  final String tab1Label;
  final String tab2Label;
  final int selectedIndex;
  final Function(int) onTabChanged;
  final Widget? content;

  const CustomTabs({
    super.key,
    required this.tab1Label,
    required this.tab2Label,
    this.selectedIndex = 0,
    required this.onTabChanged,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      radius: 12,
      width: double.infinity,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Main content
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs section
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    // Tab 1
                    Expanded(
                      child: RippleService.wrapWithRipple(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onTabChanged(0);
                        },
                        borderRadius: 6.r,
                        rippleColor: Colors.white.withOpacity(0.2),
                        child: selectedIndex == 0
                            ? GlassBox(
                                radius: 6,
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: Text(
                                  tab1Label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    height: 1.3,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                alignment: Alignment.center,
                                child: Text(
                                  tab1Label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    height: 1.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Tab 2
                    Expanded(
                      child: RippleService.wrapWithRipple(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onTabChanged(1);
                        },
                        borderRadius: 6.r,
                        rippleColor: Colors.white.withOpacity(0.2),
                        child: selectedIndex == 1
                            ? GlassBox(
                                radius: 6,
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: Text(
                                  tab2Label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    height: 1.3,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                alignment: Alignment.center,
                                child: Text(
                                  tab2Label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                    height: 1.3,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content box if provided
              if (content != null) ...[
                SizedBox(height: 0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0x1AB9CEF1), // #B9CEF11A
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: content,
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
