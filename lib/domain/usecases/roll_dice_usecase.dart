import 'dart:math';

class RollDiceUseCase {
  /// هاویشتنی زار و گەڕاندنەوەی ژمارەیەکی ڕەندۆم لە 1 تا 6
  int execute() {
    return Random().nextInt(6) + 1;
  }
}
