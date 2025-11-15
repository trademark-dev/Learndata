import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_images.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/fonts.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';
import 'package:d99_learn_data_enginnering/src/settings/page/buttons_settings.dart';

class MainTopBar extends StatelessWidget {
  const MainTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Row(
        children: [
          // Left side - Icon and text
          Row(
            children: [
              // SVG Icon (16x16)
              SvgPicture.asset(
                AppIcons.d99Logo,
                width: 16.w,
                height: 16.h,
              ),
              
              // 6px spacing
              SizedBox(width: 6.w),
              
              // "Learn Data Engineering" text
              Text(
                '<LEARN DATA>',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: AppFonts.medium,
                  color: AppColors.white,
                  fontFamily: AppFonts.roboto,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          
          // Spacer to push right content to the right
          const Spacer(),
          
          // Right side - Settings icon with ripple effect
          RippleService.wrapWithRipple(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ButtonsSettingsPage(),
                ),
              );
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
      ),
    );
  }
}
