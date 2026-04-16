import 'package:braintrain_flutter/l10n/app_localizations.dart';

import '../../data/local/app_database.dart';
import '../models/analysis_result.dart';
import '../models/wellness_dimensions.dart';
import 'score_calculator.dart';

class MindInsightEngine {
  static AnalysisResult generate({
    required DailyCondition? dailyCondition,
    required List<TestResult> todayTests,
    required AppLocalizations l10n,
  }) {
    double memoryScore = 0;
    double focusScore = 0;
    double reactionScore = 0;
    double coordinationScore = 0;
    double numeracyScore = 0;
    double reasoningScore = 0;
    double spatialScore = 0;

    final memoryTests = todayTests
        .where((e) => e.testType == 'memory')
        .map((e) => e.normalizedScore)
        .toList();

    final focusTests = todayTests
        .where((e) =>
            e.testType == 'focus' ||
            e.testType == 'breathing' ||
            e.testType == 'stroop' ||
            e.testType == 'cpt')
        .map((e) => e.normalizedScore)
        .toList();

    final reactionTests = todayTests
        .where((e) => e.testType == 'reaction')
        .map((e) => e.normalizedScore)
        .toList();

    final coordinationTests = todayTests
        .where((e) => e.testType == 'coordination')
        .map((e) => e.normalizedScore)
        .toList();

    final numeracyTests = todayTests
        .where((e) => e.testType == 'numeracy')
        .map((e) => e.normalizedScore)
        .toList();

    final reasoningTests = todayTests
        .where((e) => e.testType == 'shadow')
        .map((e) => e.normalizedScore)
        .toList();

    final spatialTests = todayTests
        .where((e) => e.testType == 'maze')
        .map((e) => e.normalizedScore)
        .toList();

    memoryScore = ScoreCalculator.clamp100(ScoreCalculator.average(memoryTests));
    focusScore = ScoreCalculator.clamp100(ScoreCalculator.average(focusTests));
    reactionScore =
        ScoreCalculator.clamp100(ScoreCalculator.average(reactionTests));
    coordinationScore =
        ScoreCalculator.clamp100(ScoreCalculator.average(coordinationTests));
    numeracyScore =
        ScoreCalculator.clamp100(ScoreCalculator.average(numeracyTests));
    reasoningScore =
        ScoreCalculator.clamp100(ScoreCalculator.average(reasoningTests));
    spatialScore =
        ScoreCalculator.clamp100(ScoreCalculator.average(spatialTests));

    final mWell = memoryTests.isEmpty ? 50.0 : memoryScore;
    final fWell = focusTests.isEmpty ? 50.0 : focusScore;
    final rWell = reactionTests.isEmpty ? 50.0 : reactionScore;
    final cWell = coordinationTests.isEmpty ? 50.0 : coordinationScore;
    final nWell = numeracyTests.isEmpty ? 50.0 : numeracyScore;
    final rwWell = reasoningTests.isEmpty ? 50.0 : reasoningScore;
    final sWell = spatialTests.isEmpty ? 50.0 : spatialScore;

    final mood = dailyCondition?.moodScore ?? 3;
    final stress = dailyCondition?.stressScore ?? 3;
    final motivation = dailyCondition?.motivationScore ?? 3;
    final anxiety = dailyCondition?.anxietyScore ?? 3;
    final sleepHours = dailyCondition?.sleepHours ?? 0;
    final hasSleepRecord = dailyCondition?.sleepHours != null;
    final didBreathingToday =
        todayTests.any((e) => e.testType == 'breathing');
    final hasAnyTestToday = todayTests.isNotEmpty;
    final hasCoordinationToday = coordinationTests.isNotEmpty;
    final hasNumeracyToday = todayTests.any((e) => e.testType == 'numeracy');
    final hasShadowToday = todayTests.any((e) => e.testType == 'shadow');
    final hasMazeToday = todayTests.any((e) => e.testType == 'maze');

    double? dementiaHint;
    double? learningHint;
    if (hasAnyTestToday) {
      dementiaHint = WellnessDimensions.dementiaPreventionHint(
        memoryScore: mWell,
        focusScore: fWell,
        reactionScore: rWell,
        coordinationScore: cWell,
        numeracyScore: nWell,
        reasoningScore: rwWell,
        spatialScore: sWell,
      );
      learningHint = WellnessDimensions.learningAbilityHint(
        memoryScore: mWell,
        focusScore: fWell,
        reactionScore: rWell,
        coordinationScore: cWell,
        numeracyScore: nWell,
        reasoningScore: rwWell,
        spatialScore: sWell,
      );
    }

    final emotionalWellbeing = WellnessDimensions.emotionalSelfCareHint(
      mood: mood,
      stress: stress,
      anxiety: anxiety,
      motivation: motivation,
      sleepHours: sleepHours,
      hasSleepRecord: hasSleepRecord,
      didBreathingToday: didBreathingToday,
    );

    final summaryText = _buildSummary(
      l10n: l10n,
      mood: mood,
      stress: stress,
      motivation: motivation,
      anxiety: anxiety,
      memoryScore: memoryScore,
      focusScore: focusScore,
      reactionScore: reactionScore,
      sleepHours: sleepHours,
      dementiaHint: dementiaHint,
      learningHint: learningHint,
      emotionalWellbeing: emotionalWellbeing,
      hasAnyTestToday: hasAnyTestToday,
    );

    final recommendationText = _buildRecommendation(
      l10n: l10n,
      stress: stress,
      motivation: motivation,
      anxiety: anxiety,
      mood: mood,
      memoryScore: memoryScore,
      focusScore: focusScore,
      reactionScore: reactionScore,
      coordinationScore: coordinationScore,
      numeracyScore: numeracyScore,
      reasoningScore: reasoningScore,
      spatialScore: spatialScore,
      hasCoordinationToday: hasCoordinationToday,
      hasNumeracyToday: hasNumeracyToday,
      hasShadowToday: hasShadowToday,
      hasMazeToday: hasMazeToday,
      dementiaHint: dementiaHint,
      learningHint: learningHint,
      emotionalWellbeing: emotionalWellbeing,
      didBreathingToday: didBreathingToday,
    );

    final fortuneText = _buildFortune(
      l10n: l10n,
      mood: mood,
      stress: stress,
      motivation: motivation,
      anxiety: anxiety,
      memoryScore: memoryScore,
      focusScore: focusScore,
      reactionScore: reactionScore,
      coordinationScore: coordinationScore,
      hasCoordinationToday: hasCoordinationToday,
      dementiaHint: dementiaHint,
      learningHint: learningHint,
      emotionalWellbeing: emotionalWellbeing,
    );

    return AnalysisResult(
      memoryScore: memoryScore,
      focusScore: focusScore,
      reactionScore: reactionScore,
      coordinationScore: coordinationScore,
      numeracyScore: numeracyScore,
      reasoningScore: reasoningScore,
      spatialScore: spatialScore,
      dementiaPreventionScore: dementiaHint,
      learningAbilityScore: learningHint,
      emotionalWellbeingScore: emotionalWellbeing,
      summaryText: summaryText,
      recommendationText: recommendationText,
      fortuneText: fortuneText,
    );
  }

