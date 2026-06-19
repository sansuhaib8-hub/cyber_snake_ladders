import 'package:flutter/material.dart';
import 'dart:math' as math;
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

    // ١. بیرکاری ورد بۆ دیاریکردنی دووری هاوتەریبی نێوان دوو هێڵەکە
    final double dx = toPos.dx - fromPos.dx;
    final double dy = toPos.dy - fromPos.dy;
    final double distance = math.sqrt(dx * dx + dy * dy);
    if (distance == 0) return;

    // دیاریکردنی هێڵی ستوونی (Perpendicular Vector) بۆ لادانی ڕێڕەوەکان
    final double perpX = -dy / distance * 10; // بۆشایی نێوان ڕێڕەوەکان بە ١٠ پیکسڵ
    final double perpY = dx / distance * 10;

    final rail1Start = Offset(fromPos.dx + perpX, fromPos.dy + perpY);
    final rail1End = Offset(toPos.dx + perpX, toPos.dy + perpY);
    final rail2Start = Offset(fromPos.dx - perpX, fromPos.dy - perpY);
    final rail2End = Offset(toPos.dx - perpX, toPos.dy - perpY);

    // ٢. کێشانی سێبەری قووڵی ڕێڕەوەکان (Drop Shadow)
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.save();
    canvas.translate(4, 6); // گواستنەوەی سێبەرەکە بۆ خوارەوەی ڕاست
    canvas.drawLine(rail1Start, rail1End, shadowPaint);
    canvas.drawLine(rail2Start, rail2End, shadowPaint);
    canvas.restore();

    // ٣. کێشانی ڕێڕەوە سەرەکییەکان بە شەبەنگی زێڕینی سایبەری (Cyber Gold Gradient)
    final railPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFD700), // زێڕینی گەش
          const Color(0xFFFF8C00), // پرتەقاڵی تاریک
          const Color(0xFFFFD700),
        ],
      ).createShader(Rect.fromPoints(fromPos, toPos))
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(rail1Start, rail1End, railPaint);
    canvas.drawLine(rail2Start, rail2End, railPaint);

    // ٤. کێشانی قادرمەکان (Steps/Rungs) بە شێوازی درەوشاوە
    final double stepDistance = 25.0; // بۆشایی جێگیر لە نێوان هەر پێپەژەیەک
    final int numSteps = (distance / stepDistance).floor();

    final stepPaint = Paint()
      ..color = const Color(0xFFFFE57F) // زێڕینی ڕووناک
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final stepGlowPaint = Paint()
      ..color = const Color(0xFFFFAA00).withValues(alpha: 0.5)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final stepShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    for (int i = 1; i <= numSteps; i++) {
      final double t = i / (numSteps + 1);
      
      final currentRail1 = Offset(
        rail1Start.dx + (rail1End.dx - rail1Start.dx) * t,
        rail1Start.dy + (rail1End.dy - rail1Start.dy) * t,
      );
      final currentRail2 = Offset(
        rail2Start.dx + (rail2End.dx - rail2Start.dx) * t,
        rail2Start.dy + (rail2End.dy - rail2Start.dy) * t,
      );

      // کێشانی سێبەری هەر قادرمەیەک لەژێریدا
      canvas.save();
      canvas.translate(4, 5);
      canvas.drawLine(currentRail1, currentRail2, stepShadowPaint);
      canvas.restore();

      // کێشانی بریقەی دەوری قادرمەکە
      canvas.drawLine(currentRail1, currentRail2, stepGlowPaint);
      // کێشانی قادرمە سەرەکییەکە
      canvas.drawLine(currentRail1, currentRail2, stepPaint);
    }

    // ٥. هێڵی ڕووناکی تەنک لەسەر ڕێڕەوەکان (3D Specular Highlight)
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(rail1Start, rail1End, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
