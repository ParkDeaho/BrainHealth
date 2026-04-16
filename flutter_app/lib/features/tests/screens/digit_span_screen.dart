import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 숫자 4자리 표시 후 역순 입력
class DigitSpanScreen extends ConsumerStatefulWidget {
  const DigitSpanScreen({super.key});

  @override
  ConsumerState<DigitSpanScreen> createState() => _DigitSpanScreenState();
}

class _DigitSpanScreenState extends ConsumerState<DigitSpanScreen> {
  final _rng = Random();
  late String _digits;
  int _phase = 0;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _digits = List.generate(4, (_) => _rng.nextInt(10)).join();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final want = _digits.split('').reversed.join();
    final got = _controller.text.trim();
    final pct = want == got ? 100 : (want.length == got.length ? 30 : 0);
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(db, testType: 'memory', normalizedScore: pct.toDouble());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(want == got ? '정답! 저장됨 · 100점' : '기록 저장됨 · $pct점')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('숫자 역순')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('숫자를 거꾸로 입력하세요', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text(_digits, style: const TextStyle(fontSize: 40, letterSpacing: 8, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => setState(() => _phase = 1),
                  child: const Text('숨기고 입력하기'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('숫자 역순')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('거꾸로 입력'),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '예: 4321'),
              autofocus: true,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _submit, child: const Text('제출')),
          ],
        ),
      ),
    );
  }
}
