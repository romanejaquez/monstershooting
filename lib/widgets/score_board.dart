import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class ScoreBoardWidget extends ConsumerStatefulWidget {
  final double score;
  const ScoreBoardWidget({super.key, this.score = 0});

  @override
  ConsumerState<ScoreBoardWidget> createState() => ScoreBoardWidgetState();
}

class ScoreBoardWidgetState extends ConsumerState<ScoreBoardWidget> {
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
      stateMachineSelector: StateMachineSelector.byName('scoreboard'),
      artboardSelector: ArtboardSelector.byName('scoreboard'),
      riveFile!,
    );

    _instance = _controller!.dataBind(DataBind.auto());

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && widget.score != 0) {
      _instance!.string('score')!.value = widget.score.toInt().toString();
    }

    return _isLoaded
        ? RiveWidget(fit: Fit.contain, controller: _controller!)
        : const SizedBox.shrink();
  }
}
