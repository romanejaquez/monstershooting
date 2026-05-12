import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class DuuprGamesLogo extends StatefulWidget {
  final bool defaultLogo;
  const DuuprGamesLogo({this.defaultLogo = false, super.key});

  @override
  State<DuuprGamesLogo> createState() => _DuuprGamesLogoState();
}

class _DuuprGamesLogoState extends State<DuuprGamesLogo> {
  String defaultLogoValue = '';
  Size defaultSize = const Size(400, 200);
  Size smallSize = const Size(250, 100);

  late File file;
  RiveWidgetController? controller;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() async {
    file = (await File.asset(
      './assets/animations/duuprgamestudio.riv',
      // Choose which renderer to use
      riveFactory: Factory.rive,
    ))!;
    controller = RiveWidgetController(
      artboardSelector: ArtboardSelector.byName('duuprgamestudiowhite'),
      stateMachineSelector: StateMachineSelector.byName('duuprgamestudiowhite'),
      file,
    );
    setState(() => isInitialized = true);
  }

  @override
  void dispose() {
    file.dispose();
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = defaultSize;

    return controller == null
        ? const SizedBox.shrink()
        : SizedBox(
            width: logoSize.width,
            height: logoSize.height,
            child: RiveWidget(controller: controller!, fit: Fit.contain),
          );
  }
}
