import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/providers/game_providers.dart';
import 'package:monstershooting/service/game_logic_service.dart';
import 'package:monstershooting/widgets/whack_monster.dart';

class GamePageWhackMode extends ConsumerStatefulWidget {
  const GamePageWhackMode({super.key});

  @override
  GamePageWhackModeState createState() => GamePageWhackModeState();
}

class GamePageWhackModeState extends ConsumerState<GamePageWhackMode> {
  late final GameLogicService _gameLogicService;

  @override
  void initState() {
    super.initState();
    _gameLogicService = ref.read(gameLogicProvider);
  }

  @override
  void dispose() {
    Future.microtask(() {
      _gameLogicService.stopWhackMode();
    });
    super.dispose();
  }

  Widget _buildMole(int index, Alignment alignment, Offset offset) {
    final state = ref.watch(whackMolesProvider)[index]!;

    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: GestureDetector(
          onTap: () {
            ref.read(monsterWhackamoleServiceProvider).onMoleTapped(index);
          },
          child: WhackMonsterWidget(
            monsterAnimation: state.animation,
            shoot: state.shoot,
            showSpeed: state.showSpeed,
            onReset: () {
              ref.read(monsterWhackamoleServiceProvider).onMonsterMissed(index);
            },
            onShot: () {
              ref
                  .read(monsterWhackamoleServiceProvider)
                  .onShotAnimationFinished(index);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * .75,
        height: MediaQuery.sizeOf(context).height * .75,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildMole(0, Alignment.topCenter, const Offset(0, -150)),
            _buildMole(1, Alignment.topLeft, Offset.zero),
            _buildMole(2, Alignment.topRight, Offset.zero),
            _buildMole(3, Alignment.center, const Offset(0, -75)),
            _buildMole(4, Alignment.bottomCenter, Offset.zero),
            _buildMole(5, Alignment.bottomLeft, const Offset(0, -150)),
            _buildMole(6, Alignment.bottomRight, const Offset(0, -150)),
          ],
        ),
      ),
    );
  }
}
