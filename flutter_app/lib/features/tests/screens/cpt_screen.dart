import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 글자가 X일 때만 탭 (15회)
class CptScreen extends ConsumerStatefulWidget {
  const CptScreen({super.key});

  @override
  ConsumerState<CptScreen> createState() => _CptScreenState();
}

class _CptScreenState extends ConsumerState<CptScreen> {
  final _rng = Random();
  static final _letters =
      List.generate(26, (i) => String.fromCharCode(65 + i));
  int _i = 0;
  int _hits = 0;
  int _miss = 0;
  int _falseTap = 0;
  late String _letter;
  late bool _isX;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    _isX = _rng.nextDouble() < 0.35;
    if (_isX) {
      _letter = 'X';
    } else {
      do {
        _letter = _letters[_rng.nextInt(_letters.length)];
      } while (_letter == 'X');
    }
  }

  Future<void> _finish() async {
    final total = _hits + _miss;
    final pct = total == 0
        ? 0
        : (((_hits / total) * 70) + ((1 - _falseTap / 15) * 30)).round().clamp(0, 100);
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(db, testType: 'cpt', normalizedScore: pct.toDouble());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('기록 저장됨 · $pct점')));
    Navigator.pop(context);
  }

  void _tap() {
    if (_isX) {
      _hits++;
    } else {
      _falseTap++;
    }
    _step();
  }

  void _skip() {
    if (_isX) _miss++;
    _step();
  }

  void _step() {
    _i++;
    if (_i >= 15) {
      _finish();
      return;
    }
    setState(_next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('지속 집중 (CPT)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Text(
                'X가 나오면 「맞음」, 아니면 「건너뛰기」\n(${_i + 1}/15)',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              const Spacer(),
              Text(
                _letter,
                style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(58),
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _tap,
                    child: const Text(
                      '맞음 (X)',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(58),
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _skip,
                    child: const Text(
                      '건너뛰기',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
