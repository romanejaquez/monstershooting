import 'package:flutter/material.dart';
import 'package:monstershooting/pages/final_score_page.dart';
import 'package:monstershooting/widgets/monster_anim.dart';
import 'package:monstershooting/widgets/monster_dead.dart';
import 'package:monstershooting/widgets/monster_widget.dart';
import 'package:monstershooting/widgets/score_board.dart';
import 'package:monstershooting/widgets/shooting_banner.dart';
import 'package:rive/rive.dart';

class GamePage extends StatefulWidget {
  static const String route = '/game';
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MonsterAnimWidget(
            monsterAnimation: MonsterAnimations.monsterbg,
            fit: Fit.cover,
          ),

          // Center(
          //   child: MonsterAnimWidget(
          //     monsterAnimation: MonsterAnimations.countdown,
          //     size: const Size(500, 500),
          //   ),
          // ),
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