  static String _buildSummary({
    required AppLocalizations l10n,
    required int mood,
    required int stress,
    required int motivation,
    required int anxiety,
    required double memoryScore,
    required double focusScore,
    required double reactionScore,
    required double sleepHours,
    required double? dementiaHint,
    required double? learningHint,
    required double emotionalWellbeing,
    required bool hasAnyTestToday,
  }) {
    if (emotionalWellbeing < 52 && (mood <= 2 || stress >= 4 || anxiety >= 4)) {
      return l10n.insightSumEmotionalHeavy;
    }
    if (hasAnyTestToday &&
        dementiaHint != null &&
        dementiaHint >= 72 &&
        memoryScore >= 65) {
      return l10n.insightSumDementiaGood;
    }
    if (hasAnyTestToday &&
        learningHint != null &&
        learningHint >= 75 &&
        focusScore >= 68) {
      return l10n.insightSumLearningGood;
    }
    if (stress >= 4 && focusScore < 70) {
      return l10n.insightSumStressFocus;
    }
    if (mood >= 4 && memoryScore >= 75) {
      return l10n.insightSumMoodMemory;
    }
    if (motivation <= 2) {
      return l10n.insightSumMotivationLow;
    }
    if (sleepHours > 0 && sleepHours < 6 && reactionScore < 70) {
      return l10n.insightSumSleep;
    }
    if (hasAnyTestToday &&
        dementiaHint != null &&
        dementiaHint < 62 &&
        memoryScore < 62) {
      return l10n.insightSumDementiaEncourage;
    }
    return l10n.insightSumDefault;
  }

