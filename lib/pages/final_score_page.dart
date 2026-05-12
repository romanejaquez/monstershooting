import 'package:flutter/material.dart';
import 'package:monstershooting/pages/home_page.dart';
import 'package:monstershooting/widgets/final_score_page_widget.dart';

class FinalScorePage extends StatefulWidget {
  static const String route = '/final-score';
  const FinalScorePage({super.key});

  @override
  _FinalScorePageState createState() => _FinalScorePageState();
}

class _FinalScorePageState extends State<FinalScorePage> {
  void onRestart() {
    Navigator.of(
      context,
    ).popUntil((route) => route.settings.name == HomePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FinalScorePageWidget(onRestart: onRestart));
  }
}
