import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/locale/locale_provider.dart';
import '../core/storage/app_prefs.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/shell/main_shell.dart';
import '../l10n/app_localizations.dart';

/// 온보딩 여부를 불러온 뒤 [MainShell] 또는 [OnboardingPage]를 표시합니다.
class BrainTrainApp extends ConsumerStatefulWidget {
  const BrainTrainApp({super.key});

  @override
  ConsumerState<BrainTrainApp> createState() => _BrainTrainAppState();
}

class _BrainTrainAppState extends ConsumerState<BrainTrainApp> {
  bool _loading = true;
  bool _onboarded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    await ref.read(localeProvider.notifier).hydrate();
    final done = await AppPrefs.isOnboarded();
    if (!mounted) return;
    setState(() {
      _onboarded = done;
      _loading = false;
    });
  }

  void _onOnboardingComplete() {
    setState(() => _onboarded = true);
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      locale: locale,
      navigatorObservers: [
        if (Firebase.apps.isNotEmpty)
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6C63FF),
        brightness: Brightness.light,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: _loading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : _onboarded
              ? const MainShell()
              : OnboardingPage(onComplete: _onOnboardingComplete),
    );
  }
}
