class ScoreCalculator {
  static double average(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  static double clamp100(double value) {
    if (value < 0) return 0;
    if (value > 100) return 100;
    return value;
  }
}
