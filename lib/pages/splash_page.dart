import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:monstershooting/widgets/duupr_games_logo.dart';

class SplashPage extends StatefulWidget {
  static const String route = '/splash';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isCoreLogoLoaded = false;
  Timer splashPageTimer = Timer(0.seconds, () {});

  @override
  void initState() {
    super.initState();
    preloadFile();
  }

  Future<void> preloadFile() async {
    splashPageTimer = Timer(4.seconds, () {
      Navigator.pushNamed(context, '/home');
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
