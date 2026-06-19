import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../controllers/game_controller.dart';
import '../../core/constants/game_constants.dart';
import '../painters/snake_painter.dart';
import '../painters/ladder_painter.dart';

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
              color: const Color(0xFF0F111A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 1.5),
            ),
            child: Stack(
              children: [
                // ١. تۆڕی خانەکانی بۆردەکە (Grid)
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 100,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                  itemBuilder: (context, index) {
                    // فۆرمولەی ڕاست بۆ هاوتاکردنی خانەکان لەگەڵ پەینتەرەکان
                    int row = index ~/ 10;
                    int col = index % 10;
                    
                    int actualRow = 9 - row;
                    int actualCol = (actualRow % 2 == 1) ? (9 - col) : col;
                    int cellNumber = actualRow * 10 + actualCol + 1;

                    return Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: (actualRow + actualCol) % 2 == 0
                            ? Colors.white.withOpacity(0.02)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '$cellNumber',
                          style: const TextStyle(color: Colors.white24, fontSize: 10),
                        ),
                      ),
                    );
                  },
                ),

                // ٢. پەیژە ڕەسەنەکانت
                CustomPaint(
                  size: Size(boardSize, boardSize),
                  painter: LadderPainter(ladders: GameConstants.ladders, cellSize: cellSize),
                ),

                // ٣. مارە ڕەسەنەکانت
                CustomPaint(
                  size: Size(boardSize, boardSize),
                  painter: SnakePainter(snakes: GameConstants.snakes, cellSize: cellSize),
                ),

                // ٤. مۆرەی یاریزانەکان (Tokens)
                ...state.players.asMap().entries.map((entry) {
                  final index = entry.key;
                  final player = entry.value;
                  if (player.position == 0) return const SizedBox.shrink();
                  final pos = _getCellCenterOffset(player.position, cellSize);

                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    left: pos.dx - (cellSize * 0.25) + (index * 2),
                    top: pos.dy - (cellSize * 0.25) + (index * 2),
                    child: Container(
                      width: cellSize * 0.5,
                      height: cellSize * 0.5,
                      decoration: BoxDecoration(
                        color: player.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(color: player.color.withOpacity(0.5), blurRadius: 8),
                        ],
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

  static Offset _getCellCenterOffset(int cellNumber, double cellSize) {
    int zeroBased = cellNumber - 1;
    int row = zeroBased ~/ 10;
    int col = zeroBased % 10;
    if (row % 2 == 1) col = 9 - col;
    return Offset((col + 0.5) * cellSize, (9 - row + 0.5) * cellSize);
  }
}
