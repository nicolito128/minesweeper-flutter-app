import 'package:flutter/material.dart';

class CornerBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;

  CornerBorderPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.cornerLength = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final double w = size.width;
    final double h = size.height;
    final double len = cornerLength;

    // Top-Left
    final pathTL = Path()
      ..moveTo(0, len)
      ..lineTo(0, 0)
      ..lineTo(len, 0);

    // Top-Right
    final pathTR = Path()
      ..moveTo(w - len, 0)
      ..lineTo(w, 0)
      ..lineTo(w, len);

    // Bottom-Left
    final pathBL = Path()
      ..moveTo(0, h - len)
      ..lineTo(0, h)
      ..lineTo(len, h);

    // Bottom-Right
    final pathBR = Path()
      ..moveTo(w - len, h)
      ..lineTo(w, h)
      ..lineTo(w, h - len);

    canvas.drawPath(pathTL, paint);
    canvas.drawPath(pathTR, paint);
    canvas.drawPath(pathBL, paint);
    canvas.drawPath(pathBR, paint);
  }

  @override
  bool shouldRepaint(covariant CornerBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerLength != cornerLength;
  }
}
