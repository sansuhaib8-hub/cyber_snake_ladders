import 'package:flutter/material.dart';
import 'dart:math' as math;

class SnakePainter extends CustomPainter {
  final Map<int, int> snakes;
  final double cellSize;

  SnakePainter({required this.snakes, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    snakes.forEach((start, end) {
      final pStart = _getCenter(start); // سەر
      final pEnd = _getCenter(end); // کلک

      final points = <Offset>[];
      int segmentCount = 30;

      // دروستکردنی جەستەی کێرڤی واقیعی شەپۆلدار
      for (int i = 0; i <= segmentCount; i++) {
        double t = i / segmentCount;
        Offset linearPoint = Offset.lerp(pStart, pEnd, t)!;
        
        // دروستکردنی شەپۆل بەپێی درێژی بۆ ئەوەی واقیعی بێت
        double wave = math.sin(t * math.pi * 2.5) * (cellSize * 0.35);
        final angle = math.atan2(pEnd.dy - pStart.dy, pEnd.dx - pStart.dx) + (math.pi / 2);
        
        points.add(linearPoint + Offset(math.cos(angle) * wave, math.sin(angle) * wave));
      }

      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      // ١. تیشکی نیۆنی دەوروبەری مارەکە (Neon Glow)
      canvas.drawPath(path, Paint()
        ..color = const Color(0xFFFF2A6D).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16.0
        ..strokeCap = StrokeCap.round);

      // ٢. جەستەی ئەسڵی مارەکە (Cyber Body)
      canvas.drawPath(path, Paint()
        ..color = const Color(0xFFFF2A6D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round);

      // ٣. تیشکی ناوەکی گەشاوە (Core Glow)
      canvas.drawPath(path, Paint()
        ..color = const Color(0xFF00F0FF).withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2);

      // 👁️ دروستکردنی سەری ماری واقیعی لە خانەی سەرەتا
      canvas.drawCircle(pStart, 8.0, Paint()..color = const Color(0xFFFF2A6D));
      
      // چاوە نیۆنییە درەوشاوەکان
      canvas.drawCircle(pStart + const Offset(-2.5, -2), 1.8, Paint()..color = Colors.white);
      canvas.drawCircle(pStart + const Offset(2.5, -2), 1.8, Paint()..color = Colors.white);
      canvas.drawCircle(pStart + const Offset(-2.5, -2), 0.8, Paint()..color = Colors.black);
      canvas.drawCircle(pStart + const Offset(2.5, -2), 0.8, Paint()..color = Colors.black);
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
