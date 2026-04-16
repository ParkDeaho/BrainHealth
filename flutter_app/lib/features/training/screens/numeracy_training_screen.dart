import 'dart:convert';
import 'dart:math';

import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 간단 덧셈·뺄셈으로 수리·계산 인지 자극
class NumeracyTrainingScreen extends ConsumerStatefulWidget {
  const NumeracyTrainingScreen({super.key});

  @override
  ConsumerState<NumeracyTrainingScreen> createState() =>
      _NumeracyTrainingScreenState();
}

class _NumeracyTrainingScreenState
    extends ConsumerState<NumeracyTrainingScreen> {
  final _rng = Random();
  static const _total = 10;

  int _round = 0;
  int _correct = 0;
  final List<int> _rtsMs = <int>[];
  DateTime? _shown;

  int _a = 2;
  int _b = 2;
  bool _subtract = false;
  int _answer = 4;
  List<int> _choices = <int>[];

  @override
  void initState() {
    super.initState();
    _nextQuestion();
  }

  void _nextQuestion() {
    if (_round >= _total) {
      _finish();
      return;
    }
    var a = 2 + _rng.nextInt(17);
    var b = 2 + _rng.nextInt(17);
    final subtract = _rng.nextBool();
    if (subtract && a < b) {
      final t = a;
      a = b;
      b = t;
    }
    _a = a;
    _b = b;
    _subtract = subtract;
    _answer = subtract ? a - b : a + b;

    final wrong = <int>{};
    while (wrong.length < 3) {
      final d = -12 + _rng.nextInt(25);
      if (d == 0) {
        continue;
      }
      final v = _answer + d;
      if (v > 0 && v < 100) {
        wrong.add(v);
      }
    }
    _choices = [_answer, ...wrong]..shuffle(_rng);
    _shown = DateTime.now();
    setState(() {});
  }

  static double _speedFromMeanMs(double avg) {
    const fast = 1800.0;
    const slow = 6500.0;
    const floor = 18.0;
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
    double speed = 45;
    if (_rtsMs.isNotEmpty) {
      final avg = _rtsMs.reduce((a, b) => a + b) / _rtsMs.length;
      speed = _speedFromMeanMs(avg.toDouble());
    }
    final pct = (acc * 100 * 0.62 + speed * 0.38).clamp(0.0, 100.0);
    final score = pct.round().clamp(0, 100);
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(
      db,
      testType: 'numeracy',
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
          l10n.numeracySnackDone('$_correct', '$_total', '$score'),
        ),
      ),
    );
    Navigator.pop(context);
  }

  void _pick(int v) {
    if (_shown == null || _round >= _total) {
      return;
    }
    final ms = DateTime.now().difference(_shown!).inMilliseconds;
    if (v == _answer) {
      _correct++;
      _rtsMs.add(ms);
    }
    _round++;
    _nextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_round >= _total) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.numeracyAppBar)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final expr = _subtract ? '$_a − $_b' : '$_a + $_b';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.numeracyAppBar)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.numeracyProgress('${_round + 1}', '$_total'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.numeracyInstructions,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  '$expr = ?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _choices
                  .map(
                    (n) => SizedBox(
                      width: 140,
                      child: FilledButton(
                        onPressed: () => _pick(n),
                        child: Text('$n'),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
