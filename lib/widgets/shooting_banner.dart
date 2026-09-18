import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:rive/rive.dart';

class ShootingBannerWidget extends ConsumerStatefulWidget {
  final MonsterAnimations anim;
  const ShootingBannerWidget({super.key, this.anim = MonsterAnimations.none});

  @override
  ConsumerState<ShootingBannerWidget> createState() =>
      ShootingBannerWidgetState();
}

class ShootingBannerWidgetState extends ConsumerState<ShootingBannerWidget> {
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
      stateMachineSelector: StateMachineSelector.byName('shootingbanner'),
      artboardSelector: ArtboardSelector.byName('shootingbanner'),
      riveFile!,
    );

    _instance = _controller!.dataBind(DataBind.auto());

    if (!mounted) return;
    setState(() {
      _isLoaded = true;
    });

    _triggerAnimation(null);
  }

  void _triggerAnimation(MonsterAnimations? oldAnim) {
    if (!_isLoaded || _instance == null) return;
    if (widget.anim != MonsterAnimations.none) {
      _instance?.trigger(widget.anim.name)?.trigger();
    }
  }

  @override
  void didUpdateWidget(covariant ShootingBannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.anim != oldWidget.anim) {
      _triggerAnimation(oldWidget.anim);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? RiveWidget(fit: Fit.contain, controller: _controller!)
        : const SizedBox.shrink();
  }
}
