import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:rive/rive.dart';

class SelectGameModeWidget extends ConsumerStatefulWidget {
  final Function onDone;
  final Function(GameMode) onGameModeSelected;
  const SelectGameModeWidget({
    super.key,
    required this.onDone,
    required this.onGameModeSelected,
  });

  @override
  ConsumerState<SelectGameModeWidget> createState() =>
      SelectGameModeWidgetState();
}

class SelectGameModeWidgetState extends ConsumerState<SelectGameModeWidget> {
  RiveWidgetController? _controller;
  ViewModelInstance? _instance;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRiveState();
  }

  void _loadRiveState() async {
    var fileBytes = await rootBundle.load(
      "./assets/animations/monstershooting.riv",
    );
    final riveFile = await File.decode(
      fileBytes.buffer.asUint8List(),
      riveFactory: Factory.rive,
    );

    _controller = RiveWidgetController(
      stateMachineSelector: StateMachineSelector.byName('selectgamemode'),
      artboardSelector: ArtboardSelector.byName('selectgamemode'),
      riveFile!,
    );

    _instance = _controller!.dataBind(DataBind.auto());

    _controller!.stateMachine.addEventListener((evt) {
      if (evt.name == 'done') {
        widget.onDone();
      } else if (evt.name == 'mob') {
        widget.onGameModeSelected(GameMode.mob);
      } else if (evt.name == 'whack') {
        widget.onGameModeSelected(GameMode.whack);
      }
    });

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? RiveWidget(fit: Fit.cover, controller: _controller!)
        : const SizedBox.shrink();
  }
}
