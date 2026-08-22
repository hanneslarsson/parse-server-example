import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A small nautical accent: a single subtle wave line, used sparingly as a
/// section divider instead of a plain [Divider].
class WaveDivider extends StatelessWidget {
  final double height;
  final Color color;

  const WaveDivider({
    super.key,
    this.height = 14,
    this.color = AppColors.seafoam,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _WavePainter(color: color),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;

  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final waveWidth = 28.0;
    final midY = size.height / 2;
    path.moveTo(0, midY);
    var x = 0.0;
    var up = true;
    while (x < size.width) {
      final nextX = x + waveWidth;
      path.quadraticBezierTo(
        x + waveWidth / 2,
        up ? 0 : size.height,
        nextX,
        midY,
      );
      x = nextX;
      up = !up;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.color != color;
}