  static String _buildRecommendation({
    required AppLocalizations l10n,
    required int stress,
    required int motivation,
    required int anxiety,
    required int mood,
    required double memoryScore,
    required double focusScore,
    required double reactionScore,
    required double coordinationScore,
    required double numeracyScore,
    required double reasoningScore,
    required double spatialScore,
    required bool hasCoordinationToday,
    required bool hasNumeracyToday,
    required bool hasShadowToday,
    required bool hasMazeToday,
    required double? dementiaHint,
    required double? learningHint,
    required double emotionalWellbeing,
    required bool didBreathingToday,
  }) {
    if (emotionalWellbeing < 55 && (mood <= 2 || anxiety >= 4)) {
      return l10n.insightRecEmotionalCare;
    }
    if (stress >= 4 && !didBreathingToday) {
      return l10n.insightRecStressNoBreath;
    }
    if (stress >= 4) {
      return l10n.insightRecStress;
    }
    if (motivation <= 2) {
      return l10n.insightRecMotivation;
    }
    if (dementiaHint != null && dementiaHint < 62 && memoryScore < 65) {
      return l10n.insightRecDementiaLow;
    }
    if (learningHint != null && learningHint < 62 && focusScore < 65) {
      return l10n.insightRecLearningLow;
    }
    if (hasNumeracyToday && numeracyScore < 65) {
      return l10n.insightRecNumeracyLow;
    }
    if (hasShadowToday && reasoningScore < 65) {
      return l10n.insightRecReasoningLow;
    }
    if (hasMazeToday && spatialScore < 65) {
      return l10n.insightRecSpatialLow;
    }
    if (hasCoordinationToday && coordinationScore < 62) {
      return l10n.insightRecCoordinationLow;
    }
    if (memoryScore < 65) {
      return l10n.insightRecMemory;
    }
    if (focusScore < 65) {
      return l10n.insightRecFocus;
    }
    if (reactionScore < 65) {
      return l10n.insightRecReaction;
    }
    return l10n.insightRecDefault;
  }

  static String _buildFortune({
    required AppLocalizations l10n,
    required int mood,
    required int stress,
    required int motivation,
    required int anxiety,
    required double memoryScore,
    required double focusScore,
    required double reactionScore,
    required double coordinationScore,
    required bool hasCoordinationToday,
    required double? dementiaHint,
    required double? learningHint,
    required double emotionalWellbeing,
  }) {
    if (emotionalWellbeing >= 68 && mood >= 4 && anxiety <= 2) {
      return l10n.insightForEmotionalCalm;
    }
    if (mood >= 4 && motivation >= 4 && memoryScore >= 70) {
      return l10n.insightForMoodMotivationMemory;
    }
    if (stress >= 4) {
      return l10n.insightForStress;
    }
    if (motivation <= 2) {
      return l10n.insightForMotivationLow;
    }
    if (dementiaHint != null && dementiaHint >= 75) {
      return l10n.insightForDementiaHigh;
    }
    if (learningHint != null && learningHint >= 75) {
      return l10n.insightForLearningHigh;
    }
    if (hasCoordinationToday && coordinationScore >= 72) {
      return l10n.insightForCoordinationHigh;
    }
    if (focusScore >= 75) {
      return l10n.insightForFocusHigh;
    }
    return l10n.insightForDefault;
  }
}
