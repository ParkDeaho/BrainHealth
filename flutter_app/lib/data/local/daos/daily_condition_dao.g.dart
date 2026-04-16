// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_condition_dao.dart';

// ignore_for_file: type=lint
mixin _$DailyConditionDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyConditionsTable get dailyConditions => attachedDatabase.dailyConditions;
  DailyConditionDaoManager get managers => DailyConditionDaoManager(this);
}

class DailyConditionDaoManager {
  final _$DailyConditionDaoMixin _db;
  DailyConditionDaoManager(this._db);
  $$DailyConditionsTableTableManager get dailyConditions =>
      $$DailyConditionsTableTableManager(
          _db.attachedDatabase, _db.dailyConditions);
}
