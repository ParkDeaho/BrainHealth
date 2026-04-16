import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:braintrain_flutter/l10n/app_localizations.dart';

import '../../core/services/test_record_events.dart';
import '../../domain/models/analysis_result.dart';
import '../../domain/services/today_analysis_service.dart';
import '../mind_check/mind_check_notifier.dart';
import '../mind_check/mind_check_page.dart';
import '../tests/screens/reaction_screen.dart';
import '../training/screens/maze_training_screen.dart';
import '../training/screens/numeracy_training_screen.dart';
import '../training/screens/shadow_match_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  AnalysisResult? _analysis;

  @override
  void initState() {
    super.initState();
    TestRecordEvents.bump.addListener(_onTestsRecorded);
    Future.microtask(_loadAnalysis);
  }

  @override
  void dispose() {
    TestRecordEvents.bump.removeListener(_onTestsRecorded);
    super.dispose();
  }

  void _onTestsRecorded() {
    if (mounted) {
      Future.microtask(_loadAnalysis);
    }
  }

  Future<void> _loadAnalysis() async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    final db = ref.read(appDatabaseProvider);
    final result = await TodayAnalysisService.load(db, l10n);
    if (!mounted) return;
    setState(() => _analysis = result);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data = _analysis;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabHome)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              title: Text(l10n.mindRecordTitle),
              subtitle: Text(l10n.mindRecordSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const MindCheckPage(),
                  ),
                );
                await _loadAnalysis();
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
            child: ListTile(
              leading: Text(
                '⚡',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              title: Text(l10n.reactionShortcutTitle),
              subtitle: Text(l10n.reactionShortcutSubtitle),
              trailing: const Icon(Icons.play_arrow),
              onTap: () async {
                await Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ReactionScreen(),
                  ),
                );
                await _loadAnalysis();
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.homeQuickMeasureTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  leading: const Text('🔢', style: TextStyle(fontSize: 22)),
                  title: Text(l10n.trainNumeracyTitle),
                  subtitle: Text(l10n.homeQuickMeasureNumeracySubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const NumeracyTrainingScreen(),
                      ),
                    );
                    await _loadAnalysis();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  dense: true,
                  leading: const Text('👤', style: TextStyle(fontSize: 22)),
                  title: Text(l10n.trainShadowTitle),
                  subtitle: Text(l10n.homeQuickMeasureShadowSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const ShadowMatchScreen(),
                      ),
                    );
                    await _loadAnalysis();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  dense: true,
                  leading: const Text('🧭', style: TextStyle(fontSize: 22)),
                  title: Text(l10n.trainMazeTitle),
                  subtitle: Text(l10n.homeQuickMeasureMazeSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const MazeTrainingScreen(),
                      ),
                    );
                    await _loadAnalysis();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (data != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  data.summaryText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  data.recommendationText,
                  style: const TextStyle(height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '${l10n.flowCardTitlePrefix}${data.fortuneText}',
                  style: const TextStyle(height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.wellnessSectionTitle,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _HomeTag(
                          pillLabel: l10n.pillDementia,
                          score: data.dementiaPreventionScore,
                          color: const Color(0xFF5C6BC0),
                          l10n: l10n,
                        ),
                        _HomeTag(
                          pillLabel: l10n.pillLearning,
                          score: data.learningAbilityScore,
                          color: const Color(0xFF26A69A),
                          l10n: l10n,
                        ),
                        _HomeTag(
                          pillLabel: l10n.pillEmotional,
                          score: data.emotionalWellbeingScore,
                          color: const Color(0xFF9575CD),
                          l10n: l10n,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.reportDisclaimer,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.3,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ] else
            Text(
              l10n.reportNoData,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
        ],
      ),
    );
  }
}

class _HomeTag extends StatelessWidget {
  const _HomeTag({
    required this.pillLabel,
    required this.score,
    required this.color,
    required this.l10n,
  });

  final String pillLabel;
  final double? score;
  final Color color;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final has = score != null;
    return Chip(
      visualDensity: VisualDensity.compact,
      avatar: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: Text(
          has ? '${score!.round()}' : '—',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
      label: Text(has ? pillLabel : l10n.pillNoTestToday(pillLabel)),
    );
  }
}
