import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/services.dart';

/// `flutter_tts` 미사용 — Windows 빌드 시 NuGet 불필요.
/// - Windows: PowerShell + System.Speech
/// - macOS: `say`
/// - Linux: `spd-say` / `espeak` 시도
/// - Android/iOS: [MethodChannel] `braintrain/tts` (MainActivity / AppDelegate)
class LocalTtsService {
  LocalTtsService._();

  static const MethodChannel _channel = MethodChannel('braintrain/tts');

  static Future<void> speak(String text) async {
    final t = text.trim();
    if (t.isEmpty) {
      return;
    }
    if (kIsWeb) {
      return;
    }
    if (Platform.isWindows) {
      await _speakWindows(t);
      return;
    }
    if (Platform.isMacOS) {
      await Process.run('say', [t]);
      return;
    }
    if (Platform.isLinux) {
      try {
        await Process.run('spd-say', [t]);
      } catch (_) {
        try {
          await Process.run('espeak', [t]);
        } catch (_) {}
      }
      return;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      await _channel.invokeMethod<void>('speak', t);
    }
  }

  static Future<void> stop() async {
    if (kIsWeb) {
      return;
    }
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        await _channel.invokeMethod<void>('stop');
      } catch (_) {}
    }
  }

  static Future<void> _speakWindows(String text) async {
    final dir = await Directory.systemTemp.createTemp('braintrain_tts_');
    final file = File('${dir.path}${Platform.pathSeparator}msg.txt');
    await file.writeAsString(text, encoding: utf8);
    final path = file.path.replaceAll("'", "''");
    // Load System.Speech explicitly (some Windows builds omit it from default load order).
    final code = await Process.run(
      'powershell',
      [
        '-NoProfile',
        '-ExecutionPolicy',
        'Bypass',
        '-Command',
        "Add-Type -AssemblyName System.Speech; "
            "\$s = New-Object System.Speech.Synthesis.SpeechSynthesizer; "
            "\$s.Speak((Get-Content -Raw -Encoding UTF8 '$path'))",
      ],
    );
    try {
      await dir.delete(recursive: true);
    } catch (_) {}
    if (code.exitCode != 0) {
      debugPrint('Windows TTS failed (exit ${code.exitCode}): ${code.stderr}');
    }
  }
}
