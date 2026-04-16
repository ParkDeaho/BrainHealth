import 'package:drift/drift.dart' show Value;

import '../../data/local/app_database.dart';
import '../utils/date_utils.dart';
import 'test_record_events.dart';

/// 측정/훈련 완료 시 [MindInsightEngine]과 맞는 testType으로 저장합니다.
class TestResultRecorder {
  TestResultRecorder._();

  static Future<void> record(
    AppDatabase db, {
    required String testType,
    required double normalizedScore,
    double? rawScore,
    String? detailJson,
    double? accuracy,
    int? reactionTimeAvgMs,
  }) async {
    final score = normalizedScore.clamp(0, 100).toDouble();
    await db.testResultDao.insertTestResult(
      TestResultsCompanion.insert(
        dateKey: toDateKey(DateTime.now()),
        testType: testType,
        normalizedScore: score,
        rawScore: rawScore != null ? Value(rawScore) : Value(score),
        accuracy: accuracy != null ? Value(accuracy) : const Value.absent(),
        reactionTimeAvg: reactionTimeAvgMs != null
            ? Value(reactionTimeAvgMs)
            : const Value.absent(),
        detailJson: detailJson != null ? Value(detailJson) : const Value.absent(),
      ),
    );
    TestRecordEvents.notifyRecorded();
  }
}
