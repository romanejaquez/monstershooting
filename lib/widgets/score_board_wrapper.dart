import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/providers/game_providers.dart';
import 'package:monstershooting/widgets/score_board.dart';

class ScoreBoardWrapper extends StatelessWidget {
  const ScoreBoardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 200,
      child: Consumer(
        builder: (context, ref, child) {
          double score = ref.watch(gameScoreProvider);
          return ScoreBoardWidget(score: score);
        },
      ),
    );
  }
}
