import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/fonts.dart';

class ToolBarOneParameterBox extends StatelessWidget {
  final String label;
  final String? parameterValue;

  const ToolBarOneParameterBox({
    super.key,
    required this.label,
    this.parameterValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColors.toolbarChipBackground,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          width: 1,
          color: AppColors.toolbarChipBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: AppFonts.geistMono,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              height: 15 / 12,
              color: AppColors.toolbarChipText,
            ),
          ),
          SizedBox(width: 6.w),
          Container(
            width: 19.w,
            height: 17.h,
            decoration: BoxDecoration(
              color: AppColors.toolbarCircleBackground,
              borderRadius: BorderRadius.circular(17.r),
              border: Border.all(
                color: AppColors.toolbarChipBorder,
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.toolbarCircleShadow,
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(0, 0),
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
            child: parameterValue != null && parameterValue!.isNotEmpty
                ? Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        parameterValue!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppFonts.geistMono,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                          color: AppColors.toolbarChipText,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class ToolBarTwoParameterBox extends StatelessWidget {
  final String label;
  final String? leftValue;
  final String? rightValue;

  const ToolBarTwoParameterBox({
    super.key,
    required this.label,
    this.leftValue,
    this.rightValue,
  });

  Widget _buildCircle(String? value) {
    return Container(
      width: 19.w,
      height: 17.h,
      decoration: BoxDecoration(
        color: AppColors.toolbarCircleBackground,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: AppColors.toolbarChipBorder,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.toolbarCircleShadow,
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 0),
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: value != null && value.isNotEmpty
          ? Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.geistMono,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: AppColors.toolbarChipText,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColors.toolbarChipBackground,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          width: 1,
          color: AppColors.toolbarChipBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCircle(leftValue),
          SizedBox(width: 6.w),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: AppFonts.geistMono,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              height: 15 / 12,
              color: AppColors.toolbarChipText,
            ),
          ),
          SizedBox(width: 6.w),
          _buildCircle(rightValue),
        ],
      ),
    );
  }
}

class ToolBarOperatorChip extends StatelessWidget {
  final String symbol;

  const ToolBarOperatorChip({
    super.key,
    required this.symbol,
  });

  Widget _buildCircle() {
    return Container(
      width: 19.w,
      height: 17.h,
      decoration: BoxDecoration(
        color: AppColors.toolbarCircleBackground,
        borderRadius: BorderRadius.circular(17.r),
        border: Border.all(
          color: AppColors.toolbarChipBorder,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.toolbarCircleShadow,
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 0),
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColors.toolbarChipBackground,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          width: 1,
          color: AppColors.toolbarChipBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCircle(),
          SizedBox(width: 6.w),
          Text(
            symbol,
            style: TextStyle(
              fontFamily: AppFonts.geistMono,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              height: 15 / 12,
              color: AppColors.toolbarChipText,
            ),
          ),
          SizedBox(width: 6.w),
          _buildCircle(),
        ],
      ),
    );
  }
}

class ToolBarLabelChip extends StatelessWidget {
  final String label;

  const ToolBarLabelChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.toolbarChipBackground,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          width: 1,
          color: AppColors.toolbarChipBorder,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: AppFonts.geistMono,
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
          color: AppColors.toolbarChipText,
        ),
      ),
    );
  }
}

class ToolBarOrderChip extends StatelessWidget {
  final String text;

  const ToolBarOrderChip({
    super.key,
    this.text = 'order',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.orderChipBackground,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        text.toLowerCase(),
        style: TextStyle(
          fontFamily: AppFonts.geistMono,
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          height: 1,
          color: AppColors.orderChipText,
        ),
      ),
    );
  }
}
class ToolBarOrdersChip extends StatelessWidget {
  final String text;

  const ToolBarOrdersChip({
    super.key,
    this.text = 'orders',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.ordersChipBackground,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        text.toLowerCase(),
        style: TextStyle(
          fontFamily: AppFonts.geistMono,
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          height: 1,
          color: AppColors.ordersChipText,
        ),
      ),
    );
  }
}

class ToolBarTotalChip extends StatelessWidget {
  final String text;

  const ToolBarTotalChip({
    super.key,
    this.text = 'total',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.ordersChipBackground,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        text.toLowerCase(),
        style: TextStyle(
          fontFamily: AppFonts.geistMono,
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
          height: 1,
          color: AppColors.ordersChipText,
        ),
      ),
    );
  }
}

class ToolBarDigitChip extends StatelessWidget {
  final String text;

  const ToolBarDigitChip({
    super.key,
    required this.text,
  }) : assert(text != '', 'Digit chip text cannot be empty');

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.digitChipBorderTop,
            AppColors.digitChipBorderBottom,
          ],
        ),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 9.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.digitChipBackground,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: AppFonts.geistMono,
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
            height: 1,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class ToolBarSymbolChip extends StatelessWidget {
  final String text;

  const ToolBarSymbolChip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        // vertical: 6.h,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppFonts.geistMono,
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
          height: 1,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class ToolBarMatchConnector extends StatelessWidget {
  final String orderText;
  final String matchText;
  final String digitText;

  const ToolBarMatchConnector({
    super.key,
    this.orderText = 'order',
    this.matchText = 'MATCH',
    this.digitText = '2',
  });

  @override
  Widget build(BuildContext context) {
    return ToolBarTwoParameterConnector(
      leftValue: orderText,
      label: matchText,
      rightValue: digitText,
    );
  }
}

class ToolBarTwoParameterConnector extends StatelessWidget {
  final String leftValue;
  final String label;
  final String rightValue;

  const ToolBarTwoParameterConnector({
    super.key,
    required this.leftValue,
    required this.label,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColors.twoParamOuterBackground,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppColors.twoParamInnerBackground,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildParameterChoiceChip(leftValue),
            SizedBox(width: 6.w),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 6.h,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.geistMono,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  height: 1,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            _buildParameterChoiceChip(rightValue),
          ],
        ),
      ),
    );
  }
}

class ToolBarPairConnector extends StatelessWidget {
  final String label;
  final String orderText;

  const ToolBarPairConnector({
    super.key,
    this.label = 'FOR',
    this.orderText = 'order',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: AppFonts.geistMono,
            fontWeight: FontWeight.w700,
            fontSize: 13.sp,
            height: 1.4,
            color: AppColors.pairConnectorLabel,
          ),
        ),
        SizedBox(width: 6.w),
        _buildParameterChoiceChip(orderText),
      ],
    );
  }
}

final RegExp _digitChipRegExp = RegExp(r'^\d+$');

Widget _buildParameterChoiceChip(String? value) {
  final String display = value?.isNotEmpty == true ? value! : 'order';
  final String normalized = display.toLowerCase();
  if (normalized == 'orders') {
    return ToolBarOrdersChip(text: display);
  }
  if (normalized == 'total') {
    return ToolBarTotalChip(text: display);
  }
  if (_digitChipRegExp.hasMatch(normalized)) {
    return ToolBarDigitChip(text: display);
  }
  return ToolBarOrderChip(text: display);
}
