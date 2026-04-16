import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/score_summaries.dart';
import '../tables/test_results.dart';

part 'test_result_dao.g.dart';

@DriftAccessor(tables: [TestResults, ScoreSummaries])
class TestResultDao extends DatabaseAccessor<AppDatabase>
    with _$TestResultDaoMixin {
  TestResultDao(super.db);

  Future<void> insertTestResult(TestResultsCompanion data) async {
    await into(testResults).insert(data);
  }

  Future<List<TestResult>> getResultsByDate(String dateKey) {
    return (select(testResults)..where((tbl) => tbl.dateKey.equals(dateKey)))
        .get();
  }

  /// 해당 날짜 기록만, 최신순 (리포트 목록용)
  Future<List<TestResult>> getResultsByDateNewestFirst(String dateKey) {
    return (select(testResults)
          ..where((tbl) => tbl.dateKey.equals(dateKey))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// 전체 이력 — 오래된 순 (추이·집계용)
  Future<List<TestResult>> getAllChronological() {
    return (select(testResults)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> upsertSummary(ScoreSummariesCompanion data) async {
    await into(scoreSummaries).insertOnConflictUpdate(data);
  }

  Future<ScoreSummary?> getSummaryByDate(String dateKey) {
    return (select(scoreSummaries)
          ..where((tbl) => tbl.dateKey.equals(dateKey)))
        .getSingleOrNull();
  }
}
