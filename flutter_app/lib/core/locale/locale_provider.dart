import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/app_prefs.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null);

  Future<void> hydrate() async {
    final code = await AppPrefs.getLocaleCode();
    state = _toLocale(code);
  }

  Locale? _toLocale(String? code) {
    if (code == null || code.isEmpty) return null;
    switch (code) {
      case 'ko':
        return const Locale('ko');
      case 'en':
        return const Locale('en');
      default:
        return null;
    }
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      await AppPrefs.setLocaleCode(null);
    } else {
      await AppPrefs.setLocaleCode(locale.languageCode);
    }
    state = locale;
  }
}
