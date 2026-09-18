import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/providers/audio_providers.dart';

void main() {
  group('GameSounds Enum Tests', () {
    test('GameSounds enum contains gamebgmusic and lasershot with correct paths', () {
      expect(GameSounds.gamebgmusic.name, 'gamebgmusic');
      expect(GameSounds.gamebgmusic.path, 'assets/sounds/gamebgmusic.mp3');

      expect(GameSounds.lasershot.name, 'lasershot');
      expect(GameSounds.lasershot.path, 'assets/sounds/lasershot.mp3');
    });
  });

  group('SoundState and SoundStateNotifier Tests', () {
    test('Initial state is correct', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(soundStateProvider);
      expect(state.isInitialized, false);
      expect(state.isPreloading, false);
      expect(state.loadedSounds, isEmpty);
      expect(state.isBgMusicPlaying, false);
      expect(state.isMuted, false);
    });

    test('SoundStateNotifier mutations update state correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(soundStateProvider.notifier);

      notifier.setInitialized(true);
      expect(container.read(soundStateProvider).isInitialized, true);

      notifier.setPreloading(true);
      expect(container.read(soundStateProvider).isPreloading, true);

      notifier.markSoundLoaded(GameSounds.lasershot);
      expect(
        container.read(soundStateProvider).loadedSounds.contains(GameSounds.lasershot),
        true,
      );

      notifier.markSoundLoaded(GameSounds.gamebgmusic);
      expect(
        container.read(soundStateProvider).loadedSounds.contains(GameSounds.gamebgmusic),
        true,
      );

      notifier.setBgMusicPlaying(true);
      expect(container.read(soundStateProvider).isBgMusicPlaying, true);

      notifier.toggleMute();
      expect(container.read(soundStateProvider).isMuted, true);
      notifier.toggleMute();
      expect(container.read(soundStateProvider).isMuted, false);
    });

    test('SoundPreloadService isAllPreloaded reflects loaded sounds', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final preloadService = container.read(soundPreloadServiceProvider);
      expect(preloadService.isAllPreloaded(), false);

      final notifier = container.read(soundStateProvider.notifier);
      notifier.markSoundLoaded(GameSounds.gamebgmusic);
      expect(preloadService.isAllPreloaded(), false);

      notifier.markSoundLoaded(GameSounds.lasershot);
      expect(preloadService.isAllPreloaded(), true);
    });

    test('Providers can be read from ProviderContainer', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(soundLoaderServiceProvider), isNotNull);
      expect(container.read(soundPreloadServiceProvider), isNotNull);
      expect(container.read(gameAudioServiceProvider), isNotNull);
    });
  });
}
