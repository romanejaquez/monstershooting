import 'package:flutter/material.dart';
import 'package:monstershooting/pages/select_game_mode_page.dart';
import 'package:monstershooting/widgets/home_page_widget.dart';

class HomePage extends StatefulWidget {
  static const String route = '/home';
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void onStart() {
    Navigator.pushNamed(context, SelectGameModePage.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomePageWidget(onStart: onStart));
  }
}
