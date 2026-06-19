import 'package:flutter/material.dart';
import '../../core/utils/board_calculator.dart';

class LadderPainter extends CustomPainter {
  final int fromCell;
  final int toCell;
  final Size boardSize;

  LadderPainter({
    required this.fromCell,
    required this.toCell,
    required this.boardSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fromPos = BoardCalculator.getCellCenter(fromCell, size);
    final toPos = BoardCalculator.getCellCenter(toCell, size);

    // 3D shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // Ladder rails (two parallel lines)
    final railPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFCC00),
          const Color(0xFFFF9900),
          const Color(0xFFFFCC00),
        ],
      ).createShader(Rect.fromPoints(fromPos, toPos))
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Calculate perpendicular offset for two rails
    final dx = toPos.dx - fromPos.dx;
    final dy = toPos.dy - fromPos.dy;
    final length = (dx * dx + dy * dy);
    final perpX = -dy / length * 15;
    final perpY = dx / length * 15;

    final rail1Start = Offset(fromPos.dx + perpX, fromPos.dy + perpY);
    final rail1End = Offset(toPos.dx + perpX, toPos.dy + perpY);
    final rail2Start = Offset(fromPos.dx - perpX, fromPos.dy - perpY);
    final rail2End = Offset(toPos.dx - perpX, toPos.dy - perpY);

    // Draw shadow
    canvas.drawLine(rail1Start, rail1End, shadowPaint);
    canvas.drawLine(rail2Start, rail2End, shadowPaint);

    // Draw rails
    canvas.drawLine(rail1Start, rail1End, railPaint);
    canvas.drawLine(rail2Start, rail2End, railPaint);

    // Draw steps (rungs)
    final numSteps = 5;
    final stepPaint = Paint()
      ..color = const Color(0xFFFFEE88)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    for (int i = 1; i <= numSteps; i++) {
      final t = i / (numSteps + 1);
      final stepStart = Offset(
        rail1Start.dx + (rail1End.dx - rail1Start.dx) * t,
        rail1Start.dy + (rail1End.dy - rail1Start.dy) * t,
      );
      final stepEnd = Offset(
        rail2Start.dx + (rail2End.dx - rail2Start.dx) * t,
        rail2Start.dy + (rail2End.dy - rail2Start.dy) * t,
      );
      canvas.drawLine(stepStart, stepEnd, stepPaint);
    }

    // 3D highlight on top
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(rail1Start.dx, rail1Start.dy - 2),
      Offset(rail1End.dx, rail1End.dy - 2),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
