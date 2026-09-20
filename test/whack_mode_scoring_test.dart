import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/providers/game_providers.dart';

void main() {
  group('Whack Mode Scoring and State Tests', () {
    test('onShotAnimationFinished only increments score once even if called repeatedly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(monsterWhackamoleServiceProvider);

      // Start spawning to enable running state
      service.startSpawning();

      // Put mole 0 in visible state
      container.read(whackMolesProvider.notifier).updateMole(
            0,
            const MoleState(
              animation: MonsterAnimations.purple,
              showSpeed: 1,
              shoot: false,
              isVisible: true,
            ),
          );

      // Tap mole 0 to begin shooting
      service.onMoleTapped(0);

      expect(container.read(whackMolesProvider)[0]!.shoot, true);
      expect(container.read(gameScoreProvider), 0.0);

      // First animation finished event
      service.onShotAnimationFinished(0);

      expect(container.read(gameScoreProvider), 100.0);
      expect(container.read(whackMolesProvider)[0]!.isVisible, false);
      expect(container.read(whackMolesProvider)[0]!.shoot, false);

      // Second redundant animation finished event (e.g. from Rive state machine re-firing)
      service.onShotAnimationFinished(0);

      // Score must remain 100.0, NOT 200.0!
      expect(container.read(gameScoreProvider), 100.0);

      service.stopSpawning();
    });

    test('onMonsterMissed does not change score and resets mole', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final service = container.read(monsterWhackamoleServiceProvider);
      service.startSpawning();

      container.read(whackMolesProvider.notifier).updateMole(
            1,
            const MoleState(
              animation: MonsterAnimations.green,
              showSpeed: 2,
              shoot: false,
              isVisible: true,
            ),
          );

      service.onMonsterMissed(1);

      expect(container.read(gameScoreProvider), 0.0);
      expect(container.read(whackMolesProvider)[1]!.isVisible, false);

      // Subsequent duplicate missed calls do nothing
      service.onMonsterMissed(1);
      expect(container.read(gameScoreProvider), 0.0);

      service.stopSpawning();
    });
  });
}
