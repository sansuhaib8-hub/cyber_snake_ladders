import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMuted = false;

  Future<void> playDiceRoll() async {
    if (!_isMuted) {
      await _audioPlayer.play(AssetSource('sounds/dice_roll.mp3'));
    }
  }

  Future<void> playLadder() async {
    if (!_isMuted) {
      await _audioPlayer.play(AssetSource('sounds/ladder.mp3'));
    }
  }

  Future<void> playSnake() async {
    if (!_isMuted) {
      await _audioPlayer.play(AssetSource('sounds/snake.mp3'));
    }
  }

  Future<void> playWin() async {
    if (!_isMuted) {
      await _audioPlayer.play(AssetSource('sounds/win.mp3'));
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  bool get isMuted => _isMuted;
}
