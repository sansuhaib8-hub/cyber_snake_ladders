import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../../core/utils/board_calculator.dart';
import '../../core/constants/game_constants.dart';
import '../painters/snake_painter.dart';
import '../painters/ladder_painter.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final activePlayer = state.players[state.currentPlayerIndex];

    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: activePlayer.color.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: activePlayer.color.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final boardSize = Size(constraints.maxWidth, constraints.maxHeight);
              final cellSize = constraints.maxWidth / 10;

              return Stack(
                children: [
                  // Grid background
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                    ),                    itemCount: 100,
                    itemBuilder: (context, idx) {
                      final cellNum = BoardCalculator.getDisplayCellNumber(idx);
                      return Container(
                        decoration: BoxDecoration(
                          color: idx % 2 == 0
                              ? const Color(0xFF121424)
                              : const Color(0xFF090A12),
                          border: Border.all(color: Colors.black45, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            "$cellNum",
                            style: TextStyle(
                              fontSize: cellSize * 0.25,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Draw snakes
                  ...GameConstants.snakes.entries.map((entry) {
                    return CustomPaint(
                      size: boardSize,
                      painter: SnakePainter(
                        fromCell: entry.key,
                        toCell: entry.value,
                        boardSize: boardSize,
                      ),
                    );
                  }),

                  // Draw ladders
                  ...GameConstants.ladders.entries.map((entry) {
                    return CustomPaint(
                      size: boardSize,
                      painter: LadderPainter(
                        fromCell: entry.key,
                        toCell: entry.value,
                        boardSize: boardSize,
                      ),
                    );
                  }),

                  // Players
                  ...List.generate(state.players.length, (index) {
                    final player = state.players[index];                    final coords = BoardCalculator.getCellCoordinates(
                      player.position,
                      cellSize,
                    );

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: coords.dx,
                      top: coords.dy,
                      width: cellSize * 0.5,
                      height: cellSize * 0.5,
                      child: AnimatedScale(
                        scale: index == state.currentPlayerIndex ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                player.color,
                                player.color.withValues(alpha: 0.8),
                              ],
                            ),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: player.color.withValues(alpha: 0.8),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
