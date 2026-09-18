import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/providers/audio_providers.dart';

/// Dedicated service for loading game sounds into memory via [SoLoud].
class SoundLoaderService {
  final Ref _ref;
  final Map<GameSounds, AudioSource> _loadedSources = {};

  SoundLoaderService(this._ref);

  /// Initializes the [SoLoud] engine if not already initialized.
  Future<void> init() async {
    try {
      if (!SoLoud.instance.isInitialized) {
        await SoLoud.instance.init();
        _ref.read(soundStateProvider.notifier).setInitialized(true);
        debugPrint('[SoundLoaderService] SoLoud engine initialized successfully.');
      }
    } catch (e, stack) {
      debugPrint('[SoundLoaderService] Error initializing SoLoud: $e\n$stack');
    }
  }

  /// Loads a specific [GameSounds] asset into memory and caches it.
  /// If the sound is already loaded, the cached [AudioSource] is returned.
  Future<AudioSource> loadSound(GameSounds sound) async {
    if (_loadedSources.containsKey(sound)) {
      return _loadedSources[sound]!;
    }

    await init();

    try {
      final source = await SoLoud.instance.loadAsset(
        sound.path,
        mode: LoadMode.memory,
      );
      _loadedSources[sound] = source;
      _ref.read(soundStateProvider.notifier).markSoundLoaded(sound);
      debugPrint('[SoundLoaderService] Loaded sound: ${sound.name} (${sound.path})');
      return source;
    } catch (e, stack) {
      debugPrint('[SoundLoaderService] Failed to load sound: ${sound.name} ($e)\n$stack');
      rethrow;
    }
  }

  /// Retrieves the pre-loaded [AudioSource] for [sound], if available.
  AudioSource? getAudioSource(GameSounds sound) {
    return _loadedSources[sound];
  }

  /// Returns whether the specified [sound] has been loaded into memory.
  bool isLoaded(GameSounds sound) {
    return _loadedSources.containsKey(sound);
  }

  /// Disposes a single loaded sound.
  Future<void> disposeSound(GameSounds sound) async {
    final source = _loadedSources.remove(sound);
    if (source != null) {
      try {
        await SoLoud.instance.disposeSource(source);
      } catch (e) {
        debugPrint('[SoundLoaderService] Error disposing sound ${sound.name}: $e');
      }
    }
  }

  /// Disposes all loaded sounds and clears the cache.
  Future<void> dispose() async {
    for (final source in _loadedSources.values) {
      try {
        await SoLoud.instance.disposeSource(source);
      } catch (e) {
        debugPrint('[SoundLoaderService] Error disposing source: $e');
      }
    }
    _loadedSources.clear();
  }
}
