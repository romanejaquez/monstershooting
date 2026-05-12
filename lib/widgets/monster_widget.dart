import 'package:flutter/material.dart';
import 'package:monstershooting/helpers/constants.dart';
import 'package:monstershooting/widgets/monster_anim.dart';

class MonsterWidget extends StatefulWidget {
  final MonsterAnimations monsterAnimation;
  const MonsterWidget({super.key, required this.monsterAnimation});

  @override
  State<MonsterWidget> createState() => MonsterWidgetState();
}

class MonsterWidgetState extends State<MonsterWidget> {
  @override
  Widget build(BuildContext context) {
    return MonsterAnimWidget(
      size: Size(Constants.monsterWidth, Constants.monsterHeight),
      monsterAnimation: widget.monsterAnimation,
    );
  }
}
