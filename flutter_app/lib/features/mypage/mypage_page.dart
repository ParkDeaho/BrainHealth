import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:braintrain_flutter/l10n/history_trends_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bootstrap.dart';
import '../../core/locale/locale_provider.dart';
import '../../core/storage/app_prefs.dart';
import '../../domain/services/history_trends_service.dart';
import '../local_ai/local_ai_chat_page.dart';
import '../mind_check/mind_check_notifier.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  String? _mode;
  bool _loading = true;
  HistoryTrendsResult? _trends;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    final m = await AppPrefs.getUserMode();
    final db = ref.read(appDatabaseProvider);
    final t = await HistoryTrendsService.load(db);
    if (!mounted) return;
    setState(() {
      _mode = m ?? 'general';
      _trends = t;
      _loading = false;
    });
  }

  String _modeLabel(AppLocalizations l10n, String? m) {
    switch (m) {
      case 'senior':
        return l10n.modeSenior;
      case 'student':
        return l10n.modeStudent;
      default:
        return l10n.modeGeneral;
    }
  }

  String _languageValue(Locale? locale) {
    if (locale == null) return 'system';
    return locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myPageTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.languageSetting),
                    trailing: DropdownButton<String>(
                      value: _languageValue(locale),
                      underline: const SizedBox.shrink(),
                      items: [
                        DropdownMenuItem(
                          value: 'system',
                          child: Text(l10n.languageSystem),
                        ),
                        DropdownMenuItem(
                          value: 'ko',
                          child: Text(l10n.languageKorean),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(l10n.languageEnglish),
                        ),
                      ],
                      onChanged: (v) async {
                        if (v == null) return;
                        if (v == 'system') {
                          await ref.read(localeProvider.notifier).setLocale(null);
                        } else {
                          await ref.read(localeProvider.notifier).setLocale(Locale(v));
                        }
                        if (context.mounted) await _load();
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.chat_bubble_outline),
                    title: Text(l10n.localAiMenuTitle),
                    subtitle: Text(l10n.localAiMenuSubtitle),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(
                          builder: (_) => const LocalAiChatPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.tune),
                    title: Text(l10n.selectedMode),
                    subtitle: Text(_modeLabel(l10n, _mode)),
                  ),
                  const Divider(),
                  Text(
                    l10n.trendsSectionTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (_trends != null)
                    _SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _trends!.localizedBullets(l10n)
                            .map(
                              (line) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(line, style: const TextStyle(height: 1.45)),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(l10n.appInfoTitle),
                    subtitle: Text(l10n.appInfoSubtitle),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(l10n.onboardingReplayTitle),
                          content: Text(l10n.onboardingReplayBody),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(l10n.cancel),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(l10n.confirm),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await AppPrefs.clearOnboardingForDebug();
                        if (!context.mounted) return;
                        bootstrap();
                      }
                    },
                    child: Text(l10n.onboardingReplayTitle),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
