import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';

class BackTopBar extends StatelessWidget {
  final String? title;
  final bool showSettingsIcon;
  final Widget? customRightIcon;
  final VoidCallback? onCustomIconTap;

  const BackTopBar({
    super.key,
    this.title,
    this.showSettingsIcon = true,
    this.customRightIcon,
    this.onCustomIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: SvgPicture.asset(
            AppIcons.backIcon,
            width: 24.w,
            height: 24.h,
          ),
        ),
        if (title != null) ...[
          Expanded(
            child: Center(
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  height: 1.3,
                  letterSpacing: 12.sp * 0.04,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ] else
          const Spacer(),
        if (customRightIcon != null)
          RippleService.wrapWithRipple(
            onTap: onCustomIconTap ?? () {},
            borderRadius: 12.r,
            rippleColor: Colors.white.withOpacity(0.2),
            child: customRightIcon!,
          )
        else if (showSettingsIcon)
          RippleService.wrapWithRipple(
            onTap: () {
              // Handle settings tap
            },
            borderRadius: 12.r,
            rippleColor: Colors.white.withOpacity(0.2),
            child: SvgPicture.asset(
              AppIcons.settingIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                AppColors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
      ],
    );
  }
}


