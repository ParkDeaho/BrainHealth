import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';

/// 마이크로 소리 피크를 잡아 호흡(내쉼)에 가까운 순간을 카운트합니다.
/// Android / iOS에서만 동작합니다.
class BreathMicDetector {
  BreathMicDetector({
    required this.onBreath,
    this.maxBreaths = 24,
  });

  final void Function() onBreath;
  final int maxBreaths;

  StreamSubscription<NoiseReading>? _sub;
  int _detected = 0;
  double _ema = 48;
  DateTime _lastBreath = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime? _warmupUntil;

  static const int _cooldownMs = 720;
  static const double _spikeAboveEma = 11;

  bool get isSupported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<bool> ensurePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> start() async {
    if (!isSupported) return;
    await stop();
    _warmupUntil = DateTime.now().add(const Duration(milliseconds: 900));
    final meter = NoiseMeter();
    _sub = meter.noise.listen((reading) {
      if (_detected >= maxBreaths) return;
      final now = DateTime.now();
      if (_warmupUntil != null && now.isBefore(_warmupUntil!)) {
        final m = reading.maxDecibel;
        _ema = 0.9 * _ema + 0.1 * m;
        return;
      }
      final m = reading.maxDecibel;
      _ema = 0.92 * _ema + 0.08 * m;
      if (m > _ema + _spikeAboveEma &&
          now.difference(_lastBreath).inMilliseconds > _cooldownMs) {
        _lastBreath = now;
        _detected++;
        onBreath();
      }
    });
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }
}
