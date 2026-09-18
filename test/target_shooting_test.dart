import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/providers/game_providers.dart';

void main() {
  group('Target Monster Shooting Logic Tests', () {
    test('CurrentTargetMonsterNotifier starts at none and can be updated and reset', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(currentTargetMonsterProvider), MonsterAnimations.none);

      container.read(currentTargetMonsterProvider.notifier).setTarget(MonsterAnimations.red);
      expect(container.read(currentTargetMonsterProvider), MonsterAnimations.red);

      container.read(currentTargetMonsterProvider.notifier).setTarget(MonsterAnimations.blue);
      expect(container.read(currentTargetMonsterProvider), MonsterAnimations.blue);

      container.read(currentTargetMonsterProvider.notifier).reset();
      expect(container.read(currentTargetMonsterProvider), MonsterAnimations.none);
    });

    test('ActiveMonsterNotifier updates monster animation in place to mainghost', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(activeMonsterProvider.notifier);
      const entry1 = MonsterEntry(
        id: 'monster_1',
        animation: MonsterAnimations.purple,
        left: 100,
        speed: Duration(seconds: 5),
      );
      const entry2 = MonsterEntry(
        id: 'monster_2',
        animation: MonsterAnimations.red,
        left: 200,
        speed: Duration(seconds: 7),
      );

      notifier.addMonster(entry1);
      notifier.addMonster(entry2);

      expect(container.read(activeMonsterProvider).length, 2);

      // Morph monster_1 into mainghost
      notifier.updateMonsterAnimation('monster_1', MonsterAnimations.mainghost);

      final updated = container.read(activeMonsterProvider);
      final m1 = updated.firstWhere((m) => m.id == 'monster_1');
      final m2 = updated.firstWhere((m) => m.id == 'monster_2');

      expect(m1.animation, MonsterAnimations.mainghost);
      expect(m1.left, 100);
      expect(m1.speed, const Duration(seconds: 5));

      // monster_2 remains unchanged
      expect(m2.animation, MonsterAnimations.red);
    });
  });
}
