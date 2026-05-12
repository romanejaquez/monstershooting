import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstershooting/helpers/constants.dart';
import 'package:monstershooting/helpers/enums.dart';
import 'package:monstershooting/providers/game_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────────────────────

const _kSpawnAnimations = [
  MonsterAnimations.purple,
  MonsterAnimations.red,
  MonsterAnimations.orange,
  MonsterAnimations.green,
  MonsterAnimations.blue,
];

/// Four speeds ordered fastest → slowest (index 0 = fastest).
const _kSpeeds = [
  Duration(seconds: 3),
  Duration(seconds: 5),
  Duration(seconds: 7),
  Duration(seconds: 9),
];

/// 1-px horizontal gap between lanes.
const double _kSpacing = 1.0;

// ─────────────────────────────────────────────────────────────────────────────
// Per-lane state
// ─────────────────────────────────────────────────────────────────────────────

class _LaneState {
  final String id;
  final DateTime spawnedAt;
  final Duration speed;

  /// Index into [_kSpeeds]. Higher index = slower. The next monster in this
  /// lane must have a speed index >= this value (same or slower).
  final int speedIndex;

  _LaneState({
    required this.id,
    required this.spawnedAt,
    required this.speed,
    required this.speedIndex,
  });

  /// Current top-of-monster Y position on screen.
  double currentTop(double screenHeight) {
    final elapsed =
        DateTime.now().difference(spawnedAt).inMilliseconds.toDouble();
    final startTop = -(Constants.monsterHeight - 1.0);
    final endTop = screenHeight + 1.0;
    final progress = (elapsed / speed.inMilliseconds).clamp(0.0, 1.0);
    return startTop + (endTop - startTop) * progress;
  }

  /// A new monster may enter the lane once this one has cleared at least
  /// (monsterHeight + 1 px) from the entry point so there is a 1-px gap.
  /// Entry point top = -(monsterHeight-1), new monster bottom at entry = 1.
  /// So we need currentTop >= 1 + 1 = 2.
  bool canAcceptNew(double screenHeight) => currentTop(screenHeight) >= 2.0;
}

// ─────────────────────────────────────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────────────────────────────────────

class MonsterSpawningService {
  MonsterSpawningService(this.ref);

  final Ref ref;
  final _rng = Random();

  Timer? _spawnTimer;
  bool _isRunning = false;

  double _screenWidth = 0;
  double _screenHeight = 0;

  int _idCounter = 0;
  String _nextId() => 'monster_${_idCounter++}';

  /// Per-lane ordered queue: index 0 = oldest (furthest down screen),
  /// last = newest (most recently entered, closest to top).
  final Map<double, List<_LaneState>> _laneQueues = {};

  /// Maps monster id → lane left so timers can look up the lane on removal.
  final Map<String, double> _monsterToLane = {};

  // ── public API ──────────────────────────────────────────────────────────────

  void setScreenSize(double width, double height) {
    _screenWidth = width;
    _screenHeight = height;
  }

  void startSpawning() {
    if (_isRunning) return;
    _isRunning = true;
    _scheduleNext();
  }

  void stopSpawning() {
    _isRunning = false;
    _spawnTimer?.cancel();
    _spawnTimer = null;
    _laneQueues.clear();
    _monsterToLane.clear();
    ref.read(activeMonsterProvider.notifier).clear();
    ref.read(activeDeadMonsterProvider.notifier).clear();
  }

  // ── spawn loop ──────────────────────────────────────────────────────────────

  void _scheduleNext() {
    if (!_isRunning) return;
    final spawned = _trySpawnOne();
    // If all lanes were blocked try again quickly; otherwise wait a bit.
    final ms = spawned ? 200 + _rng.nextInt(300) : 100;
    _spawnTimer = Timer(Duration(milliseconds: ms), _scheduleNext);
  }

  bool _trySpawnOne() {
    final result = _pickLane();
    if (result == null) return false;

    final lane = result.left;
    final minSpeedIdx = result.minSpeedIndex;

    // Pick a speed >= minSpeedIdx (same or slower than the one ahead).
    final validIndices = List.generate(
      _kSpeeds.length - minSpeedIdx,
      (i) => i + minSpeedIdx,
    );
    final speedIdx = validIndices[_rng.nextInt(validIndices.length)];
    final speed = _kSpeeds[speedIdx];
    final animation = _kSpawnAnimations[_rng.nextInt(_kSpawnAnimations.length)];
    final id = _nextId();

    final laneState = _LaneState(
      id: id,
      spawnedAt: DateTime.now(),
      speed: speed,
      speedIndex: speedIdx,
    );

    _laneQueues.putIfAbsent(lane, () => []).add(laneState);
    _monsterToLane[id] = lane;

    ref.read(activeMonsterProvider.notifier).addMonster(
      MonsterEntry(id: id, animation: animation, left: lane, speed: speed),
    );

    // Auto-remove once the monster travels off the bottom.
    Timer(speed, () {
      if (!_isRunning) return;
      _removeMonster(id, lane);
    });

    return true;
  }

  // ── lane selection ──────────────────────────────────────────────────────────

  _LanePickResult? _pickLane() {
    if (_screenWidth <= 0) return null;

    final laneWidth = Constants.monsterWidth + _kSpacing;
    final maxLanes = (_screenWidth / laneWidth).floor();
    if (maxLanes <= 0) return null;

    final candidates = <_LanePickResult>[];
    for (int i = 0; i < maxLanes; i++) {
      final left = i * laneWidth;
      final queue = _laneQueues[left];

      if (queue == null || queue.isEmpty) {
        // Lane is totally free — any speed allowed.
        candidates.add(_LanePickResult(left: left, minSpeedIndex: 0));
      } else {
        final latest = queue.last; // the one closest to the top
        if (latest.canAcceptNew(_screenHeight)) {
          candidates.add(
            _LanePickResult(left: left, minSpeedIndex: latest.speedIndex),
          );
        }
      }
    }

    if (candidates.isEmpty) return null;
    candidates.shuffle(_rng);
    return candidates.first;
  }

  // ── removal ─────────────────────────────────────────────────────────────────

  void _removeMonster(String id, double lane) {
    _monsterToLane.remove(id);
    final queue = _laneQueues[lane];
    if (queue != null) {
      queue.removeWhere((s) => s.id == id);
      if (queue.isEmpty) _laneQueues.remove(lane);
    }
    ref.read(activeMonsterProvider.notifier).removeMonster(id);
  }

  // ── tap / kill ──────────────────────────────────────────────────────────────

  void onMonsterTapped(String id, double lane, Offset tapPosition) {
    if (!_isRunning) return;
    _removeMonster(id, lane);

    ref.read(gameScoreProvider.notifier).addGameScore(100);

    final deadId = 'dead_${_idCounter++}';
    ref
        .read(activeDeadMonsterProvider.notifier)
        .addDead(DeadMonsterEntry(id: deadId, position: tapPosition));

    Timer(const Duration(milliseconds: 1500), () {
      ref.read(activeDeadMonsterProvider.notifier).removeDead(deadId);
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal result type
// ─────────────────────────────────────────────────────────────────────────────

class _LanePickResult {
  final double left;
  final int minSpeedIndex;
  const _LanePickResult({required this.left, required this.minSpeedIndex});
}
