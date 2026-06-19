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
          color: activePlayer.color.withValues(alpha: 0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: activePlayer.color.withValues(alpha: 0.3),
            blurRadius: 35,
            spreadRadius: 4,
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
                  // Grid background with Neon 3D effects
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                    ),
                    itemCount: 100,
                    itemBuilder: (context, idx) {
                      final cellNum = BoardCalculator.getDisplayCellNumber(idx);
                      // دیاریکردنی شێوازی ڕەنگی خانەکان بۆ دروستکردنی ستایلی شەتڕەنجی سایبەری
                      final isEven = idx % 2 == 0;
                      
                      return Container(
                        margin: const EdgeInsets.all(1.5), // دروستکردنی بۆشایی بچووک بۆ دەرکەوتنی خانەکان وەک 3D
                        decoration: BoxDecoration(
                          color: isEven
                              ? const Color(0xFF0F1123)
                              : const Color(0xFF06070D),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF00F0FF).withValues(alpha: 0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00F0FF).withValues(alpha: 0.05),
                              blurRadius: 4,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "$cellNum",
                            style: TextStyle(
                              fontSize: cellSize * 0.28,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE0E6ED), // ڕەنگی سپی-مرواری گەشاوە
                              shadows: [
                                Shadow(
                                  color: const Color(0xFF00F0FF).withValues(alpha: 0.8),
                                  blurRadius: 8,
                                ),
                              ],
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

                  // Players with glowing 3D tokens
                  ...List.generate(state.players.length, (index) {
                    final player = state.players[index];
                    final coords = BoardCalculator.getCellCoordinates(
                      player.position,
                      cellSize,
                    );

                    // بۆ ئەوەی تۆپەکان ڕێک نەکەون بەسەر یەکدا، کەمێک لایان دەدەین ئەگەر لە هەمان خانەدا بوون
                    double offset = index * 3.0;

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      left: coords.dx + (cellSize * 0.25) - 10 + offset,
                      top: coords.dy + (cellSize * 0.25) - 10 + offset,
                      width: cellSize * 0.55,
                      height: cellSize * 0.55,
                      child: AnimatedScale(
                        scale: index == state.currentPlayerIndex ? 1.25 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                player.color,
                                player.color.withValues(alpha: 0.9),
                                const Color(0xFF000000),
                              ],
                              stops: const [0.0, 0.4, 0.8, 1.0],
                            ),
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: player.color.withValues(alpha: 0.9),
                                blurRadius: 20,
                                spreadRadius: 3,
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
