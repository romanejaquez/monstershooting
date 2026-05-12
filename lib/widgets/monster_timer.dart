import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/providers/game_providers.dart';

class MonsterTimer extends ConsumerWidget {
  const MonsterTimer({super.key});

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seconds = ref.watch(gameTimerProvider);
    final label = _format(seconds);

    return Stack(
      children: [
        // Shadow layer
        Transform.translate(
          offset: const Offset(0, 10),
          child: Container(
            margin: const EdgeInsets.only(left: 32),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .25),
              borderRadius: BorderRadius.circular(32),
            ),
            child: _timerRow(label, Colors.black),
          ),
        ),
        // Foreground layer
        Container(
          margin: const EdgeInsets.only(left: 32),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFD0FF00),
            borderRadius: BorderRadius.circular(32),
          ),
          child: _timerRow(label, Colors.black),
        ),
      ],
    );
  }

  Widget _timerRow(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer, size: 42, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 40,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
