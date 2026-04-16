import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 3개 버튼이 순서대로 깜빡 → 같은 순서로 누르기
class SequenceMemoryScreen extends ConsumerStatefulWidget {
  const SequenceMemoryScreen({super.key});

  @override
  ConsumerState<SequenceMemoryScreen> createState() => _SequenceMemoryScreenState();
}

class _SequenceMemoryScreenState extends ConsumerState<SequenceMemoryScreen> {
  final _rng = Random();
  late List<int> _pattern;
  int _showIdx = -1;
  int _inputIdx = 0;
  bool _playing = true;

  @override
  void initState() {
    super.initState();
    _pattern = List.generate(4, (_) => _rng.nextInt(3));
    _play();
  }

  Future<void> _play() async {
    setState(() {
      _playing = true;
      _showIdx = -1;
    });
    await Future<void>.delayed(const Duration(milliseconds: 400));
    for (var i = 0; i < _pattern.length; i++) {
      if (!mounted) return;
      setState(() => _showIdx = _pattern[i]);
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      setState(() => _showIdx = -1);
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    if (!mounted) return;
    setState(() => _playing = false);
  }

  Future<void> _tap(int b) async {
    if (_playing) return;
    if (_pattern[_inputIdx] != b) {
      final db = ref.read(appDatabaseProvider);
      await TestResultRecorder.record(db, testType: 'memory', normalizedScore: 20);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('틀렸어요 · 기록 저장 · 20점')));
      Navigator.pop(context);
      return;
    }
    _inputIdx++;
    if (_inputIdx >= _pattern.length) {
      final db = ref.read(appDatabaseProvider);
      await TestResultRecorder.record(db, testType: 'memory', normalizedScore: 100);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('성공! 기록 저장 · 100점')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('시퀀스 기억')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_playing ? '순서를 보세요' : '같은 순서로 누르세요'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (b) {
              final lit = _showIdx == b;
              return Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: Material(
                    color: lit ? Colors.orange : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }),
          ),
          const Spacer(),
          if (!_playing)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (b) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: FilledButton(
                      onPressed: () => _tap(b),
                      child: Text('${b + 1}'),
                    ),
                  ),
                );
              }),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
