import 'package:drift/drift.dart';

class TestResults extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get dateKey => text()();
  TextColumn get testType => text()();

  RealColumn get rawScore => real().nullable()();
  RealColumn get normalizedScore => real()();
  RealColumn get accuracy => real().nullable()();

  IntColumn get reactionTimeAvg => integer().nullable()();
  IntColumn get reactionTimeSd => integer().nullable()();

  TextColumn get detailJson => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
