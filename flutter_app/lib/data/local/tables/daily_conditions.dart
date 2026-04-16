import 'package:drift/drift.dart';

class DailyConditions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get dateKey => text()();

  IntColumn get moodScore => integer().withDefault(const Constant(3))();
  IntColumn get stressScore => integer().withDefault(const Constant(3))();
  IntColumn get anxietyScore => integer().nullable()();
  IntColumn get motivationScore => integer().withDefault(const Constant(3))();

  RealColumn get sleepHours => real().nullable()();
  IntColumn get sleepQuality => integer().nullable()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {dateKey},
      ];
}
