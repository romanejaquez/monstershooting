import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/providers/audio_providers.dart';

/// High-level audio service providing a clean developer API to play sounds,
/// trigger gunshots, and manage looping background music.
class GameAudioService {
  final Ref _ref;
  SoundHandle? _bgMusicHandle;

  GameAudioService(this._ref);

  /// Plays any sound defined in [GameSounds].
  /// Loads the sound automatically if it has not been preloaded yet.
  Future<SoundHandle?> playSound(
    GameSounds sound, {
    double volume = 1.0,
    bool looping = false,
  }) async {
    final soundState = _ref.read(soundStateProvider);
    if (soundState.isMuted) return null;

    try {
      final loader = _ref.read(soundLoaderServiceProvider);
      final source = loader.getAudioSource(sound) ?? await loader.loadSound(sound);

      final handle = SoLoud.instance.play(
        source,
        volume: volume,
        looping: looping,
      );
      return handle;
    } catch (e, stack) {
      debugPrint('[GameAudioService] Error playing sound ${sound.name}: $e\n$stack');
      return null;
    }
  }

  /// Starts playing the background music [GameSounds.gamebgmusic] in an indefinite loop.
  /// Automatically loads the file if it hasn't been loaded yet.
  Future<SoundHandle?> playBgMusic({double volume = 0.5, bool forceRestart = false}) async {
    // If background music is already playing and restart is not forced, keep playing.
    if (!forceRestart && _bgMusicHandle != null && _ref.read(soundStateProvider).isBgMusicPlaying) {
      return _bgMusicHandle;
    }

    if (_bgMusicHandle != null) {
      await stopBgMusic();
    }

    try {
      // Ensure the bg music sound asset is loaded
      final loader = _ref.read(soundLoaderServiceProvider);
      await loader.loadSound(GameSounds.gamebgmusic);

      final handle = await playSound(
        GameSounds.gamebgmusic,
        volume: volume,
        looping: true,
      );

      _bgMusicHandle = handle;
      _ref.read(soundStateProvider.notifier).setBgMusicPlaying(handle != null);
      debugPrint('[GameAudioService] Background music started.');
      return handle;
    } catch (e, stack) {
      debugPrint('[GameAudioService] Error starting bg music: $e\n$stack');
      return null;
    }
  }

  /// Stops the currently playing background music.
  Future<void> stopBgMusic() async {
    if (_bgMusicHandle != null) {
      try {
        await SoLoud.instance.stop(_bgMusicHandle!);
      } catch (e) {
        debugPrint('[GameAudioService] Error stopping bg music handle: $e');
      } finally {
        _bgMusicHandle = null;
        _ref.read(soundStateProvider.notifier).setBgMusicPlaying(false);
        debugPrint('[GameAudioService] Background music stopped.');
      }
    }
  }

  /// Plays the light gun laser shot sound [GameSounds.lasershot] once.
  Future<SoundHandle?> shoot({double volume = 0.8}) async {
    return playSound(
      GameSounds.lasershot,
      volume: volume,
      looping: false,
    );
  }

  /// Plays the dudshot and boo sounds concurrently when shooting an incorrect target.
  Future<void> playWrongTargetShot() async {
    playSound(GameSounds.dudshot, volume: 0.9);
    playSound(GameSounds.boo, volume: 0.8);
  }

  /// Disposes of any active handles.
  Future<void> dispose() async {
    await stopBgMusic();
  }
}
