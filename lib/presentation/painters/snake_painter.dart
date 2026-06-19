import 'package:flutter/material.dart';
import 'dart:math' as math;

class SnakePainter extends CustomPainter {
  final Map<int, int> snakes;
  final double cellSize;

  SnakePainter({required this.snakes, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    snakes.forEach((start, end) {
      final pStart = _getCenter(start);
      final pEnd = _getCenter(end);

      final points = <Offset>[];
      const int segmentCount = 40;
      final double totalLength = (pEnd - pStart).distance;
      final double waveFrequency = math.max(1.5, totalLength / (cellSize * 1.8));

      for (int i = 0; i <= segmentCount; i++) {
        double t = i / segmentCount;
        Offset linearPoint = Offset.lerp(pStart, pEnd, t)!;
        double taper = math.sin(t * math.pi);
        double wave = math.sin(t * math.pi * 2 * waveFrequency) *
            (cellSize * 0.32) *
            (0.4 + taper * 0.6);
        final angle =
            math.atan2(pEnd.dy - pStart.dy, pEnd.dx - pStart.dx) + (math.pi / 2);

        points.add(
          linearPoint + Offset(math.cos(angle) * wave, math.sin(angle) * wave),
        );
      }

      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final mid = Offset.lerp(p0, p1, 0.5)!;
        path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
      }
      path.lineTo(points.last.dx, points.last.dy);

      double widthAt(double t) => 11.0 - (t * 4.5);

      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF7A0030).withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20.0
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );

      final shadowPath = Path.from(path)..shift(const Offset(1.5, 2.5));
      canvas.drawPath(
        shadowPath,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9.0
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      _drawGradientSegments(canvas, points, widthAt);
      _drawScales(canvas, points);

      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.22)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round,
      );

      _drawHead(canvas, pStart, pEnd);
    });
  }

  void _drawGradientSegments(
    Canvas canvas,
    List<Offset> points,
    double Function(double) widthAt,
  ) {
    for (int i = 0; i < points.length - 1; i++) {
      final t = i / (points.length - 1);
      final p0 = points[i];
      final p1 = points[i + 1];

      final baseColor = Color.lerp(
        const Color(0xFF8B0024),
        const Color(0xFFE8294F),
        0.5 + 0.5 * math.sin(t * math.pi * 6).abs(),
      )!;

      final paint = Paint()
        ..color = baseColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = widthAt(t)
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(p0, p1, paint);
    }

    for (int i = 0; i < points.length - 1; i++) {
      final t = i / (points.length - 1);
      final p0 = points[i];
      final p1 = points[i + 1];
      final paint = Paint()
        ..color = const Color(0xFFFF6B8A).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = widthAt(t) * 0.35
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        p0 + const Offset(0, -1.2),
        p1 + const Offset(0, -1.2),
        paint,
      );
    }
  }

  void _drawScales(Canvas canvas, List<Offset> points) {
    final scalePaint = Paint()
      ..color = const Color(0xFF3D0014).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 2; i < points.length - 2; i += 2) {
      final p = points[i];
      final next = points[i + 1];
      final angle = math.atan2(next.dy - p.dy, next.dx - p.dx);
      final t = i / points.length;
      final scaleWidth = (11.0 - (t * 4.5)) * 0.7;

      final arcRect = Rect.fromCenter(center: p, width: scaleWidth * 1.1, height: scaleWidth * 0.9);
      canvas.drawArc(arcRect, angle, math.pi, false, scalePaint);
    }
  }

  void _drawHead(Canvas canvas, Offset pStart, Offset pEnd) {
    final headAngle = math.atan2(pStart.dy - pEnd.dy, pStart.dx - pEnd.dx);

    canvas.drawCircle(
      pStart + const Offset(1, 1.5),
      9.5,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    final headPath = Path()
      ..addOval(Rect.fromCenter(center: pStart, width: 19, height: 15));

    canvas.save();
    canvas.translate(pStart.dx, pStart.dy);
    canvas.rotate(headAngle);
    canvas.translate(-pStart.dx, -pStart.dy);

    canvas.drawPath(
      headPath,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFFE8294F), Color(0xFF7A0030)],
          center: Alignment.topLeft,
        ).createShader(Rect.fromCenter(center: pStart, width: 19, height: 15)),
    );
    canvas.drawPath(
      headPath,
      Paint()
        ..color = const Color(0xFF3D0014)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    canvas.restore();

    final tongueBase = pStart + Offset(math.cos(headAngle), math.sin(headAngle)) * 9;
    final tongueTip = pStart + Offset(math.cos(headAngle), math.sin(headAngle)) * 16;
    final forkAngle1 = headAngle + 0.35;
    final forkAngle2 = headAngle - 0.35;
    final fork1 = tongueTip + Offset(math.cos(forkAngle1), math.sin(forkAngle1)) * 4;
    final fork2 = tongueTip + Offset(math.cos(forkAngle2), math.sin(forkAngle2)) * 4;

    final tonguePaint = Paint()
      ..color = const Color(0xFFFF3366)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(tongueBase, tongueTip, tonguePaint);
    canvas.drawLine(tongueTip, fork1, tonguePaint);
    canvas.drawLine(tongueTip, fork2, tonguePaint);

    final eyeOffset1 = Offset(math.cos(headAngle + 1.0), math.sin(headAngle + 1.0)) * 5;
    final eyeOffset2 = Offset(math.cos(headAngle - 1.0), math.sin(headAngle - 1.0)) * 5;

    for (final eyeCenter in [pStart + eyeOffset1, pStart + eyeOffset2]) {
      canvas.drawCircle(
        eyeCenter,
        2.6,
        Paint()
          ..color = const Color(0xFF00F0FF)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
      canvas.drawCircle(eyeCenter, 2.2, Paint()..color = const Color(0xFFCCFFFF));
      canvas.drawCircle(eyeCenter, 1.0, Paint()..color = Colors.black);
    }
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
