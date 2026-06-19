import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_snake_ladders/domain/usecases/roll_dice_usecase.dart';
import 'package:cyber_snake_ladders/domain/usecases/check_winner_usecase.dart';

void main() {
  group('RollDiceUseCase', () {
    late RollDiceUseCase rollDiceUseCase;

    setUp(() {
      rollDiceUseCase = RollDiceUseCase();
    });

    test('زار دەبێت لە نێوان 1 و 6 بێت', () {
      for (int i = 0; i < 100; i++) {
        final result = rollDiceUseCase.execute();
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(6));
      }
    });

    test('زار دەبێت ژمارەی تەواو بگەڕێنێتەوە', () {
      final result = rollDiceUseCase.execute();
      expect(result, isA<int>());
    });
  });

  group('CheckWinnerUseCase', () {
    late CheckWinnerUseCase checkWinnerUseCase;

    setUp(() {
      checkWinnerUseCase = CheckWinnerUseCase();
    });

    test('کاتێک یاریزان لە خانەی 100 یە، دەبێتە براوە', () {
      expect(checkWinnerUseCase.execute(100), isTrue);
    });

    test('کاتێک یاریزان لە خانەی 99 یە، نابێتە براوە', () {
      expect(checkWinnerUseCase.execute(99), isFalse);
    });

    test('کاتێک یاریزان لە خانەی 50 یە، نابێتە براوە', () {
      expect(checkWinnerUseCase.execute(50), isFalse);
    });
  });
}
