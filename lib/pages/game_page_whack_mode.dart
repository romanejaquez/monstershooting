import 'package:flutter/material.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/widgets/whack_monster.dart';

class GamePageWhackMode extends StatefulWidget {
  const GamePageWhackMode({super.key});

  @override
  _GamePageWhackModeState createState() => _GamePageWhackModeState();
}

class _GamePageWhackModeState extends State<GamePageWhackMode> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * .75,
        height: MediaQuery.sizeOf(context).height * .75,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: const Offset(0, -150),
                child: WhackMonsterWidget(
                  monsterAnimation: MonsterAnimations.blue,
                  shoot: false,
                  onReset: () => {},
                  onShot: () => {},
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: WhackMonsterWidget(
                monsterAnimation: MonsterAnimations.blue,
                shoot: false,
                onReset: () => {},
                onShot: () => {},
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: WhackMonsterWidget(
                monsterAnimation: MonsterAnimations.orange,
                shoot: false,
                onReset: () => {},
                onShot: () => {},
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(0, -75),
                child: WhackMonsterWidget(
                  monsterAnimation: MonsterAnimations.purple,
                  shoot: false,
                  onReset: () => {},
                  onShot: () => {},
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: WhackMonsterWidget(
                monsterAnimation: MonsterAnimations.purple,
                shoot: false,
                onReset: () => {},
                onShot: () => {},
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Transform.translate(
                offset: const Offset(0, -150),
                child: WhackMonsterWidget(
                  monsterAnimation: MonsterAnimations.red,
                  shoot: false,
                  onReset: () => {},
                  onShot: () => {},
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(0, -150),
                child: WhackMonsterWidget(
                  monsterAnimation: MonsterAnimations.green,
                  shoot: false,
                  onReset: () => {},
                  onShot: () => {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
