import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 글자 의미가 아니라 '색' 선택 (5문항)
class StroopScreen extends ConsumerStatefulWidget {
  const StroopScreen({super.key});

  @override
  ConsumerState<StroopScreen> createState() => _StroopScreenState();
}

class _StroopScreenState extends ConsumerState<StroopScreen> {
  static const _labels = ['빨강', '파랑', '초록'];
  static const _colors = [Colors.red, Colors.blue, Colors.green];
  final _rng = Random();
  int _i = 0;
  int _ok = 0;
  late int _wordIdx;
  late int _inkIdx;

  @override
  void initState() {
    super.initState();
    _roll();
  }

  void _roll() {
    _wordIdx = _rng.nextInt(3);
    do {
      _inkIdx = _rng.nextInt(3);
    } while (_inkIdx == _wordIdx);
  }

  Future<void> _finish() async {
    final pct = ((_ok / 5) * 100).round();
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(db, testType: 'stroop', normalizedScore: pct.toDouble());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('기록 저장됨 · $pct점')));
    Navigator.pop(context);
  }

  Future<void> _pick(int colorIdx) async {
    if (colorIdx == _inkIdx) _ok++;
    _i++;
    if (_i >= 5) {
      await _finish();
      return;
    }
    setState(_roll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스트룹')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Text(
                '글자가 아니라 이 글자의 색을 고르세요 (${_i + 1}/5)',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.35),
              ),
              const SizedBox(height: 28),
              Text(
                _labels[_wordIdx],
                style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: _colors[_inkIdx]),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(3, (c) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: _colors[c],
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(56),
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () => _pick(c),
                      child: Text(
                        _labels[c],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
