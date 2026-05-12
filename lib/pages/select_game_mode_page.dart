import 'package:flutter/material.dart';
import 'package:monstershooting/pages/game_page.dart';
import 'package:monstershooting/widgets/select_game_mode_widget.dart';

class SelectGameModePage extends StatefulWidget {
  static const String route = '/select-game-mode';
  const SelectGameModePage({super.key});

  @override
  _SelectGameModePageState createState() => _SelectGameModePageState();
}

class _SelectGameModePageState extends State<SelectGameModePage> {
  void onDone() {
    Navigator.pushNamed(context, GamePage.route);
  }

  void onGameModeSelected(GameMode gameMode) {
    debugPrint('game mode selected $gameMode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectGameModeWidget(
        onDone: onDone,
        onGameModeSelected: onGameModeSelected,
      ),
    );
  }
}
