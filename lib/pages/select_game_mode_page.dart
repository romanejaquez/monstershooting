import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/pages/game_page.dart';
import 'package:monstershooting/providers/game_providers.dart';
import 'package:monstershooting/widgets/select_game_mode_widget.dart';

class SelectGameModePage extends ConsumerStatefulWidget {
  static const String route = '/select-game-mode';
  const SelectGameModePage({super.key});

  @override
  ConsumerState<SelectGameModePage> createState() => _SelectGameModePageState();
}

class _SelectGameModePageState extends ConsumerState<SelectGameModePage> {
  void onDone() {
    Navigator.pushNamed(context, GamePage.route);
  }

  void onGameModeSelected(GameMode gameMode) {
    ref.read(selectedGameModeProvider.notifier).setSelectedGameMode(gameMode);
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
