import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../data/local/app_database.dart';
import 'mind_check_state.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    unawaited(db.close());
  });
  return db;
});

final mindCheckProvider =
    StateNotifierProvider<MindCheckNotifier, MindCheckState>((ref) {
  final db = ref.read(appDatabaseProvider);
  return MindCheckNotifier(db);
});

class MindCheckNotifier extends StateNotifier<MindCheckState> {
  MindCheckNotifier(this.db) : super(const MindCheckState());

  final AppDatabase db;

  void setMood(int value) => state = state.copyWith(mood: value);
  void setStress(int value) => state = state.copyWith(stress: value);
  void setAnxiety(int value) => state = state.copyWith(anxiety: value);
  void setMotivation(int value) => state = state.copyWith(motivation: value);
  void setSleepHours(double value) => state = state.copyWith(sleepHours: value);
  void setNote(String value) => state = state.copyWith(note: value);

  Future<void> loadToday() async {
    final today = toDateKey(DateTime.now());
    final row = await db.dailyConditionDao.getByDateKey(today);

    if (row != null) {
      state = MindCheckState(
        mood: row.moodScore,
        stress: row.stressScore,
        anxiety: row.anxietyScore ?? 3,
        motivation: row.motivationScore,
        sleepHours: row.sleepHours,
        note: row.note ?? '',
        isSaved: true,
      );
    }
  }

  Future<void> save() async {
    final today = toDateKey(DateTime.now());

    await db.dailyConditionDao.insertOrUpdateCondition(
      DailyConditionsCompanion(
        dateKey: Value(today),
        moodScore: Value(state.mood),
        stressScore: Value(state.stress),
        anxietyScore: Value(state.anxiety),
        motivationScore: Value(state.motivation),
        sleepHours: state.sleepHours != null
            ? Value(state.sleepHours!)
            : const Value.absent(),
        note: Value(state.note.isEmpty ? null : state.note),
      ),
    );

    state = state.copyWith(isSaved: true);
  }
}
