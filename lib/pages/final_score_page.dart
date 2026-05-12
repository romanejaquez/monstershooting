import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/pages/home_page.dart';
import 'package:monstershooting/providers/game_providers.dart';
import 'package:monstershooting/widgets/final_score_page_widget.dart';

class FinalScorePage extends ConsumerStatefulWidget {
  static const String route = '/final-score';
  const FinalScorePage({super.key});

  @override
  ConsumerState<FinalScorePage> createState() => FinalScorePageState();
}

class FinalScorePageState extends ConsumerState<FinalScorePage> {
  void onRestart() {
    Navigator.of(
      context,
    ).popUntil((route) => route.settings.name == HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    final score = ref.watch(gameScoreProvider);
    return Scaffold(
      body: FinalScorePageWidget(onRestart: onRestart, score: score),
    );
  }
}
