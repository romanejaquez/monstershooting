import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class FinalScorePageWidget extends ConsumerStatefulWidget {
  final Function onRestart;
  final double score;
  const FinalScorePageWidget({
    super.key,
    required this.onRestart,
    required this.score,
  });

  @override
  ConsumerState<FinalScorePageWidget> createState() =>
      FinalScorePageWidgetState();
}

class FinalScorePageWidgetState extends ConsumerState<FinalScorePageWidget> {
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
      stateMachineSelector: StateMachineSelector.byName('finalscore'),
      artboardSelector: ArtboardSelector.byName('finalscore'),
      riveFile!,
    );

    _instance = _controller!.dataBind(DataBind.auto());

    _controller!.stateMachine.addEventListener((evt) {
      if (evt.name == 'onRestart') {
        widget.onRestart();
      }
    });

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded) {
      _instance!.string("score")!.value = widget.score.toInt().toString();
    }

    return _isLoaded
        ? RiveWidget(fit: Fit.cover, controller: _controller!)
        : const SizedBox.shrink();
  }
}
