import 'dart:math';

import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';

class CardMatchScreen extends ConsumerStatefulWidget {
  const CardMatchScreen({super.key});

  @override
  ConsumerState<CardMatchScreen> createState() => _CardMatchScreenState();
}

class _CardMatchScreenState extends ConsumerState<CardMatchScreen> {
  static const _icons = ['🍎', '🍌', '🍇', '🍊'];
  final _rng = Random();
  late List<int> _pairId;
  late List<bool> _face;
  late List<bool> _matched;
  int? _first;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _pairId = List.generate(8, (i) => i ~/ 2)..shuffle(_rng);
    _face = List.filled(8, false);
    _matched = List.filled(8, false);
  }

  Future<void> _win() async {
    final pct = (100 - (_moves - 8).clamp(0, 30)).clamp(40, 100);
    final db = ref.read(appDatabaseProvider);
    await TestResultRecorder.record(db, testType: 'memory', normalizedScore: pct.toDouble());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('완료! $_moves번 뒤집음 · 기록 저장 · $pct점')),
    );
    Navigator.pop(context);
  }

  void _tap(int i) {
    if (_matched[i] || _face[i]) return;
    if (_first == null) {
      setState(() {
        _face[i] = true;
        _first = i;
      });
      return;
    }
    if (_first == i) return;

    final a = _first!;
    setState(() {
      _face[i] = true;
      _moves++;
    });

    if (_pairId[a] == _pairId[i]) {
      setState(() {
        _matched[a] = true;
        _matched[i] = true;
        _first = null;
      });
      if (_matched.every((m) => m)) {
        _win();
      }
    } else {
      _first = null;
      Future.delayed(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        setState(() {
          _face[a] = false;
          _face[i] = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cardMatchTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const crossAxisCount = 4;
            const mainSpacing = 8.0;
            const crossSpacing = 8.0;
            final maxW = constraints.maxWidth;
            final maxH = constraints.maxHeight;
            final cellW =
                (maxW - crossSpacing * (crossAxisCount - 1)) / crossAxisCount;
            // 2행이 본문 높이에 맞도록 가로세로 비 조정 (width/height)
            final aspect = (2 * cellW / (maxH - mainSpacing)).clamp(0.45, 2.2);

            return GridView.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainSpacing,
              crossAxisSpacing: crossSpacing,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: aspect,
              children: List.generate(8, (i) {
                return GestureDetector(
                  onTap: () => _tap(i),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _matched[i]
                          ? Colors.green.shade100
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    child: LayoutBuilder(
                      builder: (context, c) {
                        final side = min(c.maxWidth, c.maxHeight);
                        // 카드(버튼) 짧은 변 기준으로 과일·물음표 크기 비율 맞춤
                        final fontSize = (side * 0.54).clamp(22.0, 96.0);
                        return Center(
                          child: Text(
                            (_face[i] || _matched[i])
                                ? _icons[_pairId[i]]
                                : '?',
                            style: TextStyle(
                              fontSize: fontSize,
                              height: 1.05,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
