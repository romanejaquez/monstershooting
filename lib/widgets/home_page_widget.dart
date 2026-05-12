import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class HomePageWidget extends ConsumerStatefulWidget {
  final Function onStart;
  const HomePageWidget({super.key, required this.onStart});

  @override
  ConsumerState<HomePageWidget> createState() => HomePageWidgetState();
}

class HomePageWidgetState extends ConsumerState<HomePageWidget> {
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
      stateMachineSelector: StateMachineSelector.byName('homescreen'),
      artboardSelector: ArtboardSelector.byName('homescreen'),
      riveFile!,
    );

    _instance = _controller!.dataBind(DataBind.auto());

    _controller!.stateMachine.addEventListener((evt) {
      if (evt.name == 'onStart') {
        widget.onStart();
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
