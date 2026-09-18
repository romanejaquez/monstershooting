import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/providers/audio_providers.dart';
import 'package:monstershooting/widgets/duupr_games_logo.dart';

class SplashPage extends ConsumerStatefulWidget {
  static const String route = '/splash';
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool isCoreLogoLoaded = false;
  Timer splashPageTimer = Timer(0.seconds, () {});

  @override
  void initState() {
    super.initState();
    preloadFile();
  }

  Future<void> preloadFile() async {
    // Start playing background music immediately from the launch screen
    ref.read(gameAudioServiceProvider).playBgMusic();

    // Preload all game sound assets upfront
    ref.read(soundPreloadServiceProvider).preloadSounds();

    splashPageTimer = Timer(4.seconds, () {
      if (mounted) {
        Navigator.pushNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      body: Center(child: DuuprGamesLogo(defaultLogo: true)),
    );
  }
}
