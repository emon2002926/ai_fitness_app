import 'package:flutter/material.dart';
class LineDivider extends StatelessWidget {
  final Color lineColor;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const LineDivider({
    super.key,
    this.lineColor = const Color(0xFFE8E5DF),
    this.dashWidth = 4,
    this.dashSpace = 4,
    this.strokeWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashedLinePainter(
        color: lineColor,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  const _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final double y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
          oldDelegate.dashWidth != dashWidth ||
          oldDelegate.dashSpace != dashSpace ||
          oldDelegate.strokeWidth != strokeWidth;
}