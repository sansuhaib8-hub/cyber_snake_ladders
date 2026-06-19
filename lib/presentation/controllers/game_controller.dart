import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../core/constants/game_constants.dart';
import '../../core/enums/game_state.dart';
import '../../domain/usecases/roll_dice_usecase.dart';
import '../../domain/usecases/check_winner_usecase.dart';

class GameController extends StateNotifier<GameControllerState> {
  final RollDiceUseCase _rollDiceUseCase;
  final CheckWinnerUseCase _checkWinnerUseCase;

  GameController()
      : _rollDiceUseCase = RollDiceUseCase(),
        _checkWinnerUseCase = CheckWinnerUseCase(),
        super(GameControllerState.initial());

  // دوگمەی پڵەس هەمیشە ڕێگا دەدات یاریزان زیاد بکرێت ئەگەر لە ٤ کەمتر بێت
  void addPlayer() {
    if (state.players.length >= 4) return;

    final nextIndex = state.players.length;
    final allPossiblePlayers = [
      Player(id: '1', name: "یاریزان ١", color: const Color(0xFF00FFFF)),
      Player(id: '2', name: "یاریزان ٢", color: const Color(0xFFFF00FF)),
      Player(id: '3', name: "یاریزان ٣", color: const Color(0xFF00FF66)),
      Player(id: '4', name: "یاریزان ٤", color: const Color(0xFFFFCC00)),
    ];

    if (nextIndex < allPossiblePlayers.length) {
      final newPlayer = allPossiblePlayers[nextIndex];
      state = state.copyWith(
        players: [...state.players, newPlayer],
        message: "👤 [ ${newPlayer.name} ] هاتە ناو یارییەکەوە! 🎮",
      );
    }
  }

  void rollDice() {
    if (state.gameState != GameState.idle) return;
    state = state.copyWith(gameState: GameState.rolling);

    Future.delayed(const Duration(milliseconds: GameConstants.diceRollDuration), () {
      final diceValue = _rollDiceUseCase.execute();
      state = state.copyWith(diceValue: diceValue);
      _movePlayer(diceValue);
    });
  }

  void _movePlayer(int steps) async {
    final currentPlayer = state.players[state.currentPlayerIndex];
    final targetPosition = currentPlayer.position + steps;

    if (targetPosition > 100) {
      state = state.copyWith(
        message: "⚠️ ژمارەی دەقیقی دەوێت!",
        gameState: GameState.idle,
      );
      await Future.delayed(const Duration(milliseconds: 1500));
      _nextTurn();
      return;
    }

    state = state.copyWith(gameState: GameState.moving);

    for (int i = currentPlayer.position + 1; i <= targetPosition; i++) {
      await Future.delayed(const Duration(milliseconds: GameConstants.moveDuration));
      _updatePlayerPosition(state.currentPlayerIndex, i);
    }
    
    await _checkSnakesAndLadders();

    final updatedPlayer = state.players[state.currentPlayerIndex];
    if (_checkWinnerUseCase.execute(updatedPlayer.position)) {
      state = state.copyWith(
        gameState: GameState.finished,
        message: "👑 [ ${updatedPlayer.name} ] بردییەوە! 👑",
      );
      return;
    }

    _nextTurn();
  }

  void _updatePlayerPosition(int playerIndex, int position) {
    final updatedPlayers = List<Player>.from(state.players);
    updatedPlayers[playerIndex] = updatedPlayers[playerIndex].copyWith(position: position);
    state = state.copyWith(players: updatedPlayers);
  }

  Future<void> _checkSnakesAndLadders() async {
    final currentPlayer = state.players[state.currentPlayerIndex];

    if (GameConstants.ladders.containsKey(currentPlayer.position)) {
      state = state.copyWith(
        message: "🪜 [ ${currentPlayer.name} ] پەیژەیەکی دۆزییەوە! ⬆️",
      );
      await Future.delayed(const Duration(milliseconds: 600));
      final newPosition = GameConstants.ladders[currentPlayer.position]!;
      _updatePlayerPosition(state.currentPlayerIndex, newPosition);
      await Future.delayed(const Duration(milliseconds: 600));
    } else if (GameConstants.snakes.containsKey(currentPlayer.position)) {
      state = state.copyWith(
        message: "🐍 [ ${currentPlayer.name} ] بە مارەکە گیرا! ⬇️",
      );
      await Future.delayed(const Duration(milliseconds: 600));
      final newPosition = GameConstants.snakes[currentPlayer.position]!;
      _updatePlayerPosition(state.currentPlayerIndex, newPosition);
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }

  void _nextTurn() {
    final nextIndex = (state.currentPlayerIndex + 1) % state.players.length;
    state = state.copyWith(
      currentPlayerIndex: nextIndex,
      gameState: GameState.idle,
      message: "نۆرەی [ ${state.players[nextIndex].name} ] یە 🔥",
    );
  }

  void resetGame() {
    state = GameControllerState.initial();
  }

  void updatePlayerName(int index, String name) {
    if (name.trim().isEmpty) return;
    final updatedPlayers = List<Player>.from(state.players);
    updatedPlayers[index] = updatedPlayers[index].copyWith(name: name);
    state = state.copyWith(players: updatedPlayers);
  }
}

class GameControllerState {
  final List<Player> players;
  final int currentPlayerIndex;
  final int diceValue;
  final GameState gameState;
  final String message;

  GameControllerState({
    required this.players,
    required this.currentPlayerIndex,
    required this.diceValue,
    required this.gameState,
    required this.message,
  });

  factory GameControllerState.initial() {
    return GameControllerState(
      players: [
        Player(id: '1', name: "یاریزان ١", color: const Color(0xFF00FFFF)),
        Player(id: '2', name: "یاریزان ٢", color: const Color(0xFFFF00FF)),
      ],
      currentPlayerIndex: 0,
      diceValue: 1,
      gameState: GameState.idle,
      message: "بۆ هاویشتنی زار، کلیک لە بۆردەکە بکە! 🎲",
    );
  }

  GameControllerState copyWith({
    List<Player>? players,
    int? currentPlayerIndex,
    int? diceValue,
    GameState? gameState,
    String? message,
  }) {
    return GameControllerState(
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      diceValue: diceValue ?? this.diceValue,
      gameState: gameState ?? this.gameState,
      message: message ?? this.message,
    );
  }
}

final gameControllerProvider = StateNotifierProvider<GameController, GameControllerState>((ref) {
  return GameController();
});
