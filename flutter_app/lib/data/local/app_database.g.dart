// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DailyConditionsTable extends DailyConditions
    with TableInfo<$DailyConditionsTable, DailyCondition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateKeyMeta =
      const VerificationMeta('dateKey');
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
      'date_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _moodScoreMeta =
      const VerificationMeta('moodScore');
  @override
  late final GeneratedColumn<int> moodScore = GeneratedColumn<int>(
      'mood_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _stressScoreMeta =
      const VerificationMeta('stressScore');
  @override
  late final GeneratedColumn<int> stressScore = GeneratedColumn<int>(
      'stress_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _anxietyScoreMeta =
      const VerificationMeta('anxietyScore');
  @override
  late final GeneratedColumn<int> anxietyScore = GeneratedColumn<int>(
      'anxiety_score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _motivationScoreMeta =
      const VerificationMeta('motivationScore');
  @override
  late final GeneratedColumn<int> motivationScore = GeneratedColumn<int>(
      'motivation_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _sleepHoursMeta =
      const VerificationMeta('sleepHours');
  @override
  late final GeneratedColumn<double> sleepHours = GeneratedColumn<double>(
      'sleep_hours', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _sleepQualityMeta =
      const VerificationMeta('sleepQuality');
  @override
  late final GeneratedColumn<int> sleepQuality = GeneratedColumn<int>(
      'sleep_quality', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dateKey,
        moodScore,
        stressScore,
        anxietyScore,
        motivationScore,
        sleepHours,
        sleepQuality,
        note,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_conditions';
  @override
  VerificationContext validateIntegrity(Insertable<DailyCondition> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date_key')) {
      context.handle(_dateKeyMeta,
          dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta));
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('mood_score')) {
      context.handle(_moodScoreMeta,
          moodScore.isAcceptableOrUnknown(data['mood_score']!, _moodScoreMeta));
    }
    if (data.containsKey('stress_score')) {
      context.handle(
          _stressScoreMeta,
          stressScore.isAcceptableOrUnknown(
              data['stress_score']!, _stressScoreMeta));
    }
    if (data.containsKey('anxiety_score')) {
      context.handle(
          _anxietyScoreMeta,
          anxietyScore.isAcceptableOrUnknown(
              data['anxiety_score']!, _anxietyScoreMeta));
    }
    if (data.containsKey('motivation_score')) {
      context.handle(
          _motivationScoreMeta,
          motivationScore.isAcceptableOrUnknown(
              data['motivation_score']!, _motivationScoreMeta));
    }
    if (data.containsKey('sleep_hours')) {
      context.handle(
          _sleepHoursMeta,
          sleepHours.isAcceptableOrUnknown(
              data['sleep_hours']!, _sleepHoursMeta));
    }
    if (data.containsKey('sleep_quality')) {
      context.handle(
          _sleepQualityMeta,
          sleepQuality.isAcceptableOrUnknown(
              data['sleep_quality']!, _sleepQualityMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {dateKey},
      ];
  @override
  DailyCondition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyCondition(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_key'])!,
      moodScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mood_score'])!,
      stressScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stress_score'])!,
      anxietyScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}anxiety_score']),
      motivationScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}motivation_score'])!,
      sleepHours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sleep_hours']),
      sleepQuality: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sleep_quality']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DailyConditionsTable createAlias(String alias) {
    return $DailyConditionsTable(attachedDatabase, alias);
  }
}

class DailyCondition extends DataClass implements Insertable<DailyCondition> {
  final int id;
  final String dateKey;
  final int moodScore;
  final int stressScore;
  final int? anxietyScore;
  final int motivationScore;
  final double? sleepHours;
  final int? sleepQuality;
  final String? note;
  final DateTime createdAt;
  const DailyCondition(
      {required this.id,
      required this.dateKey,
      required this.moodScore,
      required this.stressScore,
      this.anxietyScore,
      required this.motivationScore,
      this.sleepHours,
      this.sleepQuality,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['mood_score'] = Variable<int>(moodScore);
    map['stress_score'] = Variable<int>(stressScore);
    if (!nullToAbsent || anxietyScore != null) {
      map['anxiety_score'] = Variable<int>(anxietyScore);
    }
    map['motivation_score'] = Variable<int>(motivationScore);
    if (!nullToAbsent || sleepHours != null) {
      map['sleep_hours'] = Variable<double>(sleepHours);
    }
    if (!nullToAbsent || sleepQuality != null) {
      map['sleep_quality'] = Variable<int>(sleepQuality);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyConditionsCompanion toCompanion(bool nullToAbsent) {
    return DailyConditionsCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      moodScore: Value(moodScore),
      stressScore: Value(stressScore),
      anxietyScore: anxietyScore == null && nullToAbsent
          ? const Value.absent()
          : Value(anxietyScore),
      motivationScore: Value(motivationScore),
      sleepHours: sleepHours == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepHours),
      sleepQuality: sleepQuality == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepQuality),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory DailyCondition.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyCondition(
      id: serializer.fromJson<int>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      moodScore: serializer.fromJson<int>(json['moodScore']),
      stressScore: serializer.fromJson<int>(json['stressScore']),
      anxietyScore: serializer.fromJson<int?>(json['anxietyScore']),
      motivationScore: serializer.fromJson<int>(json['motivationScore']),
      sleepHours: serializer.fromJson<double?>(json['sleepHours']),
      sleepQuality: serializer.fromJson<int?>(json['sleepQuality']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'moodScore': serializer.toJson<int>(moodScore),
      'stressScore': serializer.toJson<int>(stressScore),
      'anxietyScore': serializer.toJson<int?>(anxietyScore),
      'motivationScore': serializer.toJson<int>(motivationScore),
      'sleepHours': serializer.toJson<double?>(sleepHours),
      'sleepQuality': serializer.toJson<int?>(sleepQuality),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyCondition copyWith(
          {int? id,
          String? dateKey,
          int? moodScore,
          int? stressScore,
          Value<int?> anxietyScore = const Value.absent(),
          int? motivationScore,
          Value<double?> sleepHours = const Value.absent(),
          Value<int?> sleepQuality = const Value.absent(),
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      DailyCondition(
        id: id ?? this.id,
        dateKey: dateKey ?? this.dateKey,
        moodScore: moodScore ?? this.moodScore,
        stressScore: stressScore ?? this.stressScore,
        anxietyScore:
            anxietyScore.present ? anxietyScore.value : this.anxietyScore,
        motivationScore: motivationScore ?? this.motivationScore,
        sleepHours: sleepHours.present ? sleepHours.value : this.sleepHours,
        sleepQuality:
            sleepQuality.present ? sleepQuality.value : this.sleepQuality,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  DailyCondition copyWithCompanion(DailyConditionsCompanion data) {
    return DailyCondition(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      moodScore: data.moodScore.present ? data.moodScore.value : this.moodScore,
      stressScore:
          data.stressScore.present ? data.stressScore.value : this.stressScore,
      anxietyScore: data.anxietyScore.present
          ? data.anxietyScore.value
          : this.anxietyScore,
      motivationScore: data.motivationScore.present
          ? data.motivationScore.value
          : this.motivationScore,
      sleepHours:
          data.sleepHours.present ? data.sleepHours.value : this.sleepHours,
      sleepQuality: data.sleepQuality.present
          ? data.sleepQuality.value
          : this.sleepQuality,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyCondition(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('moodScore: $moodScore, ')
          ..write('stressScore: $stressScore, ')
          ..write('anxietyScore: $anxietyScore, ')
          ..write('motivationScore: $motivationScore, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dateKey, moodScore, stressScore,
      anxietyScore, motivationScore, sleepHours, sleepQuality, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyCondition &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.moodScore == this.moodScore &&
          other.stressScore == this.stressScore &&
          other.anxietyScore == this.anxietyScore &&
          other.motivationScore == this.motivationScore &&
          other.sleepHours == this.sleepHours &&
          other.sleepQuality == this.sleepQuality &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class DailyConditionsCompanion extends UpdateCompanion<DailyCondition> {
  final Value<int> id;
  final Value<String> dateKey;
  final Value<int> moodScore;
  final Value<int> stressScore;
  final Value<int?> anxietyScore;
  final Value<int> motivationScore;
  final Value<double?> sleepHours;
  final Value<int?> sleepQuality;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const DailyConditionsCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.moodScore = const Value.absent(),
    this.stressScore = const Value.absent(),
    this.anxietyScore = const Value.absent(),
    this.motivationScore = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyConditionsCompanion.insert({
    this.id = const Value.absent(),
    required String dateKey,
    this.moodScore = const Value.absent(),
    this.stressScore = const Value.absent(),
    this.anxietyScore = const Value.absent(),
    this.motivationScore = const Value.absent(),
    this.sleepHours = const Value.absent(),
    this.sleepQuality = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : dateKey = Value(dateKey);
  static Insertable<DailyCondition> custom({
    Expression<int>? id,
    Expression<String>? dateKey,
    Expression<int>? moodScore,
    Expression<int>? stressScore,
    Expression<int>? anxietyScore,
    Expression<int>? motivationScore,
    Expression<double>? sleepHours,
    Expression<int>? sleepQuality,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (moodScore != null) 'mood_score': moodScore,
      if (stressScore != null) 'stress_score': stressScore,
      if (anxietyScore != null) 'anxiety_score': anxietyScore,
      if (motivationScore != null) 'motivation_score': motivationScore,
      if (sleepHours != null) 'sleep_hours': sleepHours,
      if (sleepQuality != null) 'sleep_quality': sleepQuality,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyConditionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? dateKey,
      Value<int>? moodScore,
      Value<int>? stressScore,
      Value<int?>? anxietyScore,
      Value<int>? motivationScore,
      Value<double?>? sleepHours,
      Value<int?>? sleepQuality,
      Value<String?>? note,
      Value<DateTime>? createdAt}) {
    return DailyConditionsCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      moodScore: moodScore ?? this.moodScore,
      stressScore: stressScore ?? this.stressScore,
      anxietyScore: anxietyScore ?? this.anxietyScore,
      motivationScore: motivationScore ?? this.motivationScore,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (moodScore.present) {
      map['mood_score'] = Variable<int>(moodScore.value);
    }
    if (stressScore.present) {
      map['stress_score'] = Variable<int>(stressScore.value);
    }
    if (anxietyScore.present) {
      map['anxiety_score'] = Variable<int>(anxietyScore.value);
    }
    if (motivationScore.present) {
      map['motivation_score'] = Variable<int>(motivationScore.value);
    }
    if (sleepHours.present) {
      map['sleep_hours'] = Variable<double>(sleepHours.value);
    }
    if (sleepQuality.present) {
      map['sleep_quality'] = Variable<int>(sleepQuality.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyConditionsCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('moodScore: $moodScore, ')
          ..write('stressScore: $stressScore, ')
          ..write('anxietyScore: $anxietyScore, ')
          ..write('motivationScore: $motivationScore, ')
          ..write('sleepHours: $sleepHours, ')
          ..write('sleepQuality: $sleepQuality, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TestResultsTable extends TestResults
    with TableInfo<$TestResultsTable, TestResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateKeyMeta =
      const VerificationMeta('dateKey');
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
      'date_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _testTypeMeta =
      const VerificationMeta('testType');
  @override
  late final GeneratedColumn<String> testType = GeneratedColumn<String>(
      'test_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rawScoreMeta =
      const VerificationMeta('rawScore');
  @override
  late final GeneratedColumn<double> rawScore = GeneratedColumn<double>(
      'raw_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _normalizedScoreMeta =
      const VerificationMeta('normalizedScore');
  @override
  late final GeneratedColumn<double> normalizedScore = GeneratedColumn<double>(
      'normalized_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _reactionTimeAvgMeta =
      const VerificationMeta('reactionTimeAvg');
  @override
  late final GeneratedColumn<int> reactionTimeAvg = GeneratedColumn<int>(
      'reaction_time_avg', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _reactionTimeSdMeta =
      const VerificationMeta('reactionTimeSd');
  @override
  late final GeneratedColumn<int> reactionTimeSd = GeneratedColumn<int>(
      'reaction_time_sd', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _detailJsonMeta =
      const VerificationMeta('detailJson');
  @override
  late final GeneratedColumn<String> detailJson = GeneratedColumn<String>(
      'detail_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dateKey,
        testType,
        rawScore,
        normalizedScore,
        accuracy,
        reactionTimeAvg,
        reactionTimeSd,
        detailJson,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_results';
  @override
  VerificationContext validateIntegrity(Insertable<TestResult> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date_key')) {
      context.handle(_dateKeyMeta,
          dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta));
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('test_type')) {
      context.handle(_testTypeMeta,
          testType.isAcceptableOrUnknown(data['test_type']!, _testTypeMeta));
    } else if (isInserting) {
      context.missing(_testTypeMeta);
    }
    if (data.containsKey('raw_score')) {
      context.handle(_rawScoreMeta,
          rawScore.isAcceptableOrUnknown(data['raw_score']!, _rawScoreMeta));
    }
    if (data.containsKey('normalized_score')) {
      context.handle(
          _normalizedScoreMeta,
          normalizedScore.isAcceptableOrUnknown(
              data['normalized_score']!, _normalizedScoreMeta));
    } else if (isInserting) {
      context.missing(_normalizedScoreMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    }
    if (data.containsKey('reaction_time_avg')) {
      context.handle(
          _reactionTimeAvgMeta,
          reactionTimeAvg.isAcceptableOrUnknown(
              data['reaction_time_avg']!, _reactionTimeAvgMeta));
    }
    if (data.containsKey('reaction_time_sd')) {
      context.handle(
          _reactionTimeSdMeta,
          reactionTimeSd.isAcceptableOrUnknown(
              data['reaction_time_sd']!, _reactionTimeSdMeta));
    }
    if (data.containsKey('detail_json')) {
      context.handle(
          _detailJsonMeta,
          detailJson.isAcceptableOrUnknown(
              data['detail_json']!, _detailJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestResult(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_key'])!,
      testType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}test_type'])!,
      rawScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}raw_score']),
      normalizedScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}normalized_score'])!,
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy']),
      reactionTimeAvg: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reaction_time_avg']),
      reactionTimeSd: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reaction_time_sd']),
      detailJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}detail_json']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TestResultsTable createAlias(String alias) {
    return $TestResultsTable(attachedDatabase, alias);
  }
}

class TestResult extends DataClass implements Insertable<TestResult> {
  final int id;
  final String dateKey;
  final String testType;
  final double? rawScore;
  final double normalizedScore;
  final double? accuracy;
  final int? reactionTimeAvg;
  final int? reactionTimeSd;
  final String? detailJson;
  final DateTime createdAt;
  const TestResult(
      {required this.id,
      required this.dateKey,
      required this.testType,
      this.rawScore,
      required this.normalizedScore,
      this.accuracy,
      this.reactionTimeAvg,
      this.reactionTimeSd,
      this.detailJson,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['test_type'] = Variable<String>(testType);
    if (!nullToAbsent || rawScore != null) {
      map['raw_score'] = Variable<double>(rawScore);
    }
    map['normalized_score'] = Variable<double>(normalizedScore);
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    if (!nullToAbsent || reactionTimeAvg != null) {
      map['reaction_time_avg'] = Variable<int>(reactionTimeAvg);
    }
    if (!nullToAbsent || reactionTimeSd != null) {
      map['reaction_time_sd'] = Variable<int>(reactionTimeSd);
    }
    if (!nullToAbsent || detailJson != null) {
      map['detail_json'] = Variable<String>(detailJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TestResultsCompanion toCompanion(bool nullToAbsent) {
    return TestResultsCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      testType: Value(testType),
      rawScore: rawScore == null && nullToAbsent
          ? const Value.absent()
          : Value(rawScore),
      normalizedScore: Value(normalizedScore),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      reactionTimeAvg: reactionTimeAvg == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionTimeAvg),
      reactionTimeSd: reactionTimeSd == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionTimeSd),
      detailJson: detailJson == null && nullToAbsent
          ? const Value.absent()
          : Value(detailJson),
      createdAt: Value(createdAt),
    );
  }

  factory TestResult.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestResult(
      id: serializer.fromJson<int>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      testType: serializer.fromJson<String>(json['testType']),
      rawScore: serializer.fromJson<double?>(json['rawScore']),
      normalizedScore: serializer.fromJson<double>(json['normalizedScore']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      reactionTimeAvg: serializer.fromJson<int?>(json['reactionTimeAvg']),
      reactionTimeSd: serializer.fromJson<int?>(json['reactionTimeSd']),
      detailJson: serializer.fromJson<String?>(json['detailJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'testType': serializer.toJson<String>(testType),
      'rawScore': serializer.toJson<double?>(rawScore),
      'normalizedScore': serializer.toJson<double>(normalizedScore),
      'accuracy': serializer.toJson<double?>(accuracy),
      'reactionTimeAvg': serializer.toJson<int?>(reactionTimeAvg),
      'reactionTimeSd': serializer.toJson<int?>(reactionTimeSd),
      'detailJson': serializer.toJson<String?>(detailJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TestResult copyWith(
          {int? id,
          String? dateKey,
          String? testType,
          Value<double?> rawScore = const Value.absent(),
          double? normalizedScore,
          Value<double?> accuracy = const Value.absent(),
          Value<int?> reactionTimeAvg = const Value.absent(),
          Value<int?> reactionTimeSd = const Value.absent(),
          Value<String?> detailJson = const Value.absent(),
          DateTime? createdAt}) =>
      TestResult(
        id: id ?? this.id,
        dateKey: dateKey ?? this.dateKey,
        testType: testType ?? this.testType,
        rawScore: rawScore.present ? rawScore.value : this.rawScore,
        normalizedScore: normalizedScore ?? this.normalizedScore,
        accuracy: accuracy.present ? accuracy.value : this.accuracy,
        reactionTimeAvg: reactionTimeAvg.present
            ? reactionTimeAvg.value
            : this.reactionTimeAvg,
        reactionTimeSd:
            reactionTimeSd.present ? reactionTimeSd.value : this.reactionTimeSd,
        detailJson: detailJson.present ? detailJson.value : this.detailJson,
        createdAt: createdAt ?? this.createdAt,
      );
  TestResult copyWithCompanion(TestResultsCompanion data) {
    return TestResult(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      testType: data.testType.present ? data.testType.value : this.testType,
      rawScore: data.rawScore.present ? data.rawScore.value : this.rawScore,
      normalizedScore: data.normalizedScore.present
          ? data.normalizedScore.value
          : this.normalizedScore,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      reactionTimeAvg: data.reactionTimeAvg.present
          ? data.reactionTimeAvg.value
          : this.reactionTimeAvg,
      reactionTimeSd: data.reactionTimeSd.present
          ? data.reactionTimeSd.value
          : this.reactionTimeSd,
      detailJson:
          data.detailJson.present ? data.detailJson.value : this.detailJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestResult(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('testType: $testType, ')
          ..write('rawScore: $rawScore, ')
          ..write('normalizedScore: $normalizedScore, ')
          ..write('accuracy: $accuracy, ')
          ..write('reactionTimeAvg: $reactionTimeAvg, ')
          ..write('reactionTimeSd: $reactionTimeSd, ')
          ..write('detailJson: $detailJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      dateKey,
      testType,
      rawScore,
      normalizedScore,
      accuracy,
      reactionTimeAvg,
      reactionTimeSd,
      detailJson,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestResult &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.testType == this.testType &&
          other.rawScore == this.rawScore &&
          other.normalizedScore == this.normalizedScore &&
          other.accuracy == this.accuracy &&
          other.reactionTimeAvg == this.reactionTimeAvg &&
          other.reactionTimeSd == this.reactionTimeSd &&
          other.detailJson == this.detailJson &&
          other.createdAt == this.createdAt);
}

class TestResultsCompanion extends UpdateCompanion<TestResult> {
  final Value<int> id;
  final Value<String> dateKey;
  final Value<String> testType;
  final Value<double?> rawScore;
  final Value<double> normalizedScore;
  final Value<double?> accuracy;
  final Value<int?> reactionTimeAvg;
  final Value<int?> reactionTimeSd;
  final Value<String?> detailJson;
  final Value<DateTime> createdAt;
  const TestResultsCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.testType = const Value.absent(),
    this.rawScore = const Value.absent(),
    this.normalizedScore = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.reactionTimeAvg = const Value.absent(),
    this.reactionTimeSd = const Value.absent(),
    this.detailJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TestResultsCompanion.insert({
    this.id = const Value.absent(),
    required String dateKey,
    required String testType,
    this.rawScore = const Value.absent(),
    required double normalizedScore,
    this.accuracy = const Value.absent(),
    this.reactionTimeAvg = const Value.absent(),
    this.reactionTimeSd = const Value.absent(),
    this.detailJson = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : dateKey = Value(dateKey),
        testType = Value(testType),
        normalizedScore = Value(normalizedScore);
  static Insertable<TestResult> custom({
    Expression<int>? id,
    Expression<String>? dateKey,
    Expression<String>? testType,
    Expression<double>? rawScore,
    Expression<double>? normalizedScore,
    Expression<double>? accuracy,
    Expression<int>? reactionTimeAvg,
    Expression<int>? reactionTimeSd,
    Expression<String>? detailJson,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (testType != null) 'test_type': testType,
      if (rawScore != null) 'raw_score': rawScore,
      if (normalizedScore != null) 'normalized_score': normalizedScore,
      if (accuracy != null) 'accuracy': accuracy,
      if (reactionTimeAvg != null) 'reaction_time_avg': reactionTimeAvg,
      if (reactionTimeSd != null) 'reaction_time_sd': reactionTimeSd,
      if (detailJson != null) 'detail_json': detailJson,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TestResultsCompanion copyWith(
      {Value<int>? id,
      Value<String>? dateKey,
      Value<String>? testType,
      Value<double?>? rawScore,
      Value<double>? normalizedScore,
      Value<double?>? accuracy,
      Value<int?>? reactionTimeAvg,
      Value<int?>? reactionTimeSd,
      Value<String?>? detailJson,
      Value<DateTime>? createdAt}) {
    return TestResultsCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      testType: testType ?? this.testType,
      rawScore: rawScore ?? this.rawScore,
      normalizedScore: normalizedScore ?? this.normalizedScore,
      accuracy: accuracy ?? this.accuracy,
      reactionTimeAvg: reactionTimeAvg ?? this.reactionTimeAvg,
      reactionTimeSd: reactionTimeSd ?? this.reactionTimeSd,
      detailJson: detailJson ?? this.detailJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (testType.present) {
      map['test_type'] = Variable<String>(testType.value);
    }
    if (rawScore.present) {
      map['raw_score'] = Variable<double>(rawScore.value);
    }
    if (normalizedScore.present) {
      map['normalized_score'] = Variable<double>(normalizedScore.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (reactionTimeAvg.present) {
      map['reaction_time_avg'] = Variable<int>(reactionTimeAvg.value);
    }
    if (reactionTimeSd.present) {
      map['reaction_time_sd'] = Variable<int>(reactionTimeSd.value);
    }
    if (detailJson.present) {
      map['detail_json'] = Variable<String>(detailJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestResultsCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('testType: $testType, ')
          ..write('rawScore: $rawScore, ')
          ..write('normalizedScore: $normalizedScore, ')
          ..write('accuracy: $accuracy, ')
          ..write('reactionTimeAvg: $reactionTimeAvg, ')
          ..write('reactionTimeSd: $reactionTimeSd, ')
          ..write('detailJson: $detailJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ScoreSummariesTable extends ScoreSummaries
    with TableInfo<$ScoreSummariesTable, ScoreSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoreSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateKeyMeta =
      const VerificationMeta('dateKey');
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
      'date_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _memoryScoreMeta =
      const VerificationMeta('memoryScore');
  @override
  late final GeneratedColumn<double> memoryScore = GeneratedColumn<double>(
      'memory_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _focusScoreMeta =
      const VerificationMeta('focusScore');
  @override
  late final GeneratedColumn<double> focusScore = GeneratedColumn<double>(
      'focus_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reactionScoreMeta =
      const VerificationMeta('reactionScore');
  @override
  late final GeneratedColumn<double> reactionScore = GeneratedColumn<double>(
      'reaction_score', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _summaryTextMeta =
      const VerificationMeta('summaryText');
  @override
  late final GeneratedColumn<String> summaryText = GeneratedColumn<String>(
      'summary_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recommendationTextMeta =
      const VerificationMeta('recommendationText');
  @override
  late final GeneratedColumn<String> recommendationText =
      GeneratedColumn<String>('recommendation_text', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fortuneTextMeta =
      const VerificationMeta('fortuneText');
  @override
  late final GeneratedColumn<String> fortuneText = GeneratedColumn<String>(
      'fortune_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        dateKey,
        memoryScore,
        focusScore,
        reactionScore,
        summaryText,
        recommendationText,
        fortuneText,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'score_summaries';
  @override
  VerificationContext validateIntegrity(Insertable<ScoreSummary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date_key')) {
      context.handle(_dateKeyMeta,
          dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta));
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('memory_score')) {
      context.handle(
          _memoryScoreMeta,
          memoryScore.isAcceptableOrUnknown(
              data['memory_score']!, _memoryScoreMeta));
    }
    if (data.containsKey('focus_score')) {
      context.handle(
          _focusScoreMeta,
          focusScore.isAcceptableOrUnknown(
              data['focus_score']!, _focusScoreMeta));
    }
    if (data.containsKey('reaction_score')) {
      context.handle(
          _reactionScoreMeta,
          reactionScore.isAcceptableOrUnknown(
              data['reaction_score']!, _reactionScoreMeta));
    }
    if (data.containsKey('summary_text')) {
      context.handle(
          _summaryTextMeta,
          summaryText.isAcceptableOrUnknown(
              data['summary_text']!, _summaryTextMeta));
    }
    if (data.containsKey('recommendation_text')) {
      context.handle(
          _recommendationTextMeta,
          recommendationText.isAcceptableOrUnknown(
              data['recommendation_text']!, _recommendationTextMeta));
    }
    if (data.containsKey('fortune_text')) {
      context.handle(
          _fortuneTextMeta,
          fortuneText.isAcceptableOrUnknown(
              data['fortune_text']!, _fortuneTextMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {dateKey},
      ];
  @override
  ScoreSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScoreSummary(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_key'])!,
      memoryScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}memory_score'])!,
      focusScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}focus_score'])!,
      reactionScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}reaction_score'])!,
      summaryText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary_text']),
      recommendationText: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recommendation_text']),
      fortuneText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fortune_text']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ScoreSummariesTable createAlias(String alias) {
    return $ScoreSummariesTable(attachedDatabase, alias);
  }
}

class ScoreSummary extends DataClass implements Insertable<ScoreSummary> {
  final int id;
  final String dateKey;
  final double memoryScore;
  final double focusScore;
  final double reactionScore;
  final String? summaryText;
  final String? recommendationText;
  final String? fortuneText;
  final DateTime createdAt;
  const ScoreSummary(
      {required this.id,
      required this.dateKey,
      required this.memoryScore,
      required this.focusScore,
      required this.reactionScore,
      this.summaryText,
      this.recommendationText,
      this.fortuneText,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['memory_score'] = Variable<double>(memoryScore);
    map['focus_score'] = Variable<double>(focusScore);
    map['reaction_score'] = Variable<double>(reactionScore);
    if (!nullToAbsent || summaryText != null) {
      map['summary_text'] = Variable<String>(summaryText);
    }
    if (!nullToAbsent || recommendationText != null) {
      map['recommendation_text'] = Variable<String>(recommendationText);
    }
    if (!nullToAbsent || fortuneText != null) {
      map['fortune_text'] = Variable<String>(fortuneText);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ScoreSummariesCompanion toCompanion(bool nullToAbsent) {
    return ScoreSummariesCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      memoryScore: Value(memoryScore),
      focusScore: Value(focusScore),
      reactionScore: Value(reactionScore),
      summaryText: summaryText == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryText),
      recommendationText: recommendationText == null && nullToAbsent
          ? const Value.absent()
          : Value(recommendationText),
      fortuneText: fortuneText == null && nullToAbsent
          ? const Value.absent()
          : Value(fortuneText),
      createdAt: Value(createdAt),
    );
  }

  factory ScoreSummary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScoreSummary(
      id: serializer.fromJson<int>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      memoryScore: serializer.fromJson<double>(json['memoryScore']),
      focusScore: serializer.fromJson<double>(json['focusScore']),
      reactionScore: serializer.fromJson<double>(json['reactionScore']),
      summaryText: serializer.fromJson<String?>(json['summaryText']),
      recommendationText:
          serializer.fromJson<String?>(json['recommendationText']),
      fortuneText: serializer.fromJson<String?>(json['fortuneText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'memoryScore': serializer.toJson<double>(memoryScore),
      'focusScore': serializer.toJson<double>(focusScore),
      'reactionScore': serializer.toJson<double>(reactionScore),
      'summaryText': serializer.toJson<String?>(summaryText),
      'recommendationText': serializer.toJson<String?>(recommendationText),
      'fortuneText': serializer.toJson<String?>(fortuneText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ScoreSummary copyWith(
          {int? id,
          String? dateKey,
          double? memoryScore,
          double? focusScore,
          double? reactionScore,
          Value<String?> summaryText = const Value.absent(),
          Value<String?> recommendationText = const Value.absent(),
          Value<String?> fortuneText = const Value.absent(),
          DateTime? createdAt}) =>
      ScoreSummary(
        id: id ?? this.id,
        dateKey: dateKey ?? this.dateKey,
        memoryScore: memoryScore ?? this.memoryScore,
        focusScore: focusScore ?? this.focusScore,
        reactionScore: reactionScore ?? this.reactionScore,
        summaryText: summaryText.present ? summaryText.value : this.summaryText,
        recommendationText: recommendationText.present
            ? recommendationText.value
            : this.recommendationText,
        fortuneText: fortuneText.present ? fortuneText.value : this.fortuneText,
        createdAt: createdAt ?? this.createdAt,
      );
  ScoreSummary copyWithCompanion(ScoreSummariesCompanion data) {
    return ScoreSummary(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      memoryScore:
          data.memoryScore.present ? data.memoryScore.value : this.memoryScore,
      focusScore:
          data.focusScore.present ? data.focusScore.value : this.focusScore,
      reactionScore: data.reactionScore.present
          ? data.reactionScore.value
          : this.reactionScore,
      summaryText:
          data.summaryText.present ? data.summaryText.value : this.summaryText,
      recommendationText: data.recommendationText.present
          ? data.recommendationText.value
          : this.recommendationText,
      fortuneText:
          data.fortuneText.present ? data.fortuneText.value : this.fortuneText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScoreSummary(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('memoryScore: $memoryScore, ')
          ..write('focusScore: $focusScore, ')
          ..write('reactionScore: $reactionScore, ')
          ..write('summaryText: $summaryText, ')
          ..write('recommendationText: $recommendationText, ')
          ..write('fortuneText: $fortuneText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dateKey, memoryScore, focusScore,
      reactionScore, summaryText, recommendationText, fortuneText, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScoreSummary &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.memoryScore == this.memoryScore &&
          other.focusScore == this.focusScore &&
          other.reactionScore == this.reactionScore &&
          other.summaryText == this.summaryText &&
          other.recommendationText == this.recommendationText &&
          other.fortuneText == this.fortuneText &&
          other.createdAt == this.createdAt);
}

class ScoreSummariesCompanion extends UpdateCompanion<ScoreSummary> {
  final Value<int> id;
  final Value<String> dateKey;
  final Value<double> memoryScore;
  final Value<double> focusScore;
  final Value<double> reactionScore;
  final Value<String?> summaryText;
  final Value<String?> recommendationText;
  final Value<String?> fortuneText;
  final Value<DateTime> createdAt;
  const ScoreSummariesCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.memoryScore = const Value.absent(),
    this.focusScore = const Value.absent(),
    this.reactionScore = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.recommendationText = const Value.absent(),
    this.fortuneText = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ScoreSummariesCompanion.insert({
    this.id = const Value.absent(),
    required String dateKey,
    this.memoryScore = const Value.absent(),
    this.focusScore = const Value.absent(),
    this.reactionScore = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.recommendationText = const Value.absent(),
    this.fortuneText = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : dateKey = Value(dateKey);
  static Insertable<ScoreSummary> custom({
    Expression<int>? id,
    Expression<String>? dateKey,
    Expression<double>? memoryScore,
    Expression<double>? focusScore,
    Expression<double>? reactionScore,
    Expression<String>? summaryText,
    Expression<String>? recommendationText,
    Expression<String>? fortuneText,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (memoryScore != null) 'memory_score': memoryScore,
      if (focusScore != null) 'focus_score': focusScore,
      if (reactionScore != null) 'reaction_score': reactionScore,
      if (summaryText != null) 'summary_text': summaryText,
      if (recommendationText != null) 'recommendation_text': recommendationText,
      if (fortuneText != null) 'fortune_text': fortuneText,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ScoreSummariesCompanion copyWith(
      {Value<int>? id,
      Value<String>? dateKey,
      Value<double>? memoryScore,
      Value<double>? focusScore,
      Value<double>? reactionScore,
      Value<String?>? summaryText,
      Value<String?>? recommendationText,
      Value<String?>? fortuneText,
      Value<DateTime>? createdAt}) {
    return ScoreSummariesCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      memoryScore: memoryScore ?? this.memoryScore,
      focusScore: focusScore ?? this.focusScore,
      reactionScore: reactionScore ?? this.reactionScore,
      summaryText: summaryText ?? this.summaryText,
      recommendationText: recommendationText ?? this.recommendationText,
      fortuneText: fortuneText ?? this.fortuneText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (memoryScore.present) {
      map['memory_score'] = Variable<double>(memoryScore.value);
    }
    if (focusScore.present) {
      map['focus_score'] = Variable<double>(focusScore.value);
    }
    if (reactionScore.present) {
      map['reaction_score'] = Variable<double>(reactionScore.value);
    }
    if (summaryText.present) {
      map['summary_text'] = Variable<String>(summaryText.value);
    }
    if (recommendationText.present) {
      map['recommendation_text'] = Variable<String>(recommendationText.value);
    }
    if (fortuneText.present) {
      map['fortune_text'] = Variable<String>(fortuneText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoreSummariesCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('memoryScore: $memoryScore, ')
          ..write('focusScore: $focusScore, ')
          ..write('reactionScore: $reactionScore, ')
          ..write('summaryText: $summaryText, ')
          ..write('recommendationText: $recommendationText, ')
          ..write('fortuneText: $fortuneText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DailyConditionsTable dailyConditions =
      $DailyConditionsTable(this);
  late final $TestResultsTable testResults = $TestResultsTable(this);
  late final $ScoreSummariesTable scoreSummaries = $ScoreSummariesTable(this);
  late final DailyConditionDao dailyConditionDao =
      DailyConditionDao(this as AppDatabase);
  late final TestResultDao testResultDao = TestResultDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dailyConditions, testResults, scoreSummaries];
}

typedef $$DailyConditionsTableCreateCompanionBuilder = DailyConditionsCompanion
    Function({
  Value<int> id,
  required String dateKey,
  Value<int> moodScore,
  Value<int> stressScore,
  Value<int?> anxietyScore,
  Value<int> motivationScore,
  Value<double?> sleepHours,
  Value<int?> sleepQuality,
  Value<String?> note,
  Value<DateTime> createdAt,
});
typedef $$DailyConditionsTableUpdateCompanionBuilder = DailyConditionsCompanion
    Function({
  Value<int> id,
  Value<String> dateKey,
  Value<int> moodScore,
  Value<int> stressScore,
  Value<int?> anxietyScore,
  Value<int> motivationScore,
  Value<double?> sleepHours,
  Value<int?> sleepQuality,
  Value<String?> note,
  Value<DateTime> createdAt,
});

class $$DailyConditionsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyConditionsTable> {
  $$DailyConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get moodScore => $composableBuilder(
      column: $table.moodScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stressScore => $composableBuilder(
      column: $table.stressScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get anxietyScore => $composableBuilder(
      column: $table.anxietyScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get motivationScore => $composableBuilder(
      column: $table.motivationScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sleepHours => $composableBuilder(
      column: $table.sleepHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sleepQuality => $composableBuilder(
      column: $table.sleepQuality, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DailyConditionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyConditionsTable> {
  $$DailyConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get moodScore => $composableBuilder(
      column: $table.moodScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stressScore => $composableBuilder(
      column: $table.stressScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get anxietyScore => $composableBuilder(
      column: $table.anxietyScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get motivationScore => $composableBuilder(
      column: $table.motivationScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sleepHours => $composableBuilder(
      column: $table.sleepHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sleepQuality => $composableBuilder(
      column: $table.sleepQuality,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DailyConditionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyConditionsTable> {
  $$DailyConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<int> get moodScore =>
      $composableBuilder(column: $table.moodScore, builder: (column) => column);

  GeneratedColumn<int> get stressScore => $composableBuilder(
      column: $table.stressScore, builder: (column) => column);

  GeneratedColumn<int> get anxietyScore => $composableBuilder(
      column: $table.anxietyScore, builder: (column) => column);

  GeneratedColumn<int> get motivationScore => $composableBuilder(
      column: $table.motivationScore, builder: (column) => column);

  GeneratedColumn<double> get sleepHours => $composableBuilder(
      column: $table.sleepHours, builder: (column) => column);

  GeneratedColumn<int> get sleepQuality => $composableBuilder(
      column: $table.sleepQuality, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DailyConditionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyConditionsTable,
    DailyCondition,
    $$DailyConditionsTableFilterComposer,
    $$DailyConditionsTableOrderingComposer,
    $$DailyConditionsTableAnnotationComposer,
    $$DailyConditionsTableCreateCompanionBuilder,
    $$DailyConditionsTableUpdateCompanionBuilder,
    (
      DailyCondition,
      BaseReferences<_$AppDatabase, $DailyConditionsTable, DailyCondition>
    ),
    DailyCondition,
    PrefetchHooks Function()> {
  $$DailyConditionsTableTableManager(
      _$AppDatabase db, $DailyConditionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyConditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> dateKey = const Value.absent(),
            Value<int> moodScore = const Value.absent(),
            Value<int> stressScore = const Value.absent(),
            Value<int?> anxietyScore = const Value.absent(),
            Value<int> motivationScore = const Value.absent(),
            Value<double?> sleepHours = const Value.absent(),
            Value<int?> sleepQuality = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DailyConditionsCompanion(
            id: id,
            dateKey: dateKey,
            moodScore: moodScore,
            stressScore: stressScore,
            anxietyScore: anxietyScore,
            motivationScore: motivationScore,
            sleepHours: sleepHours,
            sleepQuality: sleepQuality,
            note: note,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String dateKey,
            Value<int> moodScore = const Value.absent(),
            Value<int> stressScore = const Value.absent(),
            Value<int?> anxietyScore = const Value.absent(),
            Value<int> motivationScore = const Value.absent(),
            Value<double?> sleepHours = const Value.absent(),
            Value<int?> sleepQuality = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DailyConditionsCompanion.insert(
            id: id,
            dateKey: dateKey,
            moodScore: moodScore,
            stressScore: stressScore,
            anxietyScore: anxietyScore,
            motivationScore: motivationScore,
            sleepHours: sleepHours,
            sleepQuality: sleepQuality,
            note: note,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyConditionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyConditionsTable,
    DailyCondition,
    $$DailyConditionsTableFilterComposer,
    $$DailyConditionsTableOrderingComposer,
    $$DailyConditionsTableAnnotationComposer,
    $$DailyConditionsTableCreateCompanionBuilder,
    $$DailyConditionsTableUpdateCompanionBuilder,
    (
      DailyCondition,
      BaseReferences<_$AppDatabase, $DailyConditionsTable, DailyCondition>
    ),
    DailyCondition,
    PrefetchHooks Function()>;
typedef $$TestResultsTableCreateCompanionBuilder = TestResultsCompanion
    Function({
  Value<int> id,
  required String dateKey,
  required String testType,
  Value<double?> rawScore,
  required double normalizedScore,
  Value<double?> accuracy,
  Value<int?> reactionTimeAvg,
  Value<int?> reactionTimeSd,
  Value<String?> detailJson,
  Value<DateTime> createdAt,
});
typedef $$TestResultsTableUpdateCompanionBuilder = TestResultsCompanion
    Function({
  Value<int> id,
  Value<String> dateKey,
  Value<String> testType,
  Value<double?> rawScore,
  Value<double> normalizedScore,
  Value<double?> accuracy,
  Value<int?> reactionTimeAvg,
  Value<int?> reactionTimeSd,
  Value<String?> detailJson,
  Value<DateTime> createdAt,
});

class $$TestResultsTableFilterComposer
    extends Composer<_$AppDatabase, $TestResultsTable> {
  $$TestResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get testType => $composableBuilder(
      column: $table.testType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rawScore => $composableBuilder(
      column: $table.rawScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get normalizedScore => $composableBuilder(
      column: $table.normalizedScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reactionTimeAvg => $composableBuilder(
      column: $table.reactionTimeAvg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reactionTimeSd => $composableBuilder(
      column: $table.reactionTimeSd,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detailJson => $composableBuilder(
      column: $table.detailJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TestResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $TestResultsTable> {
  $$TestResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get testType => $composableBuilder(
      column: $table.testType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rawScore => $composableBuilder(
      column: $table.rawScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get normalizedScore => $composableBuilder(
      column: $table.normalizedScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reactionTimeAvg => $composableBuilder(
      column: $table.reactionTimeAvg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reactionTimeSd => $composableBuilder(
      column: $table.reactionTimeSd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detailJson => $composableBuilder(
      column: $table.detailJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TestResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestResultsTable> {
  $$TestResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<String> get testType =>
      $composableBuilder(column: $table.testType, builder: (column) => column);

  GeneratedColumn<double> get rawScore =>
      $composableBuilder(column: $table.rawScore, builder: (column) => column);

  GeneratedColumn<double> get normalizedScore => $composableBuilder(
      column: $table.normalizedScore, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<int> get reactionTimeAvg => $composableBuilder(
      column: $table.reactionTimeAvg, builder: (column) => column);

  GeneratedColumn<int> get reactionTimeSd => $composableBuilder(
      column: $table.reactionTimeSd, builder: (column) => column);

  GeneratedColumn<String> get detailJson => $composableBuilder(
      column: $table.detailJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TestResultsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TestResultsTable,
    TestResult,
    $$TestResultsTableFilterComposer,
    $$TestResultsTableOrderingComposer,
    $$TestResultsTableAnnotationComposer,
    $$TestResultsTableCreateCompanionBuilder,
    $$TestResultsTableUpdateCompanionBuilder,
    (TestResult, BaseReferences<_$AppDatabase, $TestResultsTable, TestResult>),
    TestResult,
    PrefetchHooks Function()> {
  $$TestResultsTableTableManager(_$AppDatabase db, $TestResultsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> dateKey = const Value.absent(),
            Value<String> testType = const Value.absent(),
            Value<double?> rawScore = const Value.absent(),
            Value<double> normalizedScore = const Value.absent(),
            Value<double?> accuracy = const Value.absent(),
            Value<int?> reactionTimeAvg = const Value.absent(),
            Value<int?> reactionTimeSd = const Value.absent(),
            Value<String?> detailJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TestResultsCompanion(
            id: id,
            dateKey: dateKey,
            testType: testType,
            rawScore: rawScore,
            normalizedScore: normalizedScore,
            accuracy: accuracy,
            reactionTimeAvg: reactionTimeAvg,
            reactionTimeSd: reactionTimeSd,
            detailJson: detailJson,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String dateKey,
            required String testType,
            Value<double?> rawScore = const Value.absent(),
            required double normalizedScore,
            Value<double?> accuracy = const Value.absent(),
            Value<int?> reactionTimeAvg = const Value.absent(),
            Value<int?> reactionTimeSd = const Value.absent(),
            Value<String?> detailJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              TestResultsCompanion.insert(
            id: id,
            dateKey: dateKey,
            testType: testType,
            rawScore: rawScore,
            normalizedScore: normalizedScore,
            accuracy: accuracy,
            reactionTimeAvg: reactionTimeAvg,
            reactionTimeSd: reactionTimeSd,
            detailJson: detailJson,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TestResultsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TestResultsTable,
    TestResult,
    $$TestResultsTableFilterComposer,
    $$TestResultsTableOrderingComposer,
    $$TestResultsTableAnnotationComposer,
    $$TestResultsTableCreateCompanionBuilder,
    $$TestResultsTableUpdateCompanionBuilder,
    (TestResult, BaseReferences<_$AppDatabase, $TestResultsTable, TestResult>),
    TestResult,
    PrefetchHooks Function()>;
typedef $$ScoreSummariesTableCreateCompanionBuilder = ScoreSummariesCompanion
    Function({
  Value<int> id,
  required String dateKey,
  Value<double> memoryScore,
  Value<double> focusScore,
  Value<double> reactionScore,
  Value<String?> summaryText,
  Value<String?> recommendationText,
  Value<String?> fortuneText,
  Value<DateTime> createdAt,
});
typedef $$ScoreSummariesTableUpdateCompanionBuilder = ScoreSummariesCompanion
    Function({
  Value<int> id,
  Value<String> dateKey,
  Value<double> memoryScore,
  Value<double> focusScore,
  Value<double> reactionScore,
  Value<String?> summaryText,
  Value<String?> recommendationText,
  Value<String?> fortuneText,
  Value<DateTime> createdAt,
});

class $$ScoreSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $ScoreSummariesTable> {
  $$ScoreSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get memoryScore => $composableBuilder(
      column: $table.memoryScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get focusScore => $composableBuilder(
      column: $table.focusScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get reactionScore => $composableBuilder(
      column: $table.reactionScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summaryText => $composableBuilder(
      column: $table.summaryText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recommendationText => $composableBuilder(
      column: $table.recommendationText,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fortuneText => $composableBuilder(
      column: $table.fortuneText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ScoreSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScoreSummariesTable> {
  $$ScoreSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateKey => $composableBuilder(
      column: $table.dateKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get memoryScore => $composableBuilder(
      column: $table.memoryScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get focusScore => $composableBuilder(
      column: $table.focusScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get reactionScore => $composableBuilder(
      column: $table.reactionScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summaryText => $composableBuilder(
      column: $table.summaryText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recommendationText => $composableBuilder(
      column: $table.recommendationText,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fortuneText => $composableBuilder(
      column: $table.fortuneText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ScoreSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScoreSummariesTable> {
  $$ScoreSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<double> get memoryScore => $composableBuilder(
      column: $table.memoryScore, builder: (column) => column);

  GeneratedColumn<double> get focusScore => $composableBuilder(
      column: $table.focusScore, builder: (column) => column);

  GeneratedColumn<double> get reactionScore => $composableBuilder(
      column: $table.reactionScore, builder: (column) => column);

  GeneratedColumn<String> get summaryText => $composableBuilder(
      column: $table.summaryText, builder: (column) => column);

  GeneratedColumn<String> get recommendationText => $composableBuilder(
      column: $table.recommendationText, builder: (column) => column);

  GeneratedColumn<String> get fortuneText => $composableBuilder(
      column: $table.fortuneText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ScoreSummariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScoreSummariesTable,
    ScoreSummary,
    $$ScoreSummariesTableFilterComposer,
    $$ScoreSummariesTableOrderingComposer,
    $$ScoreSummariesTableAnnotationComposer,
    $$ScoreSummariesTableCreateCompanionBuilder,
    $$ScoreSummariesTableUpdateCompanionBuilder,
    (
      ScoreSummary,
      BaseReferences<_$AppDatabase, $ScoreSummariesTable, ScoreSummary>
    ),
    ScoreSummary,
    PrefetchHooks Function()> {
  $$ScoreSummariesTableTableManager(
      _$AppDatabase db, $ScoreSummariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScoreSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScoreSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScoreSummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> dateKey = const Value.absent(),
            Value<double> memoryScore = const Value.absent(),
            Value<double> focusScore = const Value.absent(),
            Value<double> reactionScore = const Value.absent(),
            Value<String?> summaryText = const Value.absent(),
            Value<String?> recommendationText = const Value.absent(),
            Value<String?> fortuneText = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ScoreSummariesCompanion(
            id: id,
            dateKey: dateKey,
            memoryScore: memoryScore,
            focusScore: focusScore,
            reactionScore: reactionScore,
            summaryText: summaryText,
            recommendationText: recommendationText,
            fortuneText: fortuneText,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String dateKey,
            Value<double> memoryScore = const Value.absent(),
            Value<double> focusScore = const Value.absent(),
            Value<double> reactionScore = const Value.absent(),
            Value<String?> summaryText = const Value.absent(),
            Value<String?> recommendationText = const Value.absent(),
            Value<String?> fortuneText = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ScoreSummariesCompanion.insert(
            id: id,
            dateKey: dateKey,
            memoryScore: memoryScore,
            focusScore: focusScore,
            reactionScore: reactionScore,
            summaryText: summaryText,
            recommendationText: recommendationText,
            fortuneText: fortuneText,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScoreSummariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScoreSummariesTable,
    ScoreSummary,
    $$ScoreSummariesTableFilterComposer,
    $$ScoreSummariesTableOrderingComposer,
    $$ScoreSummariesTableAnnotationComposer,
    $$ScoreSummariesTableCreateCompanionBuilder,
    $$ScoreSummariesTableUpdateCompanionBuilder,
    (
      ScoreSummary,
      BaseReferences<_$AppDatabase, $ScoreSummariesTable, ScoreSummary>
    ),
    ScoreSummary,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DailyConditionsTableTableManager get dailyConditions =>
      $$DailyConditionsTableTableManager(_db, _db.dailyConditions);
  $$TestResultsTableTableManager get testResults =>
      $$TestResultsTableTableManager(_db, _db.testResults);
  $$ScoreSummariesTableTableManager get scoreSummaries =>
      $$ScoreSummariesTableTableManager(_db, _db.scoreSummaries);
}
