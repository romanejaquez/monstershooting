import 'package:flutter/material.dart';
import 'package:monstershooting/helpers/constants.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/widgets/monster_anim.dart';

class MonsterWidget extends StatefulWidget {
  final String monsterId;
  final MonsterAnimations monsterAnimation;

  /// Horizontal left position on the mob surface.
  final double laneLeft;

  /// Called when the user taps this monster, with the global tap position.
  final void Function(Offset tapPosition)? onTapped;

  const MonsterWidget({
    super.key,
    required this.monsterId,
    required this.monsterAnimation,
    required this.laneLeft,
    this.onTapped,
  });

  @override
  State<MonsterWidget> createState() => MonsterWidgetState();
}

class MonsterWidgetState extends State<MonsterWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        widget.onTapped?.call(details.globalPosition);
      },
      child: MonsterAnimWidget(
        size: Size(Constants.monsterWidth, Constants.monsterHeight),
        monsterAnimation: widget.monsterAnimation,
      ),
    );
  }
}
