import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monstershooting/providers/audio_providers.dart';

class GlobalCrosshairWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const GlobalCrosshairWrapper({super.key, required this.child});

  @override
  ConsumerState<GlobalCrosshairWrapper> createState() => _GlobalCrosshairWrapperState();
}

class _GlobalCrosshairWrapperState extends ConsumerState<GlobalCrosshairWrapper> {
  Offset _cursorPosition = Offset.zero;
  bool _isShooting = false;
  bool _isHovering = false;

  void _updatePosition(PointerEvent event) {
    setState(() {
      _cursorPosition = event.position;
      _isHovering = true;
    });
  }

  void _setShooting(bool isShooting) {
    setState(() {
      _isShooting = isShooting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: _updatePosition,
      onHover: _updatePosition,
      onExit: (event) => setState(() => _isHovering = false),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerHover: _updatePosition,
        onPointerMove: _updatePosition,
        onPointerDown: (event) {
          _setShooting(true);
          ref.read(gameAudioServiceProvider).shoot();
        },
        onPointerUp: (event) => _setShooting(false),
        child: Stack(
          children: [
            widget.child,
            if (_isHovering)
              Positioned(
                // Centering the crosshair (assuming 200x200 size)
                left: _cursorPosition.dx - 100, 
                top: _cursorPosition.dy - 100,
                child: IgnorePointer(
                  child: AnimatedScale(
                    scale: _isShooting ? 0.7 : 1.0, // Shrink slightly when clicking
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOutBack,
                    child: SvgPicture.asset(
                      'assets/svgs/crosshair.svg',
                      width: 200,
                      height: 200,
                      colorFilter: ColorFilter.mode(
                        _isShooting ? Colors.red : const Color(0xFF5EB737), // Turns red when clicking
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
