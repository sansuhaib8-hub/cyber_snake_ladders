import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/game_controller.dart';
import '../widgets/game_board.dart';
import '../widgets/dice_widget.dart';
import '../widgets/player_card.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final activePlayer = state.players[state.currentPlayerIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF040508),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0E15),
        title: const Text(
          'مار و پەیژە',
          style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.amber),
            onPressed: () => _showResetDialog(context, controller),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0E15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: activePlayer.color.withValues(alpha: 0.3),
                  width: 1,
                ),              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(state.players.length, (index) {
                  return PlayerCard(
                    player: state.players[index],
                    isCurrent: index == state.currentPlayerIndex,
                    onTap: () {},
                  );
                }),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: state.gameState.name == 'idle' ? controller.rollDice : null,
                child: const GameBoard(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                state.message,
                style: TextStyle(
                  color: activePlayer.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            DiceWidget(
              value: state.diceValue,
              isRolling: state.gameState.name == 'rolling',
              color: activePlayer.color,
              onTap: state.gameState.name == 'idle' ? controller.rollDice : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, GameController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF11121C),
        title: const Text(
          'دەستپێکردنەوە؟',
          style: TextStyle(color: Colors.white),        ),
        content: const Text(
          'ئایا دڵنیایت دەتەوێت یاریەکە دەستپێ بکەیتەوە؟',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('نەخێر', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.resetGame();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('بەڵێ'),
          ),
        ],
      ),
    );
  }
}
