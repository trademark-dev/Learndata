import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/common/widgets/glass_box.dart';

class SqlBuilderContainer extends StatelessWidget {
  final Widget child;

  const SqlBuilderContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlassBox(
      radius: 16,
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      child: child,
    );
  }
}

