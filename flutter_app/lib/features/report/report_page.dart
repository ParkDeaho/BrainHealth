import 'dart:convert';

import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:braintrain_flutter/l10n/test_type_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/services/test_record_events.dart';
import '../../core/utils/date_utils.dart';
import '../../data/local/app_database.dart';
import '../../domain/models/analysis_result.dart';
import '../../domain/services/today_analysis_service.dart';
import '../mind_check/mind_check_notifier.dart';

/// 오늘 리포트 (마음 기록 + 측정 결합 해석 + 오늘 활동 목록)
class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  AnalysisResult? _result;
  List<TestResult> _todayTests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    TestRecordEvents.bump.addListener(_onTestsRecorded);
    Future.microtask(_load);
  }

  @override
  void dispose() {
    TestRecordEvents.bump.removeListener(_onTestsRecorded);
    super.dispose();
  }

  void _onTestsRecorded() {
    if (mounted) {
      Future.microtask(_load);
    }
  }

  Future<void> _load() async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    final db = ref.read(appDatabaseProvider);
    final dateKey = toDateKey(DateTime.now());
    final r = await TodayAnalysisService.load(db, l10n);
    final tests = await db.testResultDao.getResultsByDateNewestFirst(dateKey);
    if (!mounted) return;
    setState(() {
      _result = r;
      _todayTests = tests;
      _loading = false;
    });
  }

  String _timeLabel(DateTime t) => DateFormat('HH:mm').format(t);

  String? _breathingDetail(TestResult e, AppLocalizations l10n) {
    if (e.testType != 'breathing' || e.detailJson == null || e.detailJson!.isEmpty) {
      return null;
    }
    try {
      final m = jsonDecode(e.detailJson!) as Map<String, dynamic>;
      final n = m['breathCountEffective'];
      final mic = m['micMode'];
      if (n is num) {
        final mode = mic == true ? l10n.breathModeMic : l10n.breathModeManual;
        return l10n.reportBreathingDetail(n.toInt(), mode);
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabReport)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                children: [
                  if (_result != null) ...[
                    Text(
                      l10n.reportPillarsTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Pill(
                          label: l10n.pillMemory,
                          value: _result!.memoryScore.round(),
                          color: const Color(0xFF6C63FF),
                          l10n: l10n,
                        ),
                        _Pill(
                          label: l10n.pillFocus,
                          value: _result!.focusScore.round(),
                          color: const Color(0xFF00C9A7),
                          l10n: l10n,
                        ),
                        _Pill(
                          label: l10n.pillReaction,
                          value: _result!.reactionScore.round(),
                          color: const Color(0xFFFFB020),
                          l10n: l10n,
                        ),
                        _Pill(
                          label: l10n.pillCoordination,
                          value: _result!.coordinationScore.round(),
                          color: const Color(0xFFE57373),
                          empty: !_todayTests
                              .any((e) => e.testType == 'coordination'),
                          l10n: l10n,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.reportDetailPillarsTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Pill(
                          label: l10n.pillNumeracy,
                          value: _result!.numeracyScore.round(),
                          color: const Color(0xFF42A5F5),
                          empty: !_todayTests
                              .any((e) => e.testType == 'numeracy'),
                          l10n: l10n,
                        ),
                        _Pill(
                          label: l10n.pillReasoning,
                          value: _result!.reasoningScore.round(),
                          color: const Color(0xFFAB47BC),
                          empty:
                              !_todayTests.any((e) => e.testType == 'shadow'),
                          l10n: l10n,
                        ),
                        _Pill(
                          label: l10n.pillSpatial,
                          value: _result!.spatialScore.round(),
                          color: const Color(0xFF78909C),
                          empty: !_todayTests.any((e) => e.testType == 'maze'),
                          l10n: l10n,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.reportWellnessTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Pill(
                          label: l10n.pillDementia,
                          value: _result!.dementiaPreventionScore?.round() ?? 0,
                          color: const Color(0xFF5C6BC0),
                          empty: _result!.dementiaPreventionScore == null,
                          l10n: l10n,
                        ),
                        _Pill(
                          label: l10n.pillLearning,
                          value: _result!.learningAbilityScore?.round() ?? 0,
                          color: const Color(0xFF26A69A),
                          empty: _result!.learningAbilityScore == null,
                          l10n: l10n,
                        ),
                        _Pill(
                          label: l10n.pillEmotional,
                          value: _result!.emotionalWellbeingScore.round(),
                          color: const Color(0xFF9575CD),
                          l10n: l10n,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.reportDisclaimer,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: l10n.summaryCardTitle,
                      child: Text(
                        _result!.summaryText,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SectionCard(
                      title: l10n.recommendationCardTitle,
                      child: Text(
                        _result!.recommendationText,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SectionCard(
                      title: l10n.reportSectionFlow,
                      child: Text(
                        _result!.fortuneText,
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SectionCard(
                      title: l10n.reportDementiaSectionTitle,
                      child: Text(
                        l10n.reportDementiaSectionBody,
                        style: TextStyle(
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    l10n.reportActivityTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_todayTests.isEmpty)
                    Text(
                      l10n.reportActivityEmpty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    )
                  else
                    ..._todayTests.map(
                      (e) {
                        final breath = _breathingDetail(e, l10n);
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                '${e.normalizedScore.round()}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ),
                            title: Text(testTypeLabel(l10n, e.testType)),
                            subtitle: Text(
                              [
                                l10n.reportLineTimeScore(
                                  _timeLabel(e.createdAt),
                                  e.normalizedScore.round(),
                                ),
                                if (breath != null) breath,
                              ].join('\n'),
                            ),
                            trailing: e.testType == 'breathing'
                                ? const Icon(Icons.mic_none, size: 20)
                                : null,
                          ),
                        );
                      },
                    ),
                ],
              ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.value,
    required this.color,
    required this.l10n,
    this.empty = false,
  });

  final String label;
  final int value;
  final Color color;
  final AppLocalizations l10n;
  final bool empty;

  @override
  Widget build(BuildContext context) {
    final display = empty ? '—' : '$value';
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: Text(
          display,
          style: TextStyle(
            fontSize: empty ? 14 : 12,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
      label: Text(empty ? l10n.pillNoTestToday(label) : label),
    );
  }
}
