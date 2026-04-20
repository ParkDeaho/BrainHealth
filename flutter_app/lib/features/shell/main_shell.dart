import 'dart:async';

import 'package:flutter/material.dart';

import 'package:braintrain_flutter/core/ads/interstitial_ad_helper.dart';
import 'package:braintrain_flutter/core/ads/shell_bottom_banner.dart';
import 'package:braintrain_flutter/l10n/app_localizations.dart';

import '../home/home_page.dart';
import '../mypage/mypage_page.dart';
import '../report/report_page.dart';
import '../tests/tests_hub_page.dart';
import '../training/training_hub_page.dart';

/// 하단 탭: 홈 / 측정 / 훈련 / 리포트 / 마이
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  /// 리포트 탭에서 전면을 실제로 띄운 뒤에는 같은 세션에서 반복 노출하지 않음.
  bool _interstitialConsumedForReportTab = false;

  Future<void> _maybeShowReportInterstitial() async {
    if (_interstitialConsumedForReportTab) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
    if (!mounted) {
      return;
    }
    final showed = InterstitialAdHelper.instance.showIfReady();
    if (showed) {
      _interstitialConsumedForReportTab = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titles = [
      l10n.tabHome,
      l10n.tabTests,
      l10n.tabTraining,
      l10n.tabReport,
      l10n.tabMy,
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          HomePage(),
          TestsHubPage(),
          TrainingHubPage(),
          ReportPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ShellBottomBanner(),
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) {
              setState(() => _index = i);
              if (i == 3) {
                unawaited(_maybeShowReportInterstitial());
              }
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: titles[0],
              ),
              NavigationDestination(
                icon: const Icon(Icons.science_outlined),
                selectedIcon: const Icon(Icons.science),
                label: titles[1],
              ),
              NavigationDestination(
                icon: const Icon(Icons.sports_esports_outlined),
                selectedIcon: const Icon(Icons.sports_esports),
                label: titles[2],
              ),
              NavigationDestination(
                icon: const Icon(Icons.bar_chart_outlined),
                selectedIcon: const Icon(Icons.bar_chart),
                label: titles[3],
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: titles[4],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
