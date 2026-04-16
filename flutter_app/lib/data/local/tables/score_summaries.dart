import 'package:drift/drift.dart';

class ScoreSummaries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get dateKey => text()();

  RealColumn get memoryScore => real().withDefault(const Constant(0))();
  RealColumn get focusScore => real().withDefault(const Constant(0))();
  RealColumn get reactionScore => real().withDefault(const Constant(0))();

  TextColumn get summaryText => text().nullable()();
  TextColumn get recommendationText => text().nullable()();
  TextColumn get fortuneText => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {dateKey},
      ];
}
