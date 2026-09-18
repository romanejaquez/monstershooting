import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/providers/audio_providers.dart';

/// Dedicated service for coordinating the preloading of game sounds upfront.
class SoundPreloadService {
  final Ref _ref;

  SoundPreloadService(this._ref);

  /// Preloads sound assets into memory.
  /// Defaults to all sounds in [GameSounds.values] if [sounds] is not specified.
  Future<void> preloadSounds({List<GameSounds>? sounds}) async {
    final soundsToLoad = sounds ?? GameSounds.values;
    final loader = _ref.read(soundLoaderServiceProvider);
    final notifier = _ref.read(soundStateProvider.notifier);

    notifier.setPreloading(true);
    debugPrint('[SoundPreloadService] Starting preloading ${soundsToLoad.length} sounds...');

    try {
      await Future.wait(
        soundsToLoad.map((sound) async {
          try {
            await loader.loadSound(sound);
          } catch (e) {
            debugPrint('[SoundPreloadService] Could not preload ${sound.name}: $e');
          }
        }),
      );
      debugPrint('[SoundPreloadService] All sound preloading complete.');
    } finally {
      notifier.setPreloading(false);
    }
  }

  /// Checks if all defined [GameSounds] have been loaded into memory.
  bool isAllPreloaded() {
    final state = _ref.read(soundStateProvider);
    return GameSounds.values.every((sound) => state.loadedSounds.contains(sound));
  }
}
