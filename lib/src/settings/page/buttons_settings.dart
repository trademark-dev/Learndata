import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/fonts.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/all_types_python_widgets.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';

class ButtonsSettingsPage extends StatelessWidget {
  const ButtonsSettingsPage({super.key});

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
            image: AssetImage(AppImages.appBg),
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
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Row(
                    children: [
                      RippleService.wrapWithRipple(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: 12.r,
                        rippleColor: Colors.white.withOpacity(0.2),
                        child: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Colors.white.withOpacity(0.08),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 16.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'BUTTONS SETTINGS',
                        style: TextStyle(
                          fontFamily: AppFonts.roboto,
                          fontSize: 14.sp,
                          fontWeight: AppFonts.medium,
                          letterSpacing: 1.2,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarOneParameterBox(label: 'IF'),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarTwoParameterBox(label: 'FOR'),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarLabelChip(label: 'CONTINUE'),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarOrderChip(),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarOrdersChip(),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarTotalChip(),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarDigitChip(text: '2'),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarOperatorChip(symbol: '=='),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarMatchConnector(),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: const ToolBarPairConnector(),
                ),
              ],
              
            ),
          ),
        ),
      ),
    );
  }
}