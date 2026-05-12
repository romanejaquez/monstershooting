import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/providers/game_providers.dart';

class GameLogicService {
  GameLogicService(this.ref);

  final Ref ref;

  void startGame() {
    ref.read(gameInProgressProvider.notifier).setGameInProgress(true);
  }

  void stopGame() {
    ref.read(gameInProgressProvider.notifier).setGameInProgress(false);
  }

  /// Starts mob-mode: resets score, marks game in progress, then delegates
  /// the actual spawn loop to [MonsterSpawningService].
  void startMobMode({required double screenWidth, required double screenHeight}) {
    ref.read(gameScoreProvider.notifier).resetGameScore();
    ref.read(gameInProgressProvider.notifier).setGameInProgress(true);

    final spawner = ref.read(monsterSpawningServiceProvider);
    spawner.setScreenSize(screenWidth, screenHeight);
    spawner.startSpawning();
  }

  /// Stops mob-mode and clears the field.
  void stopMobMode() {
    ref.read(monsterSpawningServiceProvider).stopSpawning();
    ref.read(gameInProgressProvider.notifier).setGameInProgress(false);
  }
}
