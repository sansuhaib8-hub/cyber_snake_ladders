class GameConstants {
  static const int totalCells = 100;
  static const int boardSize = 10;

  static const Map<int, int> snakes = {
    17: 7, 54: 34, 62: 19, 64: 60,
    87: 24, 93: 73, 95: 75, 99: 78,
  };

  static const Map<int, int> ladders = {
    4: 14, 9: 31, 20: 38, 28: 84,
    40: 59, 51: 67, 63: 81, 71: 91,
  };

  static const int diceRollDuration = 800;
  static const int moveDuration = 250;
  static const int effectDuration = 600;
}
