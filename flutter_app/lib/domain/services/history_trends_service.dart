import '../../data/local/app_database.dart';
import '../models/wellness_dimensions.dart';
import 'score_calculator.dart';

/// 날짜별 3대 지표 평균 (해당 날짜에 기록이 있는 유형만) + 참고 웰니스 지표
class DayPillarAverages {
  DayPillarAverages({
    required this.dateKey,
    required this.memory,
    required this.focus,
    required this.reaction,
    required this.coordination,
    required this.numeracy,
    required this.reasoning,
    required this.spatial,
    required this.dementiaHint,
    required this.learningHint,
    required this.emotionalHint,
  });

  final String dateKey;
  final double? memory;
  final double? focus;
  final double? reaction;
  final double? coordination;
  final double? numeracy;
  final double? reasoning;
  final double? spatial;
  final double? dementiaHint;
  final double? learningHint;
  final double? emotionalHint;
}

/// 저장된 측정·마음 기록으로 "처음 → 최근" 요약
class HistoryTrendsResult {
  HistoryTrendsResult({
    required this.totalTests,
    required this.distinctDays,
    required this.first,
    required this.last,
    required this.moodFirst,
    required this.moodLast,
    required this.dailyConditionDays,
  });

  final int totalTests;
  final int distinctDays;
  final int dailyConditionDays;
  final DayPillarAverages? first;
  final DayPillarAverages? last;
  final int? moodFirst;
  final int? moodLast;

  bool get canCompareDays =>
      distinctDays >= 2 && first != null && last != null && first!.dateKey != last!.dateKey;
}

class HistoryTrendsService {
  HistoryTrendsService._();

  static const _memoryTypes = ['memory'];
  static const _focusTypes = ['focus', 'breathing', 'stroop', 'cpt'];
  static const _reactionTypes = ['reaction'];
  static const _coordinationTypes = ['coordination'];
  static const _numeracyTypes = ['numeracy'];
  static const _reasoningTypes = ['shadow'];
  static const _spatialTypes = ['maze'];

  static Future<HistoryTrendsResult> load(AppDatabase db) async {
    final tests = await db.testResultDao.getAllChronological();
    final conditions = await db.dailyConditionDao.getAllChronological();

    final conditionByDate = <String, DailyCondition>{};
    for (final c in conditions) {
      conditionByDate[c.dateKey] = c;
    }

    final byDate = <String, List<TestResult>>{};
    for (final t in tests) {
      byDate.putIfAbsent(t.dateKey, () => []).add(t);
    }
    final sortedDates = byDate.keys.toList()..sort();

    DayPillarAverages? firstAvg;
    DayPillarAverages? lastAvg;
    if (sortedDates.isNotEmpty) {
      firstAvg = _averagesForDay(
        sortedDates.first,
        byDate[sortedDates.first]!,
        conditionByDate[sortedDates.first],
      );
      lastAvg = _averagesForDay(
        sortedDates.last,
        byDate[sortedDates.last]!,
        conditionByDate[sortedDates.last],
      );
    }

    final distinctDateKeys = <String>{};
    for (final c in conditions) {
      distinctDateKeys.add(c.dateKey);
    }

    int? moodFirst;
    int? moodLast;
    if (conditions.isNotEmpty) {
      moodFirst = conditions.first.moodScore;
      moodLast = conditions.last.moodScore;
    }

    return HistoryTrendsResult(
      totalTests: tests.length,
      distinctDays: sortedDates.length,
      first: firstAvg,
      last: lastAvg,
      moodFirst: moodFirst,
      moodLast: moodLast,
      dailyConditionDays: distinctDateKeys.length,
    );
  }

  static DayPillarAverages _averagesForDay(
    String dateKey,
    List<TestResult> list,
    DailyCondition? condition,
  ) {
    double? avgFor(List<String> types) {
      final scores = list
          .where((e) => types.contains(e.testType))
          .map((e) => e.normalizedScore)
          .toList();
      if (scores.isEmpty) return null;
      return ScoreCalculator.clamp100(ScoreCalculator.average(scores));
    }

    final memory = avgFor(_memoryTypes);
    final focus = avgFor(_focusTypes);
    final reaction = avgFor(_reactionTypes);
    final coordination = avgFor(_coordinationTypes);
    final numeracy = avgFor(_numeracyTypes);
    final reasoning = avgFor(_reasoningTypes);
    final spatial = avgFor(_spatialTypes);

    final m = memory ?? 50;
    final f = focus ?? 50;
    final r = reaction ?? 50;
    final c = coordination ?? 50;
    final n = numeracy ?? 50;
    final rw = reasoning ?? 50;
    final s = spatial ?? 50;
    final dementiaHint = WellnessDimensions.dementiaPreventionHint(
      memoryScore: m,
      focusScore: f,
      reactionScore: r,
      coordinationScore: c,
      numeracyScore: n,
      reasoningScore: rw,
      spatialScore: s,
    );
    final learningHint = WellnessDimensions.learningAbilityHint(
      memoryScore: m,
      focusScore: f,
      reactionScore: r,
      coordinationScore: c,
      numeracyScore: n,
      reasoningScore: rw,
      spatialScore: s,
    );

    double? emotionalHint;
    if (condition != null) {
      final didBreath = list.any((e) => e.testType == 'breathing');
      emotionalHint = WellnessDimensions.emotionalSelfCareHint(
        mood: condition.moodScore,
        stress: condition.stressScore,
        anxiety: condition.anxietyScore ?? 3,
        motivation: condition.motivationScore,
        sleepHours: condition.sleepHours ?? 0,
        hasSleepRecord: condition.sleepHours != null,
        didBreathingToday: didBreath,
      );
    }

    return DayPillarAverages(
      dateKey: dateKey,
      memory: memory,
      focus: focus,
      reaction: reaction,
      coordination: coordination,
      numeracy: numeracy,
      reasoning: reasoning,
      spatial: spatial,
      dementiaHint: dementiaHint,
      learningHint: learningHint,
      emotionalHint: emotionalHint,
    );
  }
}
