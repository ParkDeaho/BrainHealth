import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/daily_condition_dao.dart';
import 'daos/test_result_dao.dart';
import 'tables/daily_conditions.dart';
import 'tables/score_summaries.dart';
import 'tables/test_results.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    DailyConditions,
    TestResults,
    ScoreSummaries,
  ],
  daos: [
    DailyConditionDao,
    TestResultDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'brain_health_app.db'));
    return NativeDatabase(file);
  });
}
