import 'package:flutter/material.dart';
import 'dart:math' as math;
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

    // دروستکردنی شەپۆلی ڕاستەقینە بۆ جەستەی مارەکە
    final path = Path();
    path.moveTo(fromPos.dx, fromPos.dy);

    final double distance = (toPos - fromPos).distance;
    
    // دروستکردنی دوو خاڵی لادان بۆ دروستکردنی شێوەی S
    final double angle = math.atan2(toPos.dy - fromPos.dy, toPos.dx - fromPos.dx);
    final double perpAngle = angle + (math.pi / 2);
    
    final double waveOffset = distance * 0.25;
    
    // خاڵی کۆنترۆڵی یەکەم
    final p1 = Offset(
      fromPos.dx + (toPos.dx - fromPos.dx) * 0.33 + math.cos(perpAngle) * waveOffset,
      fromPos.dy + (toPos.dy - fromPos.dy) * 0.33 + math.sin(perpAngle) * waveOffset,
    );
    
    // خاڵی کۆنترۆڵی دووەم
    final p2 = Offset(
      fromPos.dx + (toPos.dx - fromPos.dx) * 0.66 - math.cos(perpAngle) * waveOffset,
      fromPos.dy + (toPos.dy - fromPos.dy) * 0.66 - math.sin(perpAngle) * waveOffset,
    );

    path.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, toPos.dx, toPos.dy);

    // ١. کێشانی سێبەری قووڵ (3D Drop Shadow) لەسەر بۆردەکە
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);

    // سێبەرەکە کەمێک دەبەمە لای ڕاست و خوارەوە بۆ ئەوەی ڕیالیستی بێت
    canvas.save();
    canvas.translate(5, 8);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // ٢. کێشانی جەستەی سەرەکی بە شەبەنگی نیۆنی 3D (Neon Tube Effect)
    final snakePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFF2A6D), // فۆشیا نیۆن
          const Color(0xFF9100FF), // مۆری سایبەر
          const Color(0xFFFF2A6D),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromPoints(fromPos, toPos))
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, snakePaint);

    // ٣. هێڵی ناوەکی بۆ دروستکردنی قەباری 3D (Specular Highlight)
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);

    canvas.drawPath(path, highlightPaint);

    // ٤. کێشانی سەری مارەکە (3D Glowing Head)
    final headPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF66AA),
          const Color(0xFFFF2A6D),
          const Color(0xFF550022),
        ],
      ).createShader(Rect.fromCircle(center: fromPos, radius: 14));

    canvas.drawCircle(fromPos, 14, headPaint);

    // ٥. کێشانی چاوەکان بە شێوازی زیندوو
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = const Color(0xFF05050A);
    final glowPaint = Paint()
      ..color = const Color(0xFF00FFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // چاوی چەپ
    Offset leftEye = Offset(fromPos.dx - 5, fromPos.dy - 3);
    canvas.drawCircle(leftEye, 4.5, eyePaint);
    canvas.drawCircle(Offset(leftEye.dx - 1, leftEye.dy), 2.2, pupilPaint); // گلێنە
    canvas.drawCircle(leftEye, 5, glowPaint); // بریقەی نیۆنی دەوری چاو

    // چاوی ڕاست
    Offset rightEye = Offset(fromPos.dx + 5, fromPos.dy - 3);
    canvas.drawCircle(rightEye, 4.5, eyePaint);
    canvas.drawCircle(Offset(rightEye.dx + 1, rightEye.dy), 2.2, pupilPaint); // گلێنە
    canvas.drawCircle(rightEye, 5, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
