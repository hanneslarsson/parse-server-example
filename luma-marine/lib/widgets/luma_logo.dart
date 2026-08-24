import 'package:flutter/material.dart';

/// The Luma Marine monogram mark: an "LM" formed from a single continuous
/// weight of stroke — an L (vertical spine + foot) beside an M (two peaks),
/// redrawn in the spirit of the brand's merchandise mark. Monoline, no
/// fill, so it reads equally well in navy-on-white or white-on-navy.
class LumaMark extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidthFactor;

  const LumaMark({
    super.key,
    this.size = 28,
    required this.color,
    this.strokeWidthFactor = 0.09,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LumaMarkPainter(color: color, strokeWidthFactor: strokeWidthFactor),
      ),
    );
  }
}

class _LumaMarkPainter extends CustomPainter {
  final Color color;
  final double strokeWidthFactor;

  _LumaMarkPainter({required this.color, required this.strokeWidthFactor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * strokeWidthFactor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Offset p(double x, double y) => Offset(x * size.width, y * size.height);

    final lPath = Path()
      ..moveTo(p(0.08, 0.12).dx, p(0.08, 0.12).dy)
      ..lineTo(p(0.08, 0.88).dx, p(0.08, 0.88).dy)
      ..lineTo(p(0.32, 0.88).dx, p(0.32, 0.88).dy);

    final mPath = Path()
      ..moveTo(p(0.42, 0.88).dx, p(0.42, 0.88).dy)
      ..lineTo(p(0.565, 0.16).dx, p(0.565, 0.16).dy)
      ..lineTo(p(0.685, 0.58).dx, p(0.685, 0.58).dy)
      ..lineTo(p(0.805, 0.16).dx, p(0.805, 0.16).dy)
      ..lineTo(p(0.93, 0.88).dx, p(0.93, 0.88).dy);

    canvas.drawPath(lPath, paint);
    canvas.drawPath(mPath, paint);
  }

  @override
  bool shouldRepaint(covariant _LumaMarkPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidthFactor != strokeWidthFactor;
}

/// The "LUMA / — MARINE —" wordmark lockup beneath the mark, matching the
/// bold letter-spaced treatment on the merchandise.
class LumaWordmark extends StatelessWidget {
  final Color color;
  final double fontSize;
  final TextAlign align;

  const LumaWordmark({
    super.key,
    required this.color,
    this.fontSize = 20,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          align == TextAlign.center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'LUMA',
          style: TextStyle(
            fontFamily: 'InterDisplay',
            fontWeight: FontWeight.w800,
            fontSize: fontSize,
            letterSpacing: fontSize * 0.14,
            height: 1,
            color: color,
          ),
        ),
        SizedBox(height: fontSize * 0.16),
        Text(
          '— MARINE —',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: fontSize * 0.32,
            letterSpacing: fontSize * 0.08,
            height: 1,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Mark + wordmark side by side, for nav bars and headers.
class LumaLogoLockup extends StatelessWidget {
  final Color color;
  final double markSize;

  const LumaLogoLockup({super.key, required this.color, this.markSize = 30});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LumaMark(size: markSize, color: color),
        SizedBox(width: markSize * 0.32),
        LumaWordmark(color: color, fontSize: markSize * 0.62),
      ],
    );
  }
}
