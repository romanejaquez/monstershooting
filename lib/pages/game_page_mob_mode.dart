import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/providers/game_providers.dart';
import 'package:monstershooting/service/game_logic_service.dart';
import 'package:monstershooting/widgets/monster_dead_surface.dart';
import 'package:monstershooting/widgets/monster_mob_surface.dart';

class GamePageMobMode extends ConsumerStatefulWidget {
  const GamePageMobMode({super.key});

  @override
  ConsumerState<GamePageMobMode> createState() => GamePageMobModeState();
}

class GamePageMobModeState extends ConsumerState<GamePageMobMode> {
  late final GameLogicService _gameLogicService;

  @override
  void initState() {
    super.initState();
    _gameLogicService = ref.read(gameLogicProvider);
    // Do not start spawning here anymore. We wait for GamePage to call startMobMode
    // after the countdown widget finishes its animation.
  }

  @override
  void dispose() {
    _gameLogicService.stopMobMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        MonsterDeadSurface(),
        MonsterMobSurface(),
      ],
    );
  }
}
