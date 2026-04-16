import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 1-back: 현재 도형이 바로 직전과 같은지 판단 (10회)
class NBackScreen extends ConsumerStatefulWidget {
  const NBackScreen({super.key});

  @override
  ConsumerState<NBackScreen> createState() => _NBackScreenState();
}

class _NBackScreenState extends ConsumerState<NBackScreen> {
  static const _shapes = ['⬛', '🔺', '⭕', '🔷'];
  final _rng = Random();
  late List<int> _seq;
  int _i = 0;
  int _ok = 0;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _seq = List.generate(11, (_) => _rng.nextInt(4));
  }

  Future<void> _finish() async {
    final pct = _total == 0 ? 0 : ((_ok / _total) * 100).round();
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(db, testType: 'focus', normalizedScore: pct.toDouble());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('기록 저장됨 · $pct점')));
    Navigator.pop(context);
  }

  void _answer(bool same) {
    final prev = _seq[_i - 1];
    final cur = _seq[_i];
    final isSame = prev == cur;
    _total++;
    if (same == isSame) _ok++;
    _i++;
    if (_i >= _seq.length) {
      _finish();
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_i == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('N-back (1-back)')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_shapes[_seq[0]], style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => setState(() => _i = 1),
                child: const Text('시작'),
              ),
            ],
          ),
        ),
      );
    }

    final cur = _seq[_i];
    return Scaffold(
      appBar: AppBar(title: const Text('N-back (1-back)')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('바로 직전과 같은가요? ($_i/${_seq.length - 1})'),
            const Spacer(),
            Text(_shapes[cur], style: const TextStyle(fontSize: 80)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton(onPressed: () => _answer(true), child: const Text('같음')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonal(onPressed: () => _answer(false), child: const Text('다름')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
