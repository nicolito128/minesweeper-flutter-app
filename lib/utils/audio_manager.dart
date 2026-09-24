import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  AudioManager._();

  static final AudioPlayer _bgmPlayer = AudioPlayer();

  static final AudioPlayer _sfxPlayer1 = AudioPlayer();
  static final AudioPlayer _sfxPlayer2 = AudioPlayer();
  static bool _usePlayer1 = true;

  static bool _isInitialized = false;
  static bool _bgmStarted = false;

  static Future<void> init() async {
    if (_isInitialized) return;

    await _bgmPlayer.setVolume(0.2);
    await _sfxPlayer1.setVolume(0.1);
    await _sfxPlayer2.setVolume(0.1);
    _isInitialized = true;
  }

  static Future<void> playBackgroundMusic() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('sounds/bgm.ogg'));
  }

  static Future<void> ensureBackgroundMusicStarted() async {
    if (_bgmStarted || !_isInitialized) return;
    _bgmStarted = true;

    try {
      await playBackgroundMusic();
    } catch (e) {
      _bgmStarted = false;
    }
  }

  static Future<void> stopBackgroundMusic() async {
    await _bgmPlayer.stop();
  }

  static Future<void> playBubblePop() async {
    if (!_isInitialized) return;

    if (_usePlayer1) {
      await _sfxPlayer1.stop();
      await _sfxPlayer1.play(AssetSource('sounds/bubble-pop.ogg'), volume: 0.7);
    } else {
      await _sfxPlayer2.stop();
      await _sfxPlayer2.play(AssetSource('sounds/bubble-pop.ogg'), volume: 0.7);
    }

    _usePlayer1 = !_usePlayer1;
  }

  static Future<void> playClick() async {
    if (!_isInitialized) return;

    if (_usePlayer1) {
      await _sfxPlayer1.stop();
      await _sfxPlayer1.play(AssetSource('sounds/click.ogg'), volume: 0.7);
    } else {
      await _sfxPlayer2.stop();
      await _sfxPlayer2.play(AssetSource('sounds/click.ogg'), volume: 0.7);
    }

    _usePlayer1 = !_usePlayer1;
  }

  static Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer1.dispose();
    await _sfxPlayer2.dispose();
  }
}
