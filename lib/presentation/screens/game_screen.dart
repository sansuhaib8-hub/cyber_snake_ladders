import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../controllers/game_controller.dart';
import '../widgets/game_board.dart';
import '../widgets/dice_widget.dart';
import '../widgets/player_card.dart';
import '../../core/enums/game_state.dart' as game_enums;

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 7));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showRenameDialog(BuildContext context, int index, String currentName) {
    final textController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D0E15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF00F0FF), width: 1.5),
        ),
        title: const Text(
          'گۆڕینی ناوی یاریزان 📝',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.right,
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'ناوی نوێ...',
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF2A6D))),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00F0FF))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('پاشگەزبوونەوە', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00F0FF)),
            onPressed: () {
              ref.read(gameControllerProvider.notifier).updatePlayerName(index, textController.text);
              Navigator.pop(context);
            },
            child: const Text('تۆمارکردن', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showWinnerOverlay(String winnerName, Color winnerColor) {
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.85),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: true,
                  colors: const [Colors.cyan, Colors.pink, Colors.green, Colors.amber, Colors.purple],
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0E15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: winnerColor, width: 2.5),
                    boxShadow: [BoxShadow(color: winnerColor.withValues(alpha: 0.4), blurRadius: 40, spreadRadius: 4)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("👑", style: TextStyle(fontSize: 75)),
                      const SizedBox(height: 12),
                      const Text("سەرکەوتن و شادی!", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Text(winnerName, style: TextStyle(color: winnerColor, fontSize: 34, fontWeight: FontWeight.w800, shadows: [Shadow(color: winnerColor, blurRadius: 15)])),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: winnerColor, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14)),
                        icon: const Icon(Icons.replay, color: Colors.black),
                        label: const Text("دووبارە یاریکردنەوە 🎮", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          _confettiController.stop();
                          ref.read(gameControllerProvider.notifier).resetGame();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final controller = ref.read(gameControllerProvider.notifier);
    final activePlayer = state.players[state.currentPlayerIndex];

    if (state.gameState == game_enums.GameState.finished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWinnerOverlay(activePlayer.name, activePlayer.color);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFF040508),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0E15),
        title: const Text('مار و پەیژەی نوێ', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
        centerTitle: true,
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
                border: Border.all(color: activePlayer.color.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                children: [
                  ...List.generate(state.players.length, (index) {
                    final p = state.players[index];
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: PlayerCard(
                          player: p,
                          isCurrent: index == state.currentPlayerIndex,
                          onTap: () => _showRenameDialog(context, index, p.name),
                        ),
                      ),
                    );
                  }),
                  // دوگمەی پڵەس هەمیشە لێرەیە مەگەر یاریزان بگاتە ٤
                  if (state.players.length < 4)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: InkWell(
                        onTap: () => controller.addPlayer(),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 45,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFF161824),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.cyan.withValues(alpha: 0.6), width: 1.5),
                          ),
                          child: const Icon(Icons.add, color: Colors.cyan, size: 26),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: state.gameState == game_enums.GameState.idle ? controller.rollDice : null,
                child: const GameBoard(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(state.message, style: TextStyle(color: activePlayer.color, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            DiceWidget(
              value: state.diceValue,
              isRolling: state.gameState == game_enums.GameState.rolling,
              color: activePlayer.color,
              onTap: state.gameState == game_enums.GameState.idle ? controller.rollDice : null,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
