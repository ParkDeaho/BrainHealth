import 'package:shared_preferences/shared_preferences.dart';

/// 온보딩·모드 저장 (웹 프로필과 유사)
class AppPrefs {
  AppPrefs._();

  static const keyOnboarded = 'has_onboarded';
  static const keyMode = 'user_mode';
  static const keyLocale = 'app_locale';
  static const keyOllamaBaseUrl = 'ollama_base_url';
  static const keyOllamaModel = 'ollama_model';

  /// Ollama HTTP API (예: http://127.0.0.1:11434). 끝에 / 없음.
  static const defaultOllamaBaseUrl = 'http://127.0.0.1:11434';

  /// 로컬에 `ollama pull` 로 받은 모델명
  static const defaultOllamaModel = 'llama3.2';

  static Future<bool> isOnboarded() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(keyOnboarded) ?? false;
  }

  static Future<void> setOnboarded(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(keyOnboarded, value);
  }

  /// senior | student | general
  static Future<String?> getUserMode() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(keyMode);
  }

  static Future<void> setUserMode(String mode) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(keyMode, mode);
  }

  static Future<void> clearOnboardingForDebug() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(keyOnboarded);
  }

  /// null = 시스템 언어, 'ko' | 'en'
  static Future<String?> getLocaleCode() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(keyLocale);
  }

  static Future<void> setLocaleCode(String? code) async {
    final p = await SharedPreferences.getInstance();
    if (code == null || code.isEmpty) {
      await p.remove(keyLocale);
    } else {
      await p.setString(keyLocale, code);
    }
  }

  static Future<String> getOllamaBaseUrl() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(keyOllamaBaseUrl) ?? defaultOllamaBaseUrl;
  }

  static Future<void> setOllamaBaseUrl(String url) async {
    final p = await SharedPreferences.getInstance();
    final t = url.trim();
    if (t.isEmpty) {
      await p.remove(keyOllamaBaseUrl);
    } else {
      await p.setString(keyOllamaBaseUrl, t.replaceAll(RegExp(r'/$'), ''));
    }
  }

  static Future<String> getOllamaModel() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(keyOllamaModel) ?? defaultOllamaModel;
  }

  static Future<void> setOllamaModel(String model) async {
    final p = await SharedPreferences.getInstance();
    final t = model.trim();
    if (t.isEmpty) {
      await p.remove(keyOllamaModel);
    } else {
      await p.setString(keyOllamaModel, t);
    }
  }
}
