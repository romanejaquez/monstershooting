import 'package:flutter/material.dart';
import 'package:monstershooting/helpers/constants.dart';
import 'package:monstershooting/widgets/monster_anim.dart';

class MonsterDeadWidget extends StatefulWidget {
  const MonsterDeadWidget({super.key});

  @override
  State<MonsterDeadWidget> createState() => MonsterDeadWidgetState();
}

class MonsterDeadWidgetState extends State<MonsterDeadWidget> {
  @override
  Widget build(BuildContext context) {
    return MonsterAnimWidget(
      size: Size(Constants.monsterWidth, Constants.monsterHeight),
      monsterAnimation: MonsterAnimations.monsterdead,
    );
  }
}
