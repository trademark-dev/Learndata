import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassBox extends StatelessWidget {
  const GlassBox({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.radius,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular((radius ?? 6).r);
    final double boxWidth = width ?? 320.w;
    final double? boxHeight = height;
    const Color tintBase = Color(0xFF68C5FF);
    final Color edgeLightColor = Colors.white.withOpacity(0.6);
    final Color topCornerColor = Colors.white.withOpacity(0.8);
    final Color bottomCornerColor = Colors.white.withOpacity(0.8);

    return Container(
      width: boxWidth,
      height: boxHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A101D).withOpacity(0.50),
            blurRadius: 14,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: CustomPaint(
            foregroundPainter: _GlassBorderPainter(
              radius: borderRadius,
              edgeColor: edgeLightColor,
              topLeftCornerColor: topCornerColor,
              bottomRightCornerColor: bottomCornerColor,
              strokeWidth: 0.675,
              leftEdgeFraction: 0.98,
              rightEdgeFraction: 0.98,
              topExtendPx: 11,
              bottomExtendPx: 11,
            ),
            child: Container(
              padding: padding ?? EdgeInsets.all(16.w),
              alignment: Alignment.center,
              color: tintBase.withOpacity(0.02),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassBorderPainter extends CustomPainter {
  const _GlassBorderPainter({
    required this.radius,
    required this.edgeColor,
    required this.topLeftCornerColor,
    required this.bottomRightCornerColor,
    required this.strokeWidth,
    required this.leftEdgeFraction,
    required this.rightEdgeFraction,
    required this.topExtendPx,
    required this.bottomExtendPx,
  });

  final BorderRadius radius;
  final Color edgeColor;
  final Color topLeftCornerColor;
  final Color bottomRightCornerColor;
  final double strokeWidth;
  final double leftEdgeFraction;
  final double rightEdgeFraction;
  final double topExtendPx;
  final double bottomExtendPx;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = radius.toRRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final double inset = strokeWidth / 2;
    final RRect borderRRect = rrect.deflate(inset);

    final double cornerRadiusX = radius.bottomRight.x;
    final double cornerOffsetFraction = 0.12;
    final double bottomInset = cornerRadiusX > 0
        ? cornerRadiusX * cornerOffsetFraction
        : size.width * 0.02;

    final double topLeftCornerX = borderRRect.left + radius.topLeft.x;
    final double topLeftCornerY = borderRRect.top + radius.topLeft.y;

    // --- Top-left corner ---
    final Path topLeftArc = Path()
      ..moveTo(borderRRect.left, topLeftCornerY)
      ..arcToPoint(
        Offset(topLeftCornerX, borderRRect.top),
        radius: Radius.circular(radius.topLeft.x),
        clockwise: true,
      );
    canvas.drawPath(
      topLeftArc,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = topLeftCornerColor,
    );

    // --- Top edge ---
    final Path topPath = Path()
      ..moveTo(topLeftCornerX, borderRRect.top)
      ..lineTo(borderRRect.right + topExtendPx, borderRRect.top);
    canvas.drawPath(
      topPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.linear(
          Offset(topLeftCornerX, borderRRect.top),
          Offset(borderRRect.right + topExtendPx, borderRRect.top),
          [edgeColor, edgeColor.withOpacity(0.1)],
          [0.8, 0.95],
        ),
    );

    // --- Left edge ---
    final double leftEndY = topLeftCornerY + (borderRRect.height - radius.topLeft.y) * leftEdgeFraction;
    canvas.drawLine(
      Offset(borderRRect.left, topLeftCornerY),
      Offset(borderRRect.left, leftEndY),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.linear(
          Offset(borderRRect.left, topLeftCornerY),
          Offset(borderRRect.left, leftEndY),
          [edgeColor, edgeColor.withOpacity(0.1)],
          [0.8, 0.95],
        ),
    );

    // --- Bottom-right corner ---
    final double bottomRightCornerX = borderRRect.right - radius.bottomRight.x;
    final double bottomRightCornerY = borderRRect.bottom - radius.bottomRight.y;
    final Path bottomRightArc = Path()
      ..moveTo(borderRRect.right, bottomRightCornerY)
      ..arcToPoint(
        Offset(bottomRightCornerX, borderRRect.bottom),
        radius: Radius.circular(radius.bottomRight.x),
        clockwise: true,
      );
    canvas.drawPath(
      bottomRightArc,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = bottomRightCornerColor,
    );

    // --- Bottom edge ---
    final double defaultBottomStart =
        bottomRightCornerX - math.min(bottomInset, cornerRadiusX);
    final double bottomStartX = math.max(
      borderRRect.left,
      defaultBottomStart - size.width * 0.05,
    );
    final Path bottomPath = Path()
      ..moveTo(bottomRightCornerX, borderRRect.bottom)
      ..lineTo(bottomStartX, borderRRect.bottom)
      ..lineTo(borderRRect.left + radius.bottomLeft.x - bottomExtendPx, borderRRect.bottom);
    canvas.drawPath(
      bottomPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.linear(
          Offset(bottomRightCornerX, borderRRect.bottom),
          Offset(borderRRect.left + radius.bottomLeft.x - bottomExtendPx, borderRRect.bottom),
          [edgeColor, edgeColor.withOpacity(0.1)],
          [0.85, 1.0],
        ),
    );

    // --- Right edge ---
    final double rightStartY = math.max(
      borderRRect.top,
      bottomRightCornerY,
    );
    final double defaultRightEnd = borderRRect.bottom -
        (borderRRect.height - radius.bottomRight.y) * rightEdgeFraction;
    final double rightEndY = math.max(
      borderRRect.top,
      defaultRightEnd - size.height * 0.05,
    );
    final Offset rightStart = Offset(borderRRect.right, rightStartY);
    final Offset rightEnd = Offset(borderRRect.right, rightEndY);
    canvas.drawLine(
      rightStart,
      rightEnd,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = ui.Gradient.linear(
          rightStart,
          rightEnd,
          [edgeColor, edgeColor.withOpacity(0.1)],
          [0.85, 1.0],
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _GlassBorderPainter oldDelegate) {
    return radius != oldDelegate.radius ||
        edgeColor != oldDelegate.edgeColor ||
        topLeftCornerColor != oldDelegate.topLeftCornerColor ||
        bottomRightCornerColor != oldDelegate.bottomRightCornerColor ||
        strokeWidth != oldDelegate.strokeWidth ||
        leftEdgeFraction != oldDelegate.leftEdgeFraction ||
        rightEdgeFraction != oldDelegate.rightEdgeFraction;
  }
}

