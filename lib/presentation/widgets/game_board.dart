import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../controllers/game_controller.dart';
import '../../core/constants/game_constants.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = math.min(constraints.maxWidth, constraints.maxHeight) - 16;
        final cellSize = boardSize / 10;

        return Center(
          child: Container(
            width: boardSize,
            height: boardSize,
            decoration: BoxDecoration(
              color: const Color(0xFF080A16),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.cyan.withValues(alpha: 0.3), width: 2),
              boxShadow: [
                BoxShadow(color: Colors.cyan.withValues(alpha: 0.1), blurRadius: 20, spreadRadius: 2),
              ],
            ),
            child: Stack(
              children: [
                // ١. تۆڕی خانە شوشەییە 3D یەکان
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 100,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                  itemBuilder: (context, index) {
                    int row = index ~/ 10;
                    int col = index % 10;
                    
                    int actualRow = 9 - row;
                    int actualCol = (actualRow % 2 == 1) ? (9 - col) : col;
                    int cellNumber = actualRow * 10 + actualCol + 1;

                    bool isEven = (actualRow + actualCol) % 2 == 0;

                    return Container(
                      margin: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        // دیزاینی شوشەیی نیمچە ڕووناک
                        color: isEven ? Colors.white.withValues(alpha: 0.04) : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.4), offset: const Offset(1, 1), blurRadius: 1),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$cellNumber',
                          style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),

                // ٢. کێشانی مار و پەیژە ئەکشنەکان بەپێی پۆزیشنی ڕاستەقینە
                CustomPaint(
                  size: Size(boardSize, boardSize),
                  painter: BoardElementsPainter(cellSize: cellSize),
                ),

                // ٣. پیشاندانی مۆرەی یاریزانەکان لەسەر بۆردەکە
                ...state.players.asMap().entries.map((entry) {
                  final index = entry.key;
                  final player = entry.value;
                  if (player.position == 0) return const SizedBox.shrink();

                  final pos = _getCellOffset(player.position, cellSize, boardSize);
                  
                  // لادانی جیاواز بۆ مۆرەکان ئەگەر لە هەمان خانە بوون
                  double offsetMultiplier = (index - 1) * 6.0;

                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: pos.dx + 4 + offsetMultiplier,
                    top: pos.dy + 4 + offsetMultiplier,
                    child: Container(
                      width: cellSize - 12,
                      height: cellSize - 12,
                      decoration: BoxDecoration(
                        color: player.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: player.color, blurRadius: 10, spreadRadius: 1),
                          BoxShadow(color: Colors.black.withValues(alpha: 0.5), offset: const Offset(2, 2), blurRadius: 4),
                        ],
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Center(
                        child: Text(
                          player.name.characters.take(1).toString(),
                          style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  static Offset _getCellOffset(int cellNumber, double cellSize, double boardSize) {
    int zeroBased = cellNumber - 1;
    int row = zeroBased ~/ 10;
    int col = zeroBased % 10;
    if (row % 2 == 1) col = 9 - col;
    return Offset(col * cellSize, (9 - row) * cellSize);
  }
}

class BoardElementsPainter extends CustomPainter {
  final double cellSize;
  BoardElementsPainter({required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    // کێشانی پەیژە مۆدێرنەکان
    final ladderPaint = Paint()
      ..color = const Color(0xFFFFCC00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    GameConstants.ladders.forEach((start, end) {
      final startOffset = _getCenter(start, size.width);
      final endOffset = _getCenter(end, size.width);

      // کێشانی قاچە لایەکان
      canvas.drawLine(startOffset + const Offset(-6, 0), endOffset + const Offset(-6, 0), ladderPaint);
      canvas.drawLine(startOffset + const Offset(6, 0), endOffset + const Offset(6, 0), ladderPaint);

      // پلەکان
      int steps = 5;
      for (int i = 1; i < steps; i++) {
        double t = i / steps;
        Offset p = Offset.lerp(startOffset, endOffset, t)!;
        canvas.drawLine(p + const Offset(-9, 0), p + const Offset(9, 0), ladderPaint..strokeWidth = 2);
      }
    });

    // کێشانی ماری ڕاستەقینە بە لاری و زیکزاکی جوانی نیۆن
    GameConstants.snakes.forEach((start, end) {
      final startOffset = _getCenter(start, size.width); // سەر
      final endOffset = _getCenter(end, size.width); // کلک

      final snakePaint = Paint()
        ..color = const Color(0xFFFF2A6D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(startOffset.dx, startOffset.dy);

      // دروستکردنی لاری زیکزاک و شەپۆلی سروشتی بۆ مارەکە
      Offset mid1 = Offset.lerp(startOffset, endOffset, 0.3)!;
      Offset mid2 = Offset.lerp(startOffset, endOffset, 0.7)!;
      
      path.cubicTo(
        mid1.dx + 25, mid1.dy - 10,
        mid2.dx - 25, mid2.dy + 10,
        endOffset.dx, endOffset.dy,
      );

      // کێشانی تیشکی نیۆنی مارەکە
      canvas.drawPath(path, snakePaint..color = const Color(0xFFFF2A6D).withValues(alpha: 0.3)..strokeWidth = 10);
      canvas.drawPath(path, snakePaint..color = const Color(0xFFFF2A6D)..strokeWidth = 4.5);

      // سەر و چاوی مارەکە (ماری واقیعی)
      final headPaint = Paint()..color = const Color(0xFFFF2A6D)..style = PaintingStyle.fill;
      canvas.drawCircle(startOffset, 6, headPaint);
      canvas.drawCircle(startOffset + const Offset(-2, -2), 1.5, Paint()..color = Colors.white);
      canvas.drawCircle(startOffset + const Offset(2, -2), 1.5, Paint()..color = Colors.white);
    });
  }

  Offset _getCenter(int cellNumber, double boardSize) {
    int zeroBased = cellNumber - 1;
    int row = zeroBased ~/ 10;
    int col = zeroBased % 10;
    if (row % 2 == 1) col = 9 - col;
    return Offset((col + 0.5) * cellSize, (9 - row + 0.5) * cellSize);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
