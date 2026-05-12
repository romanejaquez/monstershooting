import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monstershooting/widgets/monster_anim.dart';
import 'package:rive/rive.dart';

class WhackMonsterWidget extends StatefulWidget {
  final Function onReset;
  final Function onShot;

  final Size? size;
  final int showSpeed;
  final bool shoot;
  final MonsterAnimations monsterAnimation;
  final Fit fit;

  const WhackMonsterWidget({
    super.key,
    required this.monsterAnimation,
    required this.shoot,
    this.showSpeed = 1,
    this.size,
    this.fit = Fit.contain,
    required this.onReset,
    required this.onShot,
  });

  @override
  State<WhackMonsterWidget> createState() => _WhackMonsterWidgetState();
}

class _WhackMonsterWidgetState extends State<WhackMonsterWidget> {
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
      stateMachineSelector: StateMachineSelector.byName('whackmonster'),
      artboardSelector: ArtboardSelector.byName('whackmonster'),
      riveFile!,
    );

    _instance = _controller!.dataBind(DataBind.auto());

    _controller!.stateMachine.addEventListener((event) {
      if (event.name == 'shot') {
        widget.onShot();
      } else if (event.name == 'reset') {
        widget.onReset();
      }
    });

    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded) {
      _instance!.enumerator('monster')!.value = widget.monsterAnimation.name;

      if (!widget.shoot) {
        _instance!.trigger('show${widget.showSpeed}')!.trigger();
      } else {
        _instance!.trigger('shoot')!.trigger();
      }
    }

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
