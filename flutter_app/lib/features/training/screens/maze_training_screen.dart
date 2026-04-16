import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 격자 미로에서 목표까지 이동 — 시공간·경로 계획
class MazeTrainingScreen extends ConsumerStatefulWidget {
  const MazeTrainingScreen({super.key});

  @override
  ConsumerState<MazeTrainingScreen> createState() => _MazeTrainingScreenState();
}

class _MazeTrainingScreenState extends ConsumerState<MazeTrainingScreen> {
  final _rng = Random();

  static const _presets = <List<String>>[
    [
      '#######',
      '#S....#',
      '#.##..#',
      '#...#.#',
      '###.#.#',
      '#....G#',
      '#######',
    ],
    [
      '#########',
      '#S......#',
      '#.#####.#',
      '#.....#.#',
      '###.#.#.#',
      '#...#...#',
      '#.###.###',
      '#.....G.#',
      '#########',
    ],
  ];

  late List<String> _rows;
  int _pr = 1;
  int _pc = 1;
  int _gr = 1;
  int _gc = 1;
  int _moves = 0;
  int _shortest = 1;

  @override
  void initState() {
    super.initState();
    _loadPreset(_rng.nextInt(_presets.length));
  }

  bool _wall(int r, int c) {
    if (r < 0 || c < 0 || r >= _rows.length) {
      return true;
    }
    final row = _rows[r];
    if (c >= row.length) {
      return true;
    }
    return row[c] == '#';
  }

  void _loadPreset(int index) {
    _rows = List<String>.from(_presets[index % _presets.length]);
    _moves = 0;
    for (var r = 0; r < _rows.length; r++) {
      final line = _rows[r];
      for (var c = 0; c < line.length; c++) {
        if (line[c] == 'S') {
          _pr = r;
          _pc = c;
        }
        if (line[c] == 'G') {
          _gr = r;
          _gc = c;
        }
      }
    }
    _shortest = _bfsShortestFrom(_pr, _pc);
    setState(() {});
  }

  int _bfsShortestFrom(int sr, int sc) {
    final q = Queue<List<int>>();
    final seen = <String>{};
    q.add([sr, sc, 0]);
    seen.add('$sr,$sc');
    while (q.isNotEmpty) {
      final cur = q.removeFirst();
      final r = cur[0];
      final c = cur[1];
      final d = cur[2];
      if (r == _gr && c == _gc) {
        return d;
      }
      for (final n in <List<int>>[
        [r - 1, c],
        [r + 1, c],
        [r, c - 1],
        [r, c + 1],
      ]) {
        final nr = n[0];
        final nc = n[1];
        if (_wall(nr, nc)) {
          continue;
        }
        final key = '$nr,$nc';
        if (seen.contains(key)) {
          continue;
        }
        seen.add(key);
        q.add([nr, nc, d + 1]);
      }
    }
    return 999;
  }

  void _tryMove(int r, int c) {
    if (_wall(r, c)) {
      return;
    }
    if ((r - _pr).abs() + (c - _pc).abs() != 1) {
      return;
    }
    _moves++;
    _pr = r;
    _pc = c;
    if (_pr == _gr && _pc == _gc) {
      _win();
      return;
    }
    setState(() {});
  }

  Future<void> _win() async {
    final ratio = _shortest / _moves;
    final pct = (ratio * 100).clamp(15.0, 100.0);
    final score = pct.round().clamp(0, 100);
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(
      db,
      testType: 'maze',
      normalizedScore: score.toDouble(),
      rawScore: ratio * 100,
      accuracy: ratio.clamp(0.0, 1.0),
      detailJson: jsonEncode(<String, dynamic>{
        'moves': _moves,
        'shortest': _shortest,
      }),
    );
    if (!mounted) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.mazeSnackDone('$_moves', '$_shortest', '$score'),
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final cols = _rows[0].length;
    final rows = _rows.length;
    final gridAspect = cols / rows;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.mazeAppBar)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.mazeInstructions,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.35),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.mazeMoves('$_moves'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final mq = MediaQuery.sizeOf(context);
                    final cap = min(mq.shortestSide * 0.78, 380.0);
                    var w = min(constraints.maxWidth, cap);
                    var h = w / gridAspect;
                    if (h > constraints.maxHeight) {
                      h = constraints.maxHeight;
                      w = h * gridAspect;
                    }
                    final iconSize = (min(w / cols, h / rows) * 0.42).clamp(14.0, 22.0);

                    return Center(
                      child: SizedBox(
                        width: w,
                        height: h,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cols,
                          ),
                          itemCount: rows * cols,
                          itemBuilder: (context, i) {
                            final r = i ~/ cols;
                            final c = i % cols;
                            final ch = _rows[r][c];
                            final isWall = ch == '#';
                            final isGoal = r == _gr && c == _gc;
                            final isPlayer = r == _pr && c == _pc;
                            final walkable = !isWall;

                            return GestureDetector(
                              onTap: walkable ? () => _tryMove(r, c) : null,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: scheme.outlineVariant.withValues(alpha: 0.4),
                                  ),
                                  color: isWall
                                      ? scheme.surfaceContainerHighest
                                      : scheme.surface,
                                ),
                                child: Center(
                                  child: isWall
                                      ? null
                                      : isPlayer
                                          ? Icon(
                                              Icons.navigation,
                                              color: scheme.primary,
                                              size: iconSize,
                                            )
                                          : isGoal
                                              ? Icon(
                                                  Icons.flag,
                                                  color: scheme.tertiary,
                                                  size: iconSize,
                                                )
                                              : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
