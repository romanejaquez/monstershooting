import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/constants.dart';
import 'package:monstershooting/providers/game_providers.dart';
import 'package:monstershooting/widgets/monster_dead.dart';

class MonsterDeadSurface extends ConsumerWidget {
  const MonsterDeadSurface({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deadMonsters = ref.watch(activeDeadMonsterProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: deadMonsters.map((entry) {
        // Convert global position to local Stack coordinates.
        final box = context.findRenderObject() as RenderBox?;
        final localPos = box != null
            ? box.globalToLocal(entry.position)
            : entry.position;

        // Center the dead widget on the tap point.
        final left = localPos.dx - Constants.monsterWidth / 2;
        final top = localPos.dy - Constants.monsterHeight / 2;

        return Positioned(
          key: ValueKey(entry.id),
          left: left,
          top: top,
          child: SizedBox(
            width: Constants.monsterWidth,
            height: Constants.monsterHeight,
            child: const MonsterDeadWidget(),
          ),
        );
      }).toList(),
    );
  }
}
