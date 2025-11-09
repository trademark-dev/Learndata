import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RippleService {
  /// Creates a Material ripple effect wrapper for any widget
  static Widget wrapWithRipple({
    required Widget child,
    required VoidCallback? onTap,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    Color? rippleColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
        splashColor: rippleColor ?? Colors.black.withOpacity(0.1),
        highlightColor: rippleColor ?? Colors.black.withOpacity(0.05),
        child: padding != null
            ? Padding(
                padding: padding,
                child: child,
              )
            : child,
      ),
    );
  }

  /// Creates a ripple effect for buttons with shadow
  static Widget wrapButtonWithRipple({
    required Widget child,
    required VoidCallback? onTap,
    double? borderRadius,
    Color? rippleColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
        splashColor: rippleColor ?? Colors.black.withOpacity(0.1),
        highlightColor: rippleColor ?? Colors.black.withOpacity(0.05),
        child: child,
      ),
    );
  }

  /// Creates a ripple effect for text links
  static Widget wrapTextWithRipple({
    required Widget child,
    required VoidCallback? onTap,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    Color? rippleColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
        splashColor: rippleColor ?? Colors.black.withOpacity(0.1),
        highlightColor: rippleColor ?? Colors.black.withOpacity(0.05),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
          child: child,
        ),
      ),
    );
  }

  /// Creates a ripple effect for circular buttons (like Google sign-in)
  static Widget wrapCircularButtonWithRipple({
    required Widget child,
    required VoidCallback? onTap,
    double? borderRadius,
    Color? rippleColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 50.r),
        splashColor: rippleColor ?? Colors.black.withOpacity(0.1),
        highlightColor: rippleColor ?? Colors.black.withOpacity(0.05),
        child: child,
      ),
    );
  }
}
