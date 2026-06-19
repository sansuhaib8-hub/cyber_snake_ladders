import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class LadderPainter extends CustomPainter {
  final Map<int, int> ladders;
  final double cellSize;

  LadderPainter({required this.ladders, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    ladders.forEach((start, end) {
      final pStart = _getCenter(start);
      final pEnd = _getCenter(end);

      final angle = math.atan2(pEnd.dy - pStart.dy, pEnd.dx - pStart.dx);
      final railOffset = cellSize * 0.16;
      final offsetLeft = Offset(-math.sin(angle) * railOffset, math.cos(angle) * railOffset);
      final offsetRight = Offset(math.sin(angle) * railOffset, -math.cos(angle) * railOffset);

      final leftStart = pStart + offsetLeft;
      final leftEnd = pEnd + offsetLeft;
      final rightStart = pStart + offsetRight;
      final rightEnd = pEnd + offsetRight;

      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.5
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawLine(leftStart + const Offset(2, 3), leftEnd + const Offset(2, 3), shadowPaint);
      canvas.drawLine(rightStart + const Offset(2, 3), rightEnd + const Offset(2, 3), shadowPaint);

      final glowPaint = Paint()
        ..color = const Color(0xFFFFCC00).withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawLine(leftStart, leftEnd, glowPaint);
      canvas.drawLine(rightStart, rightEnd, glowPaint);

      final railGradient = ui.Gradient.linear(
        leftStart,
        rightEnd,
        const [Color(0xFFFFF3B0), Color(0xFFFFCC00), Color(0xFFB8860B)],
        const [0.0, 0.5, 1.0],
      );
      final railPaint = Paint()
        ..shader = railGradient
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(leftStart, leftEnd, railPaint);
      canvas.drawLine(rightStart, rightEnd, railPaint);

      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        leftStart + Offset(-math.sin(angle) * 1.0, math.cos(angle) * 1.0),
        leftEnd + Offset(-math.sin(angle) * 1.0, math.cos(angle) * 1.0),
        highlightPaint,
      );
      canvas.drawLine(
        rightStart + Offset(-math.sin(angle) * 1.0, math.cos(angle) * 1.0),
        rightEnd + Offset(-math.sin(angle) * 1.0, math.cos(angle) * 1.0),
        highlightPaint,
      );

      final totalDistance = (pEnd - pStart).distance;
      final stepCount = math.max(4, (totalDistance / (cellSize * 0.85)).round());

      for (int i = 1; i < stepCount; i++) {
        double t = i / stepCount;
        Offset centerPoint = Offset.lerp(pStart, pEnd, t)!;
        Offset stepLeft = centerPoint + offsetLeft;
        Offset stepRight = centerPoint + offsetRight;

        canvas.drawLine(
          stepLeft + const Offset(0, 1.8),
          stepRight + const Offset(0, 1.8),
          Paint()
            ..color = Colors.black.withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.2
            ..strokeCap = StrokeCap.round,
        );

        final stepGradient = ui.Gradient.linear(
          stepLeft,
          stepRight,
          const [Color(0xFFFFE066), Color(0xFFFFCC00)],
        );
        canvas.drawLine(
          stepLeft,
          stepRight,
          Paint()
            ..shader = stepGradient
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0
            ..strokeCap = StrokeCap.round,
        );

        canvas.drawLine(
          stepLeft + const Offset(0, -0.6),
          stepRight + const Offset(0, -0.6),
          Paint()
            ..color = Colors.white.withValues(alpha: 0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
            ..strokeCap = StrokeCap.round,
        );
      }

      for (final endPoint in [pStart, pEnd]) {
        for (final railPoint in [endPoint + offsetLeft, endPoint + offsetRight]) {
          canvas.drawCircle(railPoint, 2.2, Paint()..color = const Color(0xFF8B6500));
          canvas.drawCircle(railPoint, 1.1, Paint()..color = const Color(0xFFFFF3B0));
        }
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
