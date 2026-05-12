import 'package:flutter/material.dart';
import 'package:monstershooting/widgets/monster_anim.dart';
import 'package:monstershooting/widgets/monster_dead.dart';
import 'package:monstershooting/widgets/monster_widget.dart';

class GamePageMobMode extends StatefulWidget {
  const GamePageMobMode({super.key});

  @override
  _GamePageMobModeState createState() => _GamePageMobModeState();
}

class _GamePageMobModeState extends State<GamePageMobMode> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MonsterWidget(monsterAnimation: MonsterAnimations.purple),
              SizedBox(width: 50),
              MonsterWidget(monsterAnimation: MonsterAnimations.green),
              SizedBox(width: 50),
              MonsterWidget(monsterAnimation: MonsterAnimations.red),
              SizedBox(width: 50),
              MonsterWidget(monsterAnimation: MonsterAnimations.orange),
              SizedBox(width: 50),
              MonsterWidget(monsterAnimation: MonsterAnimations.blue),
              SizedBox(width: 50),
              MonsterDeadWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
