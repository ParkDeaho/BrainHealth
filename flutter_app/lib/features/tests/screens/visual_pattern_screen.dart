import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 3×3 격자에서 3칸 기억 후 똑같이 탭
class VisualPatternScreen extends ConsumerStatefulWidget {
  const VisualPatternScreen({super.key});

  @override
  ConsumerState<VisualPatternScreen> createState() => _VisualPatternScreenState();
}

class _VisualPatternScreenState extends ConsumerState<VisualPatternScreen> {
  final _rng = Random();
  late Set<int> _target;
  final Set<int> _picked = {};
  int _phase = 0;

  @override
  void initState() {
    super.initState();
    final all = List.generate(9, (i) => i)..shuffle(_rng);
    _target = all.take(3).toSet();
  }

  Future<void> _done() async {
    final match = _target.length == _picked.length && _target.every(_picked.contains);
    final pct = match ? 100 : 0;
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(db, testType: 'memory', normalizedScore: pct.toDouble());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('기록 저장됨 · $pct점')),
    );
    Navigator.pop(context);
  }

  void _tap(int i) {
    if (_phase == 0) return;
    setState(() {
      if (_picked.contains(i)) {
        _picked.remove(i);
      } else if (_picked.length < 3) {
        _picked.add(i);
      }
      if (_picked.length == 3) _done();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    // 한 화면에 3×3이 들어가도록 격자 한 변 길이 제한 (확대 방지)
    final gridSide = (mq.shortestSide * 0.52).clamp(200.0, 288.0);
    const gap = 6.0;

    return Scaffold(
      appBar: AppBar(title: const Text('시각 패턴')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _phase == 0 ? '잠깐 기억하세요' : '같은 칸 세 개를 누르세요',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: gridSide,
                height: gridSide,
                child: GridView.count(
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  mainAxisSpacing: gap,
                  crossAxisSpacing: gap,
                  children: List.generate(9, (i) {
                    return GestureDetector(
                      onTap: () => _tap(i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _phase == 0
                              ? (_target.contains(i) ? Colors.amber : Colors.grey.shade300)
                              : (_picked.contains(i) ? Colors.green.shade400 : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_phase == 0)
              FilledButton(
                onPressed: () => setState(() => _phase = 1),
                child: const Text('시작 — 칸 선택'),
              ),
          ],
        ),
      ),
    );
  }
}
