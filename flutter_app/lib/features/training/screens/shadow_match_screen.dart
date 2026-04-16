import 'dart:convert';
import 'dart:math';

import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 윤곽과 같은 모양의 그림자(채워진 실루엣) 찾기 — 시각 비교·문제 해결
class ShadowMatchScreen extends ConsumerStatefulWidget {
  const ShadowMatchScreen({super.key});

  @override
  ConsumerState<ShadowMatchScreen> createState() => _ShadowMatchScreenState();
}

class _ShapeSpec {
  const _ShapeSpec(this.outline, this.filled);
  final IconData outline;
  final IconData filled;
}

class _ShadowMatchScreenState extends ConsumerState<ShadowMatchScreen> {
  final _rng = Random();
  static const _total = 8;

  static const _shapes = <_ShapeSpec>[
    _ShapeSpec(Icons.circle_outlined, Icons.circle),
    _ShapeSpec(Icons.crop_square, Icons.square),
    _ShapeSpec(Icons.change_history, Icons.change_history),
    _ShapeSpec(Icons.star_border, Icons.star),
  ];

  int _round = 0;
  int _correct = 0;
  final List<int> _rtsMs = <int>[];
  DateTime? _shown;

  late int _targetIndex;
  late List<int> _order;

  @override
  void initState() {
    super.initState();
    _setupRound();
  }

  void _setupRound() {
    if (_round >= _total) {
      _finish();
      return;
    }
    _targetIndex = _rng.nextInt(_shapes.length);
    _order = List<int>.generate(_shapes.length, (i) => i)..shuffle(_rng);
    _shown = DateTime.now();
    setState(() {});
  }

  static double _speedFromMeanMs(double avg) {
    const fast = 1400.0;
    const slow = 5500.0;
    const floor = 15.0;
    if (avg <= fast) {
      return 100;
    }
    if (avg >= slow) {
      return floor;
    }
    final t = (avg - fast) / (slow - fast);
    return 100 - t * (100 - floor);
  }

  Future<void> _finish() async {
    final acc = _correct / _total;
    double speed = 48;
    if (_rtsMs.isNotEmpty) {
      final avg = _rtsMs.reduce((a, b) => a + b) / _rtsMs.length;
      speed = _speedFromMeanMs(avg.toDouble());
    }
    final pct = (acc * 100 * 0.65 + speed * 0.35).clamp(0.0, 100.0);
    final score = pct.round().clamp(0, 100);
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(
      db,
      testType: 'shadow',
      normalizedScore: score.toDouble(),
      rawScore: acc * 100,
      accuracy: acc,
      detailJson: jsonEncode(<String, dynamic>{
        'rounds': _total,
        'correct': _correct,
      }),
    );
    if (!mounted) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.shadowSnackDone('$_correct', '$_total', '$score'),
        ),
      ),
    );
    Navigator.pop(context);
  }

  void _tap(int shapeIndex) {
    if (_shown == null || _round >= _total) {
      return;
    }
    final ms = DateTime.now().difference(_shown!).inMilliseconds;
    if (shapeIndex == _targetIndex) {
      _correct++;
      _rtsMs.add(ms);
    }
    _round++;
    _setupRound();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    if (_round >= _total) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.shadowAppBar)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final target = _shapes[_targetIndex];
    final mq = MediaQuery.sizeOf(context);
    final targetIconSize = (mq.shortestSide * 0.12).clamp(44.0, 72.0);
    final pickIconSize = (mq.shortestSide * 0.085).clamp(32.0, 48.0);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shadowAppBar)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.shadowProgress('${_round + 1}', '$_total'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.shadowInstructions,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.35),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.shadowTargetLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Icon(
                target.outline,
                size: targetIconSize,
                color: scheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.shadowPickLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxGridSide = min(
                      constraints.maxWidth,
                      min(mq.shortestSide * 0.72, 320.0),
                    );
                    final gridH = min(
                      constraints.maxHeight,
                      maxGridSide * 0.92,
                    );
                    final aspect = (maxGridSide - 12) / (gridH - 12);

                    return Center(
                      child: SizedBox(
                        width: maxGridSide,
                        height: gridH,
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: aspect,
                          children: _order.map((ix) {
                            final s = _shapes[ix];
                            return Material(
                              color: scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () => _tap(ix),
                                borderRadius: BorderRadius.circular(12),
                                child: Center(
                                  child: Icon(
                                    s.filled,
                                    size: pickIconSize,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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
