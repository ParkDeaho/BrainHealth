import 'dart:async';
import 'dart:math';

import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 초록이 되면 최대한 빠르게 탭 (5회 평균 ms → 점수)
class ReactionScreen extends ConsumerStatefulWidget {
  const ReactionScreen({super.key});

  @override
  ConsumerState<ReactionScreen> createState() => _ReactionScreenState();
}

class _ReactionScreenState extends ConsumerState<ReactionScreen> {
  final _rng = Random();
  int _round = 0;
  int _waitMs = 0;
  bool _green = false;
  DateTime? _shown;
  final List<int> _times = [];
  Timer? _timer;

  /// 평균 반응시간(ms)을 0~100점으로 환산. 약 200ms대 만점 근처, 700ms대에도 하한 유지.
  static double _reactionMsToScore(double avgMs) {
    const best = 190.0;
    const worst = 720.0;
    const floor = 14.0;
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

  void _startRound() {
    _green = false;
    _waitMs = 800 + _rng.nextInt(2200);
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: _waitMs), () {
      if (!mounted) return;
      setState(() {
        _green = true;
        _shown = DateTime.now();
      });
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  Future<void> _tap() async {
    if (!_green || _shown == null) return;
    final ms = DateTime.now().difference(_shown!).inMilliseconds;
    _times.add(ms);
    _round++;
    if (_round >= 5) {
      final avg = _times.reduce((a, b) => a + b) / _times.length;
      // ms → 점수: 너무 빠른 오탭 방지·느린 반응도 체감 가능한 점수 유지 (0점만 나오는 구간 축소)
      final pct = _reactionMsToScore(avg).round().clamp(0, 100);
      final db = ref.read(appDatabaseProvider);
      await TestResultRecorder.record(
        db,
        testType: 'reaction',
        normalizedScore: pct.toDouble(),
        rawScore: avg,
      );
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.reactionSnackDone('${avg.round()}', '$pct')),
        ),
      );
      Navigator.pop(context);
      return;
    }
    _startRound();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reactionAppBar)),
      body: InkWell(
        onTap: _green ? _tap : null,
        child: Container(
          color: _green ? Colors.green.shade400 : Colors.grey.shade800,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Text(
            _green
                ? l10n.reactionTapWhenGreen
                : l10n.reactionWaitGreen('${_round + 1}'),
            style: const TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      ),
    );
  }
}
