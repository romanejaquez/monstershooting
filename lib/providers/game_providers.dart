import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/service/game_logic_service.dart';
import 'package:monstershooting/service/monster_spawning_service.dart';

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
