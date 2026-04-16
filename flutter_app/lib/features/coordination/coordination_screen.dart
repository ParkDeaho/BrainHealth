import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/test_result_recorder.dart';
import '../mind_check/mind_check_notifier.dart';

enum _Phase { prepare, cue, settling }

/// 좌·우 구역을 구분해 탭하는 손–눈 협응 과제 (측정 / 훈련).
class CoordinationScreen extends ConsumerStatefulWidget {
  const CoordinationScreen({super.key, required this.isTraining});

  final bool isTraining;

  @override
  ConsumerState<CoordinationScreen> createState() => _CoordinationScreenState();
}

class _CoordinationScreenState extends ConsumerState<CoordinationScreen> {
  final _rng = Random();
  Timer? _timer;

  int _roundIndex = 0;
  int _hits = 0;
  final List<int> _rts = <int>[];

  _Phase _phase = _Phase.prepare;
  bool? _targetLeft;
  DateTime? _cueStart;

  int get _totalRounds => widget.isTraining ? 8 : 12;

  int get _timeoutMs => widget.isTraining ? 1150 : 950;

  static double _rtMsToScore(double avgMs) {
    const best = 260.0;
    const worst = 880.0;
    const floor = 12.0;
    if (avgMs <= best) {
      return 100;
    }
    if (avgMs >= worst) {
      return floor;
    }
    final t = (avgMs - best) / (worst - best);
    return 100 - t * (100 - floor);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _schedulePrepare());
  }

  void _schedulePrepare() {
    if (_roundIndex >= _totalRounds) {
      _completeSession();
      return;
    }
    setState(() {
      _phase = _Phase.prepare;
      _targetLeft = null;
      _cueStart = null;
    });
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 560), () {
      if (!mounted) {
        return;
      }
      final left = _rng.nextBool();
      setState(() {
        _phase = _Phase.cue;
        _targetLeft = left;
        _cueStart = DateTime.now();
      });
      _timer = Timer(Duration(milliseconds: _timeoutMs), _onTimeout);
    });
  }

  void _onTimeout() {
    if (!mounted || _phase != _Phase.cue) {
      return;
    }
    _finalizeRound(false, null);
  }

  void _onTapSide(bool tappedLeft) {
    if (_phase != _Phase.cue || _cueStart == null || _targetLeft == null) {
      return;
    }
    _timer?.cancel();
    final ms = DateTime.now().difference(_cueStart!).inMilliseconds;
    final ok = tappedLeft == _targetLeft;
    _finalizeRound(ok, ok ? ms : null);
  }

  void _finalizeRound(bool ok, int? ms) {
    if (_phase != _Phase.cue) {
      return;
    }
    if (ok && ms != null) {
      _hits++;
      _rts.add(ms);
    }
    _roundIndex++;
    setState(() {
      _phase = _Phase.settling;
      _targetLeft = null;
      _cueStart = null;
    });
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 200), () {
      if (!mounted) {
        return;
      }
      _schedulePrepare();
    });
  }

  Future<void> _completeSession() async {
    final rounds = _totalRounds;
    final acc = rounds == 0 ? 0.0 : _hits / rounds;
    double speedScore;
    if (_rts.isEmpty) {
      speedScore = 12;
    } else {
      final avg = _rts.reduce((a, b) => a + b) / _rts.length;
      speedScore = _rtMsToScore(avg);
    }
    final normalized =
        (acc * 100 * 0.58 + speedScore * 0.42).clamp(0.0, 100.0);
    final pct = normalized.round().clamp(0, 100);
    final avgMs = _rts.isEmpty
        ? 0
        : (_rts.reduce((a, b) => a + b) / _rts.length).round();
    final accPct = (acc * 100).round();

    final detail = jsonEncode(<String, dynamic>{
      'rounds': rounds,
      'hits': _hits,
      'training': widget.isTraining,
    });

    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(
      db,
      testType: 'coordination',
      normalizedScore: pct.toDouble(),
      rawScore: acc * 100,
      accuracy: acc,
      reactionTimeAvgMs: avgMs > 0 ? avgMs : null,
      detailJson: detail,
    );

    if (!mounted) {
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.coordinationSnackDone('$avgMs', '$accPct', '$pct'),
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    final leftHighlight = _phase == _Phase.cue && _targetLeft == true;
    final rightHighlight = _phase == _Phase.cue && _targetLeft == false;
    final cueActive = _phase == _Phase.cue;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.coordinationAppBar)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              l10n.coordinationInstructions,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
            ),
          ),
          Text(
            l10n.coordinationRoundProgress(
              '${min(_roundIndex + 1, _totalRounds)}',
              '$_totalRounds',
            ),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: leftHighlight
                            ? scheme.primaryContainer
                            : scheme.surfaceContainerHighest,
                        child: InkWell(
                          onTap: cueActive ? () => _onTapSide(true) : null,
                          child: Center(
                            child: cueActive && _targetLeft == true
                                ? Text(
                                    l10n.coordinationCueLeft,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: scheme.onPrimaryContainer,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        color: rightHighlight
                            ? scheme.primaryContainer
                            : scheme.surfaceContainerHighest,
                        child: InkWell(
                          onTap: cueActive ? () => _onTapSide(false) : null,
                          child: Center(
                            child: cueActive && _targetLeft == false
                                ? Text(
                                    l10n.coordinationCueRight,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w800,
                                      color: scheme.onPrimaryContainer,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_phase == _Phase.prepare)
                  Positioned.fill(
                    child: ColoredBox(
                      color: scheme.scrim.withValues(alpha: 0.25),
                      child: Center(
                        child: Text(
                          l10n.coordinationPrepare,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
