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
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A1018), Color(0xFF050A12)],
              ),
              border: Border.all(
                color: const Color(0xFF00F0FF).withValues(alpha: 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F0FF).withValues(alpha: 0.12),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  RepaintBoundary(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 100,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                      itemBuilder: (context, index) {
                        int row = index ~/ 10;
                        int col = index % 10;
                        int actualRow = 9 - row;
                        int actualCol = (actualRow % 2 == 1) ? (9 - col) : col;
                        int cellNumber = actualRow * 10 + actualCol + 1;

                        final isSnakeHead = GameConstants.snakes.containsKey(cellNumber);
                        final isLadderFoot = GameConstants.ladders.containsKey(cellNumber);
                        final isSpecial = isSnakeHead || isLadderFoot;
                        final isChecker = (actualRow + actualCol) % 2 == 0;

                        return _GlassCell(
                          cellNumber: cellNumber,
                          isChecker: isChecker,
                          isSpecial: isSpecial,
                          specialColor: isSnakeHead
                              ? const Color(0xFFFF2A6D)
                              : isLadderFoot
                                  ? const Color(0xFFFFCC00)
                                  : null,
                        );
                      },
                    ),
                  ),

                  RepaintBoundary(
                    child: CustomPaint(
                      size: Size(boardSize, boardSize),
                      painter: LadderPainter(ladders: GameConstants.ladders, cellSize: cellSize),
                    ),
                  ),
                  RepaintBoundary(
                    child: CustomPaint(
                      size: Size(boardSize, boardSize),
                      painter: SnakePainter(snakes: GameConstants.snakes, cellSize: cellSize),
                    ),
                  ),

                  ...state.players.asMap().entries.map((entry) {
                    final index = entry.key;
                    final player = entry.value;
                    if (player.position == 0) return const SizedBox.shrink();
                    final pos = _getCellCenterOffset(player.position, cellSize);

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutBack,
                      left: pos.dx - (cellSize * 0.27) + (index * 3),
                      top: pos.dy - (cellSize * 0.27) + (index * 3) - (cellSize * 0.12),
                      child: _PlayerToken(player: player, cellSize: cellSize),
                    );
                  }),

                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.05),
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

/// خانەیەکی تاکە بە شێوازی شووشەیی (بێ BackdropFilter بۆ خێرایی باشتر)
class _GlassCell extends StatelessWidget {
  final int cellNumber;
  final bool isChecker;
  final bool isSpecial;
  final Color? specialColor;

  const _GlassCell({
    required this.cellNumber,
    required this.isChecker,
    required this.isSpecial,
    this.specialColor,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = isChecker ? const Color(0xFF112233) : const Color(0xFF0D1A28);

    return Container(
      margin: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseColor.withValues(alpha: 0.9),
            baseColor.withValues(alpha: 0.6),
          ],
        ),
        border: Border.all(
          color: isSpecial
              ? specialColor!.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.06),
          width: isSpecial ? 1.2 : 0.6,
        ),
        boxShadow: isSpecial
            ? [
                BoxShadow(
                  color: specialColor!.withValues(alpha: 0.3),
                  blurRadius: 6,
                  spreadRadius: 0.5,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$cellNumber',
          style: TextStyle(
            color: isSpecial
                ? specialColor!.withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.3),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

/// مۆرەی یاریزان بە شێوازی 3D و گرادیێنت
class _PlayerToken extends StatelessWidget {
  final dynamic player;
  final double cellSize;

  const _PlayerToken({required this.player, required this.cellSize});

  @override
  Widget build(BuildContext context) {
    final size = cellSize * 0.54;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: [
            Color.lerp(player.color, Colors.white, 0.5)!,
            player.color,
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: player.color.withValues(alpha: 0.7),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          player.name.toString().characters.take(1).toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
