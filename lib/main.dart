import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/pages/final_score_page.dart';
import 'package:monstershooting/pages/game_page.dart';
import 'package:monstershooting/pages/home_page.dart';
import 'package:monstershooting/pages/select_game_mode_page.dart';
import 'package:monstershooting/pages/splash_page.dart';
import 'package:monstershooting/widgets/global_crosshair_wrapper.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Comic Kings",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      builder: (context, child) {
        return GlobalCrosshairWrapper(child: child!);
      },
      initialRoute: SplashPage.route,
      routes: {
        SplashPage.route: (context) => const SplashPage(),
        HomePage.route: (context) => const HomePage(),
        SelectGameModePage.route: (context) => const SelectGameModePage(),
        GamePage.route: (context) => const GamePage(),
        FinalScorePage.route: (context) => const FinalScorePage(),
      },
    );
  }
}
