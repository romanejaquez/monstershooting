import 'package:flutter/material.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/pages/final_score_page.dart';
import 'package:monstershooting/pages/game_page_mob_mode.dart';
import 'package:monstershooting/widgets/monster_anim.dart';
import 'package:monstershooting/widgets/score_board.dart';
import 'package:monstershooting/widgets/shooting_banner.dart';
import 'package:rive/rive.dart';

class GamePage extends StatefulWidget {
  static const String route = '/game';
  const GamePage({super.key});

  @override
  State<GamePage> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MonsterAnimWidget(
            monsterAnimation: MonsterAnimations.monsterbg,
            fit: Fit.cover,
          ),

          GamePageMobMode(),

          //GamePageWhackMode(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(FinalScorePage.route);
            },
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 350,
                height: 200,
                child: ShootingBannerWidget(anim: MonsterAnimations.red),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 350,
                height: 200,
                child: ScoreBoardWidget(score: 150),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
