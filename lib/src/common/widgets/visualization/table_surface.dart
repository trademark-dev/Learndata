import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'table_theme.dart';

class TableSurface extends StatelessWidget {
  final TableVisualTheme theme;
  final double width;
  final double height;
  final Widget child;

  const TableSurface({
    super.key,
    required this.theme,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final Color gradientBase = theme.headerBackground;
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: theme.borderRadius,
          border: Border.all(color: theme.tableBorderColor, width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: theme.borderRadius,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradientBase.withValues(alpha: 0.56),
                        gradientBase.withValues(alpha: 0.28),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        theme.isOutputTable
                            ? Colors.transparent
                            : theme.surfaceOverlayColor,
                  ),
                ),
              ),
              if (!theme.isOutputTable && theme.style.rowBackground == null)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: theme.accentOverlayColor),
                  ),
                ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _DiagonalStripePainter(color: theme.stripeColor),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _DiagonalStripePainter extends CustomPainter {
  final Color color;

  static const double _kThickness = 0.6;
  static const double _kGap = 2.4;
  static const double _kAngle = -math.pi / 3.8;

  const _DiagonalStripePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0 || color.a <= 0) {
      return;
    }

    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = _kThickness;

    final double span = size.width + size.height;
    final double step = _kGap + _kThickness;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(_kAngle);

    for (double y = -span; y <= span; y += step) {
      canvas.drawLine(Offset(-span, y), Offset(span, y), paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DiagonalStripePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

