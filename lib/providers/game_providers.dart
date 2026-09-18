import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/service/game_logic_service.dart';
import 'package:monstershooting/service/monster_spawning_service.dart';
import 'package:monstershooting/service/monster_whackamole_service.dart';

export 'package:monstershooting/providers/audio_providers.dart';

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

/// Represents a live monster currently on the mob surface.
class MonsterEntry {
  final String id;
  final MonsterAnimations animation;

  /// Horizontal position of the left edge.
  final double left;

  /// Duration of the full top-to-bottom traversal.
  final Duration speed;

  const MonsterEntry({
    required this.id,
    required this.animation,
    required this.left,
    required this.speed,
  });
}

/// Represents a dead-monster flash rendered on the dead surface.
class DeadMonsterEntry {
  final String id;

  /// Position at which the live monster was killed.
  final Offset position;

  const DeadMonsterEntry({required this.id, required this.position});
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final selectedGameModeProvider =
    NotifierProvider<SelectedGameModeNotifier, GameMode?>(
      () => SelectedGameModeNotifier(),
    );

class SelectedGameModeNotifier extends Notifier<GameMode?> {
  @override
  GameMode? build() => null;

  void setSelectedGameMode(GameMode gameMode) {
    state = gameMode;
  }
}

final gameLogicProvider = Provider<GameLogicService>(
  (ref) => GameLogicService(ref),
);

final monsterSpawningServiceProvider = Provider<MonsterSpawningService>(
  (ref) => MonsterSpawningService(ref),
);

final gameInProgressProvider = NotifierProvider<GameInProgressNotifier, bool>(
  () => GameInProgressNotifier(),
);

class GameInProgressNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setGameInProgress(bool gameInProgress) {
    state = gameInProgress;
  }
}

final gameScoreProvider = NotifierProvider<GameScoreNotifier, double>(
  () => GameScoreNotifier(),
);

class GameScoreNotifier extends Notifier<double> {
  @override
  double build() => 0;

  void addGameScore(double points) {
    state += points;
  }

  void removeGameScore(double points) {
    state = state > points ? state - points : 0;
  }

  void resetGameScore() {
    state = 0;
  }
}

// ---------------------------------------------------------------------------
// Game timer (counts down from 60 seconds)
// ---------------------------------------------------------------------------

const int kGameDurationSeconds = 60;

final gameTimerProvider = NotifierProvider<GameTimerNotifier, int>(
  () => GameTimerNotifier(),
);

class GameTimerNotifier extends Notifier<int> {
  @override
  int build() => kGameDurationSeconds;

  void tick() {
    if (state > 0) state = state - 1;
  }

  void reset() {
    state = kGameDurationSeconds;
  }
}

// ---------------------------------------------------------------------------
// Countdown overlay visibility
// ---------------------------------------------------------------------------

final countdownVisibleProvider =
    NotifierProvider<CountdownVisibleNotifier, bool>(
      () => CountdownVisibleNotifier(),
    );

class CountdownVisibleNotifier extends Notifier<bool> {
  @override
  bool build() => true; // visible by default when game page opens

  void hide() => state = false;
  void show() => state = true;
}

// ---------------------------------------------------------------------------
// Active-monster list (mob surface)
// ---------------------------------------------------------------------------

final activeMonsterProvider =
    NotifierProvider<ActiveMonsterNotifier, List<MonsterEntry>>(
      () => ActiveMonsterNotifier(),
    );

class ActiveMonsterNotifier extends Notifier<List<MonsterEntry>> {
  @override
  List<MonsterEntry> build() => [];

  void addMonster(MonsterEntry entry) {
    // Prepend so the newest monster is rendered FIRST in the Stack (behind).
    // Monsters already further down the screen stay at the END of the list
    // (rendered ON TOP), creating the illusion they walk in front.
    state = [entry, ...state];
  }

  void removeMonster(String id) {
    state = state.where((m) => m.id != id).toList();
  }

  void clear() {
    state = [];
  }
}

// ---------------------------------------------------------------------------
// Active-dead-monster list (dead surface)
// ---------------------------------------------------------------------------

final activeDeadMonsterProvider =
    NotifierProvider<ActiveDeadMonsterNotifier, List<DeadMonsterEntry>>(
      () => ActiveDeadMonsterNotifier(),
    );

class ActiveDeadMonsterNotifier extends Notifier<List<DeadMonsterEntry>> {
  @override
  List<DeadMonsterEntry> build() => [];

  void addDead(DeadMonsterEntry entry) {
    state = [...state, entry];
  }

  void removeDead(String id) {
    state = state.where((d) => d.id != id).toList();
  }

  void clear() {
    state = [];
  }
}

// ---------------------------------------------------------------------------
// Whack-a-Mole state
// ---------------------------------------------------------------------------

class MoleState {
  final MonsterAnimations animation;
  final int showSpeed;
  final bool shoot;
  final bool isVisible;

  const MoleState({
    required this.animation,
    required this.showSpeed,
    required this.shoot,
    required this.isVisible,
  });

  MoleState copyWith({
    MonsterAnimations? animation,
    int? showSpeed,
    bool? shoot,
    bool? isVisible,
  }) {
    return MoleState(
      animation: animation ?? this.animation,
      showSpeed: showSpeed ?? this.showSpeed,
      shoot: shoot ?? this.shoot,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

final whackMolesProvider = NotifierProvider<WhackMolesNotifier, Map<int, MoleState>>(() => WhackMolesNotifier());

class WhackMolesNotifier extends Notifier<Map<int, MoleState>> {
  @override
  Map<int, MoleState> build() {
    return {
      for (int i = 0; i < 7; i++)
        i: const MoleState(
          animation: MonsterAnimations.none,
          showSpeed: 1,
          shoot: false,
          isVisible: false,
        )
    };
  }

  void updateMole(int index, MoleState state) {
    this.state = {...this.state, index: state};
  }

  void resetMoles() {
    state = {
      for (int i = 0; i < 7; i++)
        i: const MoleState(
          animation: MonsterAnimations.none,
          showSpeed: 1,
          shoot: false,
          isVisible: false,
        )
    };
  }
}

final monsterWhackamoleServiceProvider = Provider<MonsterWhackamoleService>(
  (ref) => MonsterWhackamoleService(ref),
);
