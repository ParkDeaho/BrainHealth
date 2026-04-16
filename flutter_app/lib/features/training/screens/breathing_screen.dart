import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/test_result_recorder.dart';
import '../../mind_check/mind_check_notifier.dart';
import '../services/breath_mic_detector.dart';

/// 4회 호흡 가이드 + 마이크 피크로 호흡 횟수 감지 (미지원·거부 시 수동 탭)
class BreathingScreen extends ConsumerStatefulWidget {
  const BreathingScreen({super.key});

  @override
  ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends ConsumerState<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late BreathMicDetector _detector;
  int _cycle = 0;
  int _micBreaths = 0;
  int _manualBreaths = 0;
  bool _micMode = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _detector = BreathMicDetector(
      onBreath: () {
        if (!mounted) return;
        setState(() {
          if (_micBreaths < 24) {
            _micBreaths++;
          }
        });
      },
    );
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          _cycle++;
          if (_cycle >= 4) {
            _saveAndPop();
          } else {
            _c.forward(from: 0);
          }
        }
      });
    unawaited(_initMic());
    _c.forward();
  }

  Future<void> _initMic() async {
    if (!_detector.isSupported) {
      if (mounted) setState(() => _micMode = false);
      return;
    }
    final ok = await _detector.ensurePermission();
    if (!mounted) return;
    if (!ok) {
      setState(() => _micMode = false);
      return;
    }
    setState(() => _micMode = true);
    await _detector.start();
  }

  int get _effectiveBreaths {
    if (_micMode) {
      return _micBreaths.clamp(0, 4);
    }
    return _manualBreaths.clamp(0, 4);
  }

  double get _normalizedScore {
    final e = _effectiveBreaths.clamp(0, 4);
    return 52 + (e / 4.0 * 48);
  }

  Future<void> _saveAndPop() async {
    if (_saved) return;
    _saved = true;
    _c.stop();
    await _detector.stop();
    final db = ref.read(appDatabaseProvider);
    final detail = jsonEncode({
      'breathCountMic': _micBreaths,
      'breathCountManual': _manualBreaths,
      'breathCountEffective': _effectiveBreaths,
      'micMode': _micMode,
      'cyclesCompleted': _cycle.clamp(0, 4),
    });
    await TestResultRecorder.record(
      db,
      testType: 'breathing',
      normalizedScore: _normalizedScore,
      rawScore: _effectiveBreaths.toDouble(),
      detailJson: detail,
    );
    if (!mounted) return;
    final hint = _micMode
        ? '호흡 ${_effectiveBreaths.clamp(0, 4)}/4 반영 · 기록 저장'
        : '수동 호흡 ${_effectiveBreaths.clamp(0, 4)}/4 반영 · 기록 저장';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hint)));
    Navigator.pop(context);
  }

  void _tapManualBreath() {
    if (_micMode) return;
    setState(() {
      if (_manualBreaths < 4) {
        _manualBreaths++;
      }
    });
  }

  @override
  void dispose() {
    unawaited(_detector.stop());
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effective = _effectiveBreaths.clamp(0, 4);
    final roundLabel = (_cycle.clamp(0, 3) + 1);
    return Scaffold(
      appBar: AppBar(title: const Text('호흡 · 집중 회복')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$roundLabel/4 회', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                _micMode
                    ? '마이크로 호흡 피크 감지 · $effective / 4 (가이드에 맞추면 더 잘 잡혀요)'
                    : '수동: 내쉴 때마다 아래를 탭 · $effective / 4',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _c,
                builder: (context, _) {
                  final t = _c.value;
                  final inhale = t < 0.5;
                  final scale = inhale ? 0.7 + t * 0.6 : 1.3 - (t - 0.5) * 0.6;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade100,
                        border: Border.all(color: Colors.blue, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        inhale ? '들이쉼' : '내쉼',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),
              if (!_micMode)
                FilledButton.tonal(
                  onPressed: _tapManualBreath,
                  child: const Text('내쉼에 맞춰 탭'),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _saveAndPop,
                child: const Text('지금까지 완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
