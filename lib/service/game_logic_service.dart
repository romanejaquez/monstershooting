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
}
