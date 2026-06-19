import 'package:flutter/material.dart';
import '../../core/utils/board_calculator.dart';

class SnakePainter extends CustomPainter {
  final int fromCell;
  final int toCell;
  final Size boardSize;

  SnakePainter({
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
      ..color = Colors.black.withValues(alpha: 0.5)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Snake body gradient
    final snakePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFF3366),
          const Color(0xFFFF6644),
          const Color(0xFFFF3366),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromPoints(fromPos, toPos))
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw curved snake - دروستکردنی path
    final path = Path();
    path.moveTo(fromPos.dx, fromPos.dy);

    final midX = (fromPos.dx + toPos.dx) / 2;
    final midY = (fromPos.dy + toPos.dy) / 2;
    final offset = 30.0;

    path.quadraticBezierTo(
      midX + offset,
      midY - offset,
      toPos.dx,
      toPos.dy,
    );

    // Shadow
    canvas.drawPath(path, shadowPaint);

    // Snake body
    canvas.drawPath(path, snakePaint);

    // Snake head (circle)
    final headPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF6666),
          const Color(0xFFFF3366),
          const Color(0xFFCC0033),
        ],
      ).createShader(
        Rect.fromCircle(center: fromPos, radius: 12),
      );

    canvas.drawCircle(fromPos, 12, headPaint);

    // Eyes
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(fromPos.dx - 4, fromPos.dy - 3),
      3,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(fromPos.dx + 4, fromPos.dy - 3),
      3,
      eyePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
