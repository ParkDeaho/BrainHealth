import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 단어 기억 — 기억한 3단어에 포함되는지 O/X (3문항)
class WordMemoryScreen extends ConsumerStatefulWidget {
  const WordMemoryScreen({super.key});

  @override
  ConsumerState<WordMemoryScreen> createState() => _WordMemoryScreenState();
}

class _WordMemoryScreenState extends ConsumerState<WordMemoryScreen> {
  static const _pool = ['사과', '책', '바다', '별', '나무', '구름', '시계', '연필'];
  late List<String> _target;
  int _phase = 0;
  int _qIndex = 0;
  int _correct = 0;
  final _rng = Random();
  late String _currentWord;

  @override
  void initState() {
    super.initState();
    final p = List<String>.from(_pool)..shuffle(_rng);
    _target = p.take(3).toList();
  }

  void _nextWord() {
    _currentWord = _pool[_rng.nextInt(_pool.length)];
  }

  Future<void> _finish(int pct) async {
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(db, testType: 'memory', normalizedScore: pct.toDouble());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('기록 저장됨 · 점수 $pct')),
    );
    Navigator.pop(context);
  }

  void _answer(bool saidIncluded) {
    final inList = _target.contains(_currentWord);
    if (saidIncluded == inList) _correct++;
    _qIndex++;
    if (_qIndex >= 3) {
      final pct = ((_correct / 3) * 100).round();
      _finish(pct);
      return;
    }
    setState(_nextWord);
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('단어 기억')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('아래 세 단어를 기억하세요.', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              ..._target.map((w) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(w, textAlign: TextAlign.center, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  )),
              const Spacer(),
              FilledButton(
                onPressed: () => setState(() {
                  _phase = 1;
                  _nextWord();
                }),
                child: const Text('기억했어요'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('단어 기억')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('이 단어가 방금 목록에 있었나요? (${_qIndex + 1}/3)', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Text(_currentWord, textAlign: TextAlign.center, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => _answer(true),
                    child: const Text('있었음'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _answer(false),
                    child: const Text('없었음'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
