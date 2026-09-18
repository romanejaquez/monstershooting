import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/service/game_audio_service.dart';
import 'package:monstershooting/service/sound_loader_service.dart';
import 'package:monstershooting/service/sound_preload_service.dart';

/// State object representing the status of sound loading and playback.
class SoundState {
  final bool isInitialized;
  final bool isPreloading;
  final Set<GameSounds> loadedSounds;
  final bool isBgMusicPlaying;
  final bool isMuted;

  const SoundState({
    this.isInitialized = false,
    this.isPreloading = false,
    this.loadedSounds = const {},
    this.isBgMusicPlaying = false,
    this.isMuted = false,
  });

  SoundState copyWith({
    bool? isInitialized,
    bool? isPreloading,
    Set<GameSounds>? loadedSounds,
    bool? isBgMusicPlaying,
    bool? isMuted,
  }) {
    return SoundState(
      isInitialized: isInitialized ?? this.isInitialized,
      isPreloading: isPreloading ?? this.isPreloading,
      loadedSounds: loadedSounds ?? this.loadedSounds,
      isBgMusicPlaying: isBgMusicPlaying ?? this.isBgMusicPlaying,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}

/// Riverpod 3.0 Notifier managing the [SoundState].
final soundStateProvider = NotifierProvider<SoundStateNotifier, SoundState>(
  SoundStateNotifier.new,
);

class SoundStateNotifier extends Notifier<SoundState> {
  @override
  SoundState build() => const SoundState();

  void setInitialized(bool initialized) {
    state = state.copyWith(isInitialized: initialized);
  }

  void setPreloading(bool preloading) {
    state = state.copyWith(isPreloading: preloading);
  }

  void markSoundLoaded(GameSounds sound) {
    state = state.copyWith(
      loadedSounds: {...state.loadedSounds, sound},
    );
  }

  void setBgMusicPlaying(bool isPlaying) {
    state = state.copyWith(isBgMusicPlaying: isPlaying);
  }

  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }
}

/// Provider for the [SoundLoaderService].
final soundLoaderServiceProvider = Provider<SoundLoaderService>(
  (ref) => SoundLoaderService(ref),
);

/// Provider for the [SoundPreloadService].
final soundPreloadServiceProvider = Provider<SoundPreloadService>(
  (ref) => SoundPreloadService(ref),
);

/// Provider for the high-level [GameAudioService].
final gameAudioServiceProvider = Provider<GameAudioService>(
  (ref) => GameAudioService(ref),
);
