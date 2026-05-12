import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

enum MonsterAnimations {
  none,
  monsterbg,
  purple,
  red,
  orange,
  green,
  blue,
  countdown,
  monsterdead,
}

class MonsterAnimWidget extends StatefulWidget {
  final Size? size;
  final MonsterAnimations monsterAnimation;
  final Fit fit;

  const MonsterAnimWidget({
    super.key,
    required this.monsterAnimation,
    this.size,
    this.fit = Fit.contain,
  });

  @override
  State<MonsterAnimWidget> createState() => _MonsterAnimWidgetState();
}

class _MonsterAnimWidgetState extends State<MonsterAnimWidget> {
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
      stateMachineSelector: StateMachineSelector.byName(
        widget.monsterAnimation.name,
      ),
      artboardSelector: ArtboardSelector.byName(widget.monsterAnimation.name),
      riveFile!,
    );

    _instance = _controller!.dataBind(DataBind.auto());

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? widget.size == null
              ? RiveWidget(fit: widget.fit, controller: _controller!)
              : SizedBox(
                  width: widget.size?.width,
                  height: widget.size?.height,
                  child: RiveWidget(fit: widget.fit, controller: _controller!),
                )
        : const SizedBox.shrink();
  }
}
