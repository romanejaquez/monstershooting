import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/constants.dart';
import 'package:monstershooting/providers/game_providers.dart';
import 'package:monstershooting/widgets/monster_widget.dart';

class MonsterMobSurface extends ConsumerWidget {
  const MonsterMobSurface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monsters = ref.watch(activeMonsterProvider);
    final screenSize = MediaQuery.sizeOf(context);
    final spawner = ref.read(monsterSpawningServiceProvider);

    // Starting top: 1 px above the screen (just the tip peeking in).
    final double startTop = -(Constants.monsterHeight - 1);

    // Ending top: monster fully off the bottom (+1 px past the bottom edge).
    final double endTop = screenSize.height + 1;

    return Stack(
      clipBehavior: Clip.none,
      children: monsters.map((entry) {
        return _AnimatedMonster(
          key: ValueKey(entry.id),
          entry: entry,
          startTop: startTop,
          endTop: endTop,
          onTapped: (tapPosition) {
            spawner.onMonsterTapped(entry.id, entry.left, tapPosition);
          },
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Internal: self-animating monster tile
// ---------------------------------------------------------------------------

class _AnimatedMonster extends StatefulWidget {
  final MonsterEntry entry;
  final double startTop;
  final double endTop;
  final void Function(Offset tapPosition) onTapped;

  const _AnimatedMonster({
    super.key,
    required this.entry,
    required this.startTop,
    required this.endTop,
    required this.onTapped,
  });

  @override
  State<_AnimatedMonster> createState() => _AnimatedMonsterState();
}

class _AnimatedMonsterState extends State<_AnimatedMonster>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _topAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.entry.speed,
    );

    _topAnim = Tween<double>(
      begin: widget.startTop,
      end: widget.endTop,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));

    // Start immediately so the monster enters at the exact moment it is added.
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _topAnim,
      builder: (context, child) {
        return Positioned(
          left: widget.entry.left,
          top: _topAnim.value,
          child: child!,
        );
      },
      child: MonsterWidget(
        monsterId: widget.entry.id,
        monsterAnimation: widget.entry.animation,
        laneLeft: widget.entry.left,
        onTapped: widget.onTapped,
      ),
    );
  }
}
