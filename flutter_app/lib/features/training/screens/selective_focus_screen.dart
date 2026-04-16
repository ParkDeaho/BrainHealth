import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

/// 3×3 중 초록 칸만 탭 (5라운드)
class SelectiveFocusScreen extends ConsumerStatefulWidget {
  const SelectiveFocusScreen({super.key});

  @override
  ConsumerState<SelectiveFocusScreen> createState() => _SelectiveFocusScreenState();
}

class _SelectiveFocusScreenState extends ConsumerState<SelectiveFocusScreen> {
  final _rng = Random();
  int _round = 0;
  late int _green;
  int _ok = 0;

  @override
  void initState() {
    super.initState();
    _green = _rng.nextInt(9);
  }

  Future<void> _finish() async {
    final pct = ((_ok / 5) * 100).round();
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(db, testType: 'focus', normalizedScore: pct.toDouble());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('기록 저장됨 · $pct점')));
    Navigator.pop(context);
  }

  void _tap(int i) {
    if (i == _green) _ok++;
    _round++;
    if (_round >= 5) {
      _finish();
      return;
    }
    setState(() => _green = _rng.nextInt(9));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.sizeOf(context);
    final gridSide = (mq.shortestSide * 0.5).clamp(200.0, 280.0);
    const gap = 6.0;

    return Scaffold(
      appBar: AppBar(title: const Text('선택 집중')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '초록 칸만 누르세요 (${_round + 1}/5)',
                textAlign: TextAlign.center,
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
                            color: i == _green ? Colors.green.shade500 : Colors.red.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
