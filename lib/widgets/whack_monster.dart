import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monstershooting/helpers/constants.dart';
import 'package:monstershooting/helpers/enums.dart';
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
  bool _shotConsumed = false;
  bool _resetConsumed = false;

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
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (event.name == 'shot') {
          if (!_shotConsumed && widget.shoot) {
            _shotConsumed = true;
            widget.onShot();
          }
        } else if (event.name == 'reset') {
          if (!_resetConsumed &&
              !widget.shoot &&
              widget.monsterAnimation != MonsterAnimations.none) {
            _resetConsumed = true;
            widget.onReset();
          }
        }
      });
    });

    setState(() {
      _isLoaded = true;
    });
    // Trigger initial animation once loaded
    _triggerAnimation(null);
  }

  void _triggerAnimation(WhackMonsterWidget? oldWidget) {
    if (!_isLoaded || _instance == null) return;

    // Set monster color
    if (widget.monsterAnimation != MonsterAnimations.none) {
      _instance!.enumerator('monster')!.value = widget.monsterAnimation.name;
    }

    if (oldWidget == null) {
      // First load
      if (!widget.shoot && widget.monsterAnimation != MonsterAnimations.none) {
        _shotConsumed = false;
        _resetConsumed = false;
        _instance!.trigger('show${widget.showSpeed}')!.trigger();
      } else if (widget.shoot) {
        _shotConsumed = false;
        _instance!.trigger('shoot')!.trigger();
      }
    } else {
      // Update
      if (widget.monsterAnimation != MonsterAnimations.none &&
          oldWidget.monsterAnimation == MonsterAnimations.none) {
        // A new monster appeared
        _shotConsumed = false;
        _resetConsumed = false;
        _instance!.trigger('show${widget.showSpeed}')!.trigger();
      } else if (widget.shoot && !oldWidget.shoot) {
        // The monster was shot
        _shotConsumed = false;
        _instance!.trigger('shoot')!.trigger();
      }
    }
  }

  @override
  void didUpdateWidget(covariant WhackMonsterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.monsterAnimation != oldWidget.monsterAnimation ||
        widget.shoot != oldWidget.shoot) {
      _triggerAnimation(oldWidget);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Animation triggering is now handled in _triggerAnimation

    return _isLoaded
        ? SizedBox(
            width: Constants.monsterWidth,
            height: Constants.monsterHeight,
            child: RiveWidget(fit: widget.fit, controller: _controller!),
          )
        : const SizedBox.shrink();
  }
}
