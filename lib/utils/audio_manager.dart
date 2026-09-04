import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  AudioManager._();

  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static final AudioPlayer _sfxPlayer1 = AudioPlayer();
  static final AudioPlayer _sfxPlayer2 = AudioPlayer();
  static bool _usePlayer1 = true;

  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    _isInitialized = true;
  }

  static Future<void> playBackgroundMusic() async {
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('sounds/bgm.mp3'));
  }

  static Future<void> stopBackgroundMusic() async {
    await _bgmPlayer.stop();
  }

  static Future<void> playBubblePop() async {
    if (!_isInitialized) return;

    if (_usePlayer1) {
      await _sfxPlayer1.stop();
      await _sfxPlayer1.play(AssetSource('sounds/bubble-pop.wav'), volume: 0.7);
    } else {
      await _sfxPlayer2.stop();
      await _sfxPlayer2.play(AssetSource('sounds/bubble-pop.wav'), volume: 0.7);
    }

    _usePlayer1 = !_usePlayer1;
  }

  static Future<void> playClick() async {
    if (!_isInitialized) return;

    if (_usePlayer1) {
      await _sfxPlayer1.stop();
      await _sfxPlayer1.play(AssetSource('sounds/click.wav'), volume: 0.7);
    } else {
      await _sfxPlayer2.stop();
      await _sfxPlayer2.play(AssetSource('sounds/click.wav'), volume: 0.7);
    }

    _usePlayer1 = !_usePlayer1;
  }

  static Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer1.dispose();
    await _sfxPlayer2.dispose();
  }
}
