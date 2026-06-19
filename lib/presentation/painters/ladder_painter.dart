import 'package:flutter/material.dart';
import 'dart:math' as math;

class LadderPainter extends CustomPainter {
  final Map<int, int> ladders;
  final double cellSize;

  LadderPainter({required this.ladders, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    final mainPaint = Paint()
      ..color = const Color(0xFFFFCC00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = const Color(0xFFFFCC00).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    ladders.forEach((start, end) {
      final pStart = _getCenter(start);
      final pEnd = _getCenter(end);

      final angle = math.atan2(pEnd.dy - pStart.dy, pEnd.dx - pStart.dx);
      final offsetLeft = Offset(-math.sin(angle) * 7.5, math.cos(angle) * 7.5);
      final offsetRight = Offset(math.sin(angle) * 7.5, -math.cos(angle) * 7.5);

      // کێشانی سێبەر لەژێر پەیژەکان بۆ قووڵایی 3D
      canvas.drawLine(pStart + offsetLeft, pEnd + offsetLeft, shadowPaint);
      canvas.drawLine(pStart + offsetRight, pEnd + offsetRight, shadowPaint);

      // قاچە ئەسڵییەکانی پەیژەکە
      canvas.drawLine(pStart + offsetLeft, pEnd + offsetLeft, mainPaint);
      canvas.drawLine(pStart + offsetRight, pEnd + offsetRight, mainPaint);

      // پلەکان بە جوانی
      int steps = 6;
      for (int i = 1; i < steps; i++) {
        double t = i / steps;
        Offset p = Offset.lerp(pStart, pEnd, t)!;
        canvas.drawLine(p + offsetLeft, p + offsetRight, mainPaint..strokeWidth = 2.5);
      }
    });
  }

  Offset _getCenter(int cellNumber) {
    int zeroBased = cellNumber - 1;
    int row = zeroBased ~/ 10;
    int col = zeroBased % 10;
    if (row % 2 == 1) col = 9 - col;
    return Offset((col + 0.5) * cellSize, (9 - row + 0.5) * cellSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
