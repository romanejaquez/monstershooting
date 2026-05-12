import 'package:flutter/material.dart';
import 'package:monstershooting/widgets/monster_dead_surface.dart';
import 'package:monstershooting/widgets/monster_mob_surface.dart';

class GamePageMobMode extends StatefulWidget {
  const GamePageMobMode({super.key});

  @override
  State<GamePageMobMode> createState() => GamePageMobModeState();
}

class GamePageMobModeState extends State<GamePageMobMode> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [MonsterDeadSurface(), MonsterMobSurface()]);
  }
}
