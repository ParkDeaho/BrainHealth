import '../services/score_calculator.dart';

/// 치매 예방·학습·정서(우울 관련 자가 점검) 참고 지표.
/// 앱은 의료기기가 아니며 진단·치료를 대체하지 않습니다.
class WellnessDimensions {
  WellnessDimensions._();

  static const String medicalDisclaimer =
      '아래 수치는 생활·자가 기록 기반 참고 지표이며, 의학적 진단이나 치료를 대체하지 않습니다.';

  /// 기억·처리속도(반응) 비중이 큼 — 인지 자극·뇌 건강 습관 관점의 참고치
  /// (오늘 해당 유형 측정이 없으면 호출 전에 중립값으로 보정하는 것을 권장)
  static double dementiaPreventionHint({
    required double memoryScore,
    required double focusScore,
    required double reactionScore,
    required double coordinationScore,
    required double numeracyScore,
    required double reasoningScore,
    required double spatialScore,
  }) {
    return ScoreCalculator.clamp100(
      0.22 * memoryScore +
          0.18 * reactionScore +
          0.14 * focusScore +
          0.12 * coordinationScore +
          0.12 * numeracyScore +
          0.12 * reasoningScore +
          0.10 * spatialScore,
    );
  }

  /// 집중·작업기억(기억+집중) 비중이 큼 — 학습·과제 몰입 관점의 참고치
  static double learningAbilityHint({
    required double memoryScore,
    required double focusScore,
    required double reactionScore,
    required double coordinationScore,
    required double numeracyScore,
    required double reasoningScore,
    required double spatialScore,
  }) {
    return ScoreCalculator.clamp100(
      0.24 * focusScore +
          0.20 * memoryScore +
          0.08 * reactionScore +
          0.10 * coordinationScore +
          0.18 * numeracyScore +
          0.12 * reasoningScore +
          0.08 * spatialScore,
    );
  }

  /// 기분·스트레스·불안·의욕·수면·호흡 활동 (자가 기록 중심, 우울증 진단 아님)
  static double emotionalSelfCareHint({
    required int mood,
    required int stress,
    required int anxiety,
    required int motivation,
    required double sleepHours,
    required bool hasSleepRecord,
    required bool didBreathingToday,
  }) {
    final moodPart = (mood / 5.0) * 26;
    final stressPart = ((6 - stress).clamp(1, 5) / 5.0) * 26;
    final anxietyPart = ((6 - anxiety).clamp(1, 5) / 5.0) * 26;
    final motivationPart = (motivation / 5.0) * 12;
    double sleepPart;
    if (hasSleepRecord && sleepHours > 0) {
      if (sleepHours >= 7 && sleepHours <= 9) {
        sleepPart = 10;
      } else if (sleepHours >= 6) {
        sleepPart = 7;
      } else {
        sleepPart = 4;
      }
    } else {
      sleepPart = 6;
    }
    var sum = moodPart + stressPart + anxietyPart + motivationPart + sleepPart;
    if (didBreathingToday) {
      sum += 4;
    }
    return sum.clamp(0, 100);
  }
}
