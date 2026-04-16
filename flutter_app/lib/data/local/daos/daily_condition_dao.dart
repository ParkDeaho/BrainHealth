import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/daily_conditions.dart';

part 'daily_condition_dao.g.dart';

@DriftAccessor(tables: [DailyConditions])
class DailyConditionDao extends DatabaseAccessor<AppDatabase>
    with _$DailyConditionDaoMixin {
  DailyConditionDao(super.db);

  Future<DailyCondition?> getByDateKey(String dateKey) {
    return (select(dailyConditions)
          ..where((tbl) => tbl.dateKey.equals(dateKey)))
        .getSingleOrNull();
  }

  /// 하루 1행: `date_key` 유니크 기준이라 PK `id`만 대상인 insertOnConflictUpdate와 맞지 않음 → 선조회 후 갱신/삽입
  Future<void> insertOrUpdateCondition(DailyConditionsCompanion data) async {
    if (!data.dateKey.present) {
      throw ArgumentError('dateKey is required');
    }
    final key = data.dateKey.value;
    final existing = await getByDateKey(key);
    if (existing == null) {
      await into(dailyConditions).insert(data);
    } else {
      await (update(dailyConditions)..where((t) => t.id.equals(existing.id)))
          .write(data);
    }
  }

  Future<List<DailyCondition>> getRecentConditions(int days) {
    final fromDate = DateTime.now().subtract(Duration(days: days));
    return (select(dailyConditions)
          ..where((tbl) => tbl.createdAt.isBiggerOrEqualValue(fromDate))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// 마음 기록 전체 — 오래된 순 (처음→최근 추이용)
  Future<List<DailyCondition>> getAllChronological() {
    return (select(dailyConditions)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }
}
