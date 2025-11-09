import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d99_learn_data_enginnering/src/common/theme/app_colors.dart';
import 'package:d99_learn_data_enginnering/src/services/ripple_service.dart';

class BrandedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final String? icon;
  final double? iconWidth;
  final double? iconHeight;
  final double? width;
  final bool fullWidth;
  final List<Color>? gradientColors;

  const BrandedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.fullWidth = false,
    this.gradientColors,
  });

  @override
  State<BrandedButton> createState() => _BrandedButtonState();
}

class _BrandedButtonState extends State<BrandedButton>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    
    // Wave animation for splash effect
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _startWaveEffect() {
    // Reset and start wave animation immediately - always reset to start fresh
    _waveController.reset();
    _waveController.forward();
    // Add haptic feedback for button press
    HapticFeedback.lightImpact();
  }

  void _handleTapDown(TapDownDetails details) {
    _startWaveEffect();
  }

  void _handleTapUp(TapUpDetails details) {
    // Wave animation continues to complete - don't interfere
  }

  void _handleTapCancel() {
    // Let animation continue even if tap is cancelled
  }

  void _handleTap() {
    // Also trigger on tap to ensure quick taps work
    if (!_waveController.isAnimating) {
      _startWaveEffect();
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r), // Fully rounded
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: RippleService.wrapWithRipple(
            onTap: _handleTap,
            borderRadius: 100.r,
            rippleColor: Colors.white.withOpacity(0.2),
            child: AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Container(
                  height: 50.h,
                  width: widget.fullWidth ? double.infinity : (widget.width ?? 176.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: widget.gradientColors ?? const [
                        Color(0xFF034F90),
                        Color(0xFF009DFF),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF009DFF).withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x800A101D), // #0A101D80
                        offset: const Offset(0, 14),
                        blurRadius: 14,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Custom wave splash effect
                      if (_waveAnimation.value > 0)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: CustomPaint(
                              painter: WaveSplashPainter(
                                animation: _waveAnimation.value,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                      // Content - centered text
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              SvgPicture.asset(
                                widget.icon!,
                                width: widget.iconWidth ?? 16.w,
                                height: widget.iconHeight ?? 16.h,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(width: 4.w),
                            ],
                            Text(
                              widget.text,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                height: 1.3,
                                letterSpacing: 13.sp * 0.04,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Top gradient border
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Bottom gradient border
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Custom wave splash painter
class WaveSplashPainter extends CustomPainter {
  final double animation;
  final Color color;

  WaveSplashPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width > size.height ? size.width : size.height;
    final radius = maxRadius * animation;

    // Create wave effect with multiple circles
    for (int i = 0; i < 3; i++) {
      final waveRadius = radius - (i * 20);
      if (waveRadius > 0) {
        final opacity = (1.0 - (i * 0.3)) * (1.0 - animation);
        paint.color = color.withOpacity(opacity);
        canvas.drawCircle(center, waveRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(WaveSplashPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
