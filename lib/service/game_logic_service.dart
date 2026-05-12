import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/providers/game_providers.dart';

class GameLogicService {
  GameLogicService(this.ref);

  final Ref ref;
  Timer? _gameTimer;

  void startGame() {
    ref.read(gameInProgressProvider.notifier).setGameInProgress(true);
  }

  void stopGame() {
    ref.read(gameInProgressProvider.notifier).setGameInProgress(false);
  }

  // ── Mob mode ──────────────────────────────────────────────────────────────

  /// Called after the countdown finishes. Resets + starts spawn loop AND the
  /// 60-second game timer.
  void startMobMode({
    required double screenWidth,
    required double screenHeight,
    required void Function() onTimeUp,
  }) {
    ref.read(gameScoreProvider.notifier).resetGameScore();
    ref.read(gameTimerProvider.notifier).reset();
    ref.read(gameInProgressProvider.notifier).setGameInProgress(true);

    final spawner = ref.read(monsterSpawningServiceProvider);
    spawner.setScreenSize(screenWidth, screenHeight);
    spawner.startSpawning();

    _startGameTimer(onTimeUp: onTimeUp);
  }

  /// Stops mob-mode, cancels timer, and clears the field.
  void stopMobMode() {
    _cancelGameTimer();
    ref.read(monsterSpawningServiceProvider).stopSpawning();
    ref.read(gameInProgressProvider.notifier).setGameInProgress(false);
    // Reset countdown overlay for next session.
    ref.read(countdownVisibleProvider.notifier).show();
  }

  // ── Whack mode ────────────────────────────────────────────────────────────

  void startWhackMode({
    required void Function() onTimeUp,
  }) {
    ref.read(gameScoreProvider.notifier).resetGameScore();
    ref.read(gameTimerProvider.notifier).reset();
    ref.read(gameInProgressProvider.notifier).setGameInProgress(true);

    ref.read(monsterWhackamoleServiceProvider).startSpawning();

    _startGameTimer(onTimeUp: onTimeUp);
  }

  void stopWhackMode() {
    _cancelGameTimer();
    ref.read(monsterWhackamoleServiceProvider).stopSpawning();
    ref.read(gameInProgressProvider.notifier).setGameInProgress(false);
    // Reset countdown overlay for next session.
    ref.read(countdownVisibleProvider.notifier).show();
  }

  // ── Game timer ────────────────────────────────────────────────────────────

  void _startGameTimer({required void Function() onTimeUp}) {
    _cancelGameTimer();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = ref.read(gameTimerProvider);
      if (remaining <= 1) {
        // Tick to zero, then stop everything.
        ref.read(gameTimerProvider.notifier).tick();
        _cancelGameTimer();
        ref.read(monsterSpawningServiceProvider).stopSpawning();
        ref.read(monsterWhackamoleServiceProvider).stopSpawning();
        ref.read(gameInProgressProvider.notifier).setGameInProgress(false);
        onTimeUp();
      } else {
        ref.read(gameTimerProvider.notifier).tick();
      }
    });
  }

  void _cancelGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }
}
