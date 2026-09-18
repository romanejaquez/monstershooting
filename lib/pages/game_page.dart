import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/pages/final_score_page.dart';
import 'package:monstershooting/pages/game_page_mob_mode.dart';
import 'package:monstershooting/pages/game_page_whack_mode.dart';
import 'package:monstershooting/providers/game_providers.dart';
import 'package:monstershooting/widgets/count_down.dart';
import 'package:monstershooting/widgets/monster_anim.dart';
import 'package:monstershooting/widgets/monster_timer.dart';
import 'package:monstershooting/widgets/score_board_wrapper.dart';
import 'package:monstershooting/widgets/shooting_banner.dart';
import 'package:rive/rive.dart';

class GamePage extends ConsumerStatefulWidget {
  static const String route = '/game';
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => GamePageState();
}

class GamePageState extends ConsumerState<GamePage> {
  @override
  void initState() {
    super.initState();
    // Ensure the countdown is visible whenever we enter this page.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(countdownVisibleProvider.notifier).show();
      }
    });

    // Start background music upon game starting
    ref.read(gameAudioServiceProvider).playBgMusic();
  }

  /// Called by [CountDownWidget] when its Rive "onEnd" event fires.
  void _onCountdownEnd() {
    // Hide the countdown overlay.
    ref.read(countdownVisibleProvider.notifier).hide();

    // Start the game logic now that the countdown has finished
    final gameMode = ref.read(selectedGameModeProvider);
    final size = MediaQuery.sizeOf(context);

    if (gameMode == GameMode.mob) {
      ref
          .read(gameLogicProvider)
          .startMobMode(
            screenWidth: size.width,
            screenHeight: size.height,
            onTimeUp: _onTimeUp,
          );
    } else if (gameMode == GameMode.whack) {
      ref.read(gameLogicProvider).startWhackMode(onTimeUp: _onTimeUp);
    }
  }

  /// Navigated to by [GameLogicService] when the 60-second timer hits zero.
  void _onTimeUp() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(FinalScorePage.route);
  }

  @override
  Widget build(BuildContext context) {
    final countdownVisible = ref.watch(countdownVisibleProvider);
    final gameMode = ref.watch(selectedGameModeProvider);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        children: [
          // ── Background animation ──────────────────────────────────────────
          MonsterAnimWidget(
            monsterAnimation: MonsterAnimations.monsterbg,
            fit: Fit.cover,
          ),

          // ── Game mode surface (mob / whack) ───────────────────────────────
          switch (gameMode) {
            GameMode.mob => const GamePageMobMode(),
            GameMode.whack => const GamePageWhackMode(),
            _ => const SizedBox.shrink(),
          },

          // ── HUD: Score board (top-right) ──────────────────────────────────
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Align(
              alignment: Alignment.topRight,
              child: ScoreBoardWrapper(),
            ),
          ),

          // ── HUD: Banner + Timer (top-left) ────────────────────────────────
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MonsterTimer(),

                Consumer(
                  builder: (context, ref, child) {
                    final gameMode = ref.read(selectedGameModeProvider);

                    if (gameMode == GameMode.mob) {
                      return SizedBox(
                        width: 350,
                        height: 180,
                        child: ShootingBannerWidget(
                          anim: MonsterAnimations.red,
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          // ── Countdown overlay (hidden after animation ends) ───────────────
          if (countdownVisible)
            Center(
              child: SizedBox(
                width: size.width * .8,
                height: size.height * .8,
                child: CountDownWidget(onEnd: _onCountdownEnd),
              ),
            ),
        ],
      ),
    );
  }
}
