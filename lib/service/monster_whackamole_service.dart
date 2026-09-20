import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/providers/game_providers.dart';

const _kSpawnAnimations = [
  MonsterAnimations.purple,
  MonsterAnimations.red,
  MonsterAnimations.orange,
  MonsterAnimations.green,
  MonsterAnimations.blue,
];

class MonsterWhackamoleService {
  MonsterWhackamoleService(this.ref);

  final Ref ref;
  final _rng = Random();

  Timer? _spawnTimer;
  bool _isRunning = false;
  final Map<int, Timer> _safetyTimers = {};

  void startSpawning() {
    if (_isRunning) return;
    _isRunning = true;
    _scheduleNextSpawn();
  }

  void stopSpawning() {
    _isRunning = false;
    _spawnTimer?.cancel();
    _spawnTimer = null;
    for (var timer in _safetyTimers.values) {
      timer.cancel();
    }
    _safetyTimers.clear();
    ref.read(whackMolesProvider.notifier).resetMoles();
  }

  void _scheduleNextSpawn() {
    if (!_isRunning) return;

    final delay = Duration(milliseconds: 300 + _rng.nextInt(700));
    _spawnTimer = Timer(delay, () {
      if (!_isRunning) return;
      _spawnRandomMole();
      _scheduleNextSpawn();
    });
  }

  void _spawnRandomMole() {
    final moles = ref.read(whackMolesProvider);
    final availableIndices = moles.entries
        .where((e) => !e.value.isVisible)
        .map((e) => e.key)
        .toList();

    if (availableIndices.isEmpty) return;

    final index = availableIndices[_rng.nextInt(availableIndices.length)];
    final animation = _kSpawnAnimations[_rng.nextInt(_kSpawnAnimations.length)];
    final speed = 1 + _rng.nextInt(4); // 1, 2, 3, or 4

    ref
        .read(whackMolesProvider.notifier)
        .updateMole(
          index,
          MoleState(
            animation: animation,
            showSpeed: speed,
            shoot: false,
            isVisible: true,
          ),
        );

    _safetyTimers[index]?.cancel();
    _safetyTimers[index] = Timer(const Duration(seconds: 5), () {
      if (!_isRunning) return;
      onMonsterMissed(index); // Force hide if it's stuck
    });
  }

  void onMoleTapped(int index) {
    if (!_isRunning) return;

    final state = ref.read(whackMolesProvider)[index];
    if (state == null || !state.isVisible || state.shoot) return;

    // Trigger the shot animation by setting shoot = true
    ref
        .read(whackMolesProvider.notifier)
        .updateMole(index, state.copyWith(shoot: true));
  }

  void onShotAnimationFinished(int index) {
    if (!_isRunning) return;

    final state = ref.read(whackMolesProvider)[index];
    if (state == null || !state.isVisible || !state.shoot) return;

    _safetyTimers[index]?.cancel();

    // Collect score when shot animation finishes
    ref.read(gameScoreProvider.notifier).addGameScore(100);

    // Hide the mole and prepare for re-spawning
    ref
        .read(whackMolesProvider.notifier)
        .updateMole(
          index,
          const MoleState(
            animation: MonsterAnimations.none,
            showSpeed: 1,
            shoot: false,
            isVisible: false,
          ),
        );
  }

  void onMonsterMissed(int index) {
    if (!_isRunning) return;

    final state = ref.read(whackMolesProvider)[index];
    if (state == null || !state.isVisible || state.shoot) return;

    _safetyTimers[index]?.cancel();

    // The monster went back inside the hole
    ref
        .read(whackMolesProvider.notifier)
        .updateMole(
          index,
          const MoleState(
            animation: MonsterAnimations.none,
            showSpeed: 1,
            shoot: false,
            isVisible: false,
          ),
        );
  }
}
