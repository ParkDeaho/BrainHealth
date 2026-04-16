class AnalysisResult {
  final double memoryScore;
  final double focusScore;
  final double reactionScore;
  final double coordinationScore;
  final double numeracyScore;
  final double reasoningScore;
  final double spatialScore;

  /// 오늘 측정·훈련이 있을 때만 의미 있는 참고 지표
  final double? dementiaPreventionScore;
  final double? learningAbilityScore;

  /// 마음 기록(및 호흡 활동) 기반 정서·수면 케어 참고치 (의학적 진단 아님)
  final double emotionalWellbeingScore;

  final String summaryText;
  final String recommendationText;
  final String fortuneText;

  const AnalysisResult({
    required this.memoryScore,
    required this.focusScore,
    required this.reactionScore,
    required this.coordinationScore,
    required this.numeracyScore,
    required this.reasoningScore,
    required this.spatialScore,
    required this.dementiaPreventionScore,
    required this.learningAbilityScore,
    required this.emotionalWellbeingScore,
    required this.summaryText,
    required this.recommendationText,
    required this.fortuneText,
  });
}
