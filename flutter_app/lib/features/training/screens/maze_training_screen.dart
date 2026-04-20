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

  /// 생성 실패 시에만 사용하는 고정 미로 1종
  static const _fallbackMaze = <String>[
    '#######',
    '#S....#',
    '#.##..#',
    '#...#.#',
    '###.#.#',
    '#....G#',
    '#######',
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
    _initMaze();
  }

  void _initMaze() {
    for (var attempt = 0; attempt < 48; attempt++) {
      final g = _tryGenerateMaze(_rng);
      if (g == null) {
        continue;
      }
      _applyRows(g);
      if (_shortest >= 4 && _shortest < 999) {
        return;
      }
    }
    _applyRows(List<String>.from(_fallbackMaze));
  }

  void _regenerateMaze() {
    _initMaze();
    if (mounted) {
      setState(() {});
    }
  }

  /// DFS 백트래킹으로 통로를 파고, 시작·목표를 최단 경로가 길어지도록 둔다.
  List<String>? _tryGenerateMaze(Random rng) {
    final rowsH = 9 + rng.nextInt(3) * 2;
    final colsW = 11 + rng.nextInt(4) * 2;

    final m = List.generate(
      rowsH,
      (_) => List.generate(colsW, (_) => '#'),
    );

    void carve(int r, int c) {
      m[r][c] = '.';
      final dirs = <List<int>>[
        [0, 2],
        [0, -2],
        [2, 0],
        [-2, 0],
      ]..shuffle(rng);
      for (final d in dirs) {
        final nr = r + d[0];
        final nc = c + d[1];
        if (nr <= 0 || nr >= rowsH - 1 || nc <= 0 || nc >= colsW - 1) {
          continue;
        }
        if (m[nr][nc] == '#') {
          m[r + d[0] ~/ 2][c + d[1] ~/ 2] = '.';
          carve(nr, nc);
        }
      }
    }

    carve(1, 1);

    var sr = 1;
    var sc = 1;
    if (m[sr][sc] != '.') {
      var found = false;
      for (var r = 1; r < rowsH - 1 && !found; r++) {
        for (var c = 1; c < colsW - 1; c++) {
          if (m[r][c] == '.') {
            sr = r;
            sc = c;
            found = true;
            break;
          }
        }
      }
      if (!found) {
        return null;
      }
    }

    final q = Queue<List<int>>();
    final dist = <String, int>{};
    q.add([sr, sc]);
    dist['$sr,$sc'] = 0;
    while (q.isNotEmpty) {
      final cur = q.removeFirst();
      final r = cur[0];
      final c = cur[1];
      final d0 = dist['$r,$c']!;
      for (final n in <List<int>>[
        [r - 1, c],
        [r + 1, c],
        [r, c - 1],
        [r, c + 1],
      ]) {
        final nr = n[0];
        final nc = n[1];
        if (nr < 0 || nr >= rowsH || nc < 0 || nc >= colsW) {
          continue;
        }
        if (m[nr][nc] != '.') {
          continue;
        }
        final k = '$nr,$nc';
        if (dist.containsKey(k)) {
          continue;
        }
        dist[k] = d0 + 1;
        q.add([nr, nc]);
      }
    }

    var gr = sr;
    var gc = sc;
    var best = 0;
    for (var r = 0; r < rowsH; r++) {
      for (var c = 0; c < colsW; c++) {
        if (m[r][c] != '.') {
          continue;
        }
        final d = dist['$r,$c'];
        if (d != null && d > best) {
          best = d;
          gr = r;
          gc = c;
        }
      }
    }

    if (best < 3 || (gr == sr && gc == sc)) {
      return null;
    }

    m[sr][sc] = 'S';
    m[gr][gc] = 'G';
    return m.map((row) => row.join()).toList();
  }

  void _applyRows(List<String> rows) {
    _rows = rows;
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
      appBar: AppBar(
        title: Text(l10n.mazeAppBar),
        actions: [
          IconButton(
            tooltip: l10n.mazeNewPuzzle,
            icon: const Icon(Icons.refresh),
            onPressed: _regenerateMaze,
          ),
        ],
      ),
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
