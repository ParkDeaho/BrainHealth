import 'package:drift/drift.dart';

import '../content/brain_health_knowledge.dart';
import '../../data/local/app_database.dart';

/// 로컬 AI 시스템 메시지: 앱 DB에서 읽은 요약만 근거로 조언하도록 맥락을 만듭니다.
class LocalAiContextBuilder {
  LocalAiContextBuilder._();

  static const _testTypeKo = <String, String>{
    'memory': '기억',
    'focus': '집중',
    'breathing': '호흡',
    'stroop': '스트룹',
    'cpt': '선택 집중',
    'reaction': '반응',
    'coordination': '협응',
    'numeracy': '셈하기',
    'shadow': '그림자 찾기',
    'maze': '미로',
  };

  static Future<String> buildSystemPrompt(
    AppDatabase db, {
    required String languageCode,
  }) async {
    final isKo = languageCode.toLowerCase().startsWith('ko');

    final conditions = await db.dailyConditionDao.getRecentConditions(21);
    conditions.sort((a, b) => b.dateKey.compareTo(a.dateKey));

    final tests = await (db.select(db.testResults)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(45))
        .get();

    final summaries = await (db.select(db.scoreSummaries)
          ..orderBy([(t) => OrderingTerm.desc(t.dateKey)])
          ..limit(10))
        .get();

    final buf = StringBuffer();

    if (isKo) {
      buf.writeln(
        '역할은 나의 뇌 건강 앱에 저장된 데이터만 근거로 생활 습관과 인지 활동에 대한 조언을 하는 것이다. '
        '의학적 진단이나 치료 처방은 하지 않는다. '
        '아래에 인용한 수치와 기록만 사실로 다루고, 없는 내용은 추측하지 않는다.',
      );
      buf.writeln(
        '응답 규칙: 사용자와 같은 언어로 답한다. '
        '문장만 사용한다. 별표 샵 따옴표 장식 가운데점 화살표 목록 기호 링크 문법 코드 기호는 쓰지 않는다. '
        '짧게 열두 문장 이내로 맞춘다.',
      );
      buf.writeln('');
      buf.writeln('앱 로컬 데이터베이스에서 읽은 요약이다.');
      buf.writeln('');

      if (conditions.isEmpty) {
        buf.writeln('마음 기록 요약: 저장된 최근 기록이 없다.');
      } else {
        buf.writeln('마음 기록 최근 ${conditions.length}건 날짜순 요약이다.');
        for (final c in conditions) {
          final anxiety = c.anxietyScore;
          buf.write(
            '날짜 ${c.dateKey} 기분 ${c.moodScore} 스트레스 ${c.stressScore} ',
          );
          buf.write('불안 ${anxiety ?? -1} 동기 ${c.motivationScore} ');
          if (c.sleepHours != null) {
            buf.write('수면시간 ${c.sleepHours} ');
          }
          if (c.sleepQuality != null) {
            buf.write('수면질 ${c.sleepQuality} ');
          }
          final note = c.note?.trim();
          if (note != null && note.isNotEmpty) {
            buf.write('메모 ${note.replaceAll(RegExp(r'\s+'), ' ')} ');
          }
          buf.writeln('');
        }
      }

      buf.writeln('');
      if (tests.isEmpty) {
        buf.writeln('측정 및 훈련 기록 요약: 저장된 최근 결과가 없다.');
      } else {
        buf.writeln('측정 및 훈련 기록 최근 ${tests.length}건이다.');
        for (final t in tests) {
          final label = _testTypeKo[t.testType] ?? t.testType;
          buf.write('날짜 ${t.dateKey} 유형 $label 정규화점수 ');
          buf.write(t.normalizedScore.toStringAsFixed(1));
          if (t.accuracy != null) {
            buf.write(' 정확도 ${t.accuracy!.toStringAsFixed(2)}');
          }
          buf.writeln('');
        }
      }

      buf.writeln('');
      if (summaries.isEmpty) {
        buf.writeln('일별 요약 텍스트: 없다.');
      } else {
        buf.writeln('일별 점수 요약 최근 ${summaries.length}건이다.');
        for (final s in summaries) {
          buf.write('날짜 ${s.dateKey} 기억 ${s.memoryScore.toStringAsFixed(1)} ');
          buf.write('집중 ${s.focusScore.toStringAsFixed(1)} ');
          buf.write('반응 ${s.reactionScore.toStringAsFixed(1)}');
          final st = s.summaryText?.trim();
          if (st != null && st.isNotEmpty) {
            buf.write(' 요약 ${st.replaceAll(RegExp(r'\s+'), ' ')}');
          }
          buf.writeln('');
        }
      }
    } else {
      buf.writeln(
        'You advise on lifestyle and cognitive habits using ONLY the data below from the user local app database. '
        'You do not provide medical diagnosis or prescriptions. '
        'Treat only quoted figures as facts.',
      );
      buf.writeln(
        'Reply in the user language. Use plain sentences only. '
        'Do not use asterisks, hash marks, bullets, link syntax, or code formatting. '
        'Keep under about 12 sentences.',
      );
      buf.writeln('');
      buf.writeln('Data snapshot from the app database:');
      buf.writeln('');
      if (conditions.isEmpty) {
        buf.writeln('Mood records: none.');
      } else {
        for (final c in conditions) {
          buf.writeln(
            '${c.dateKey} mood ${c.moodScore} stress ${c.stressScore} '
            'anxiety ${c.anxietyScore ?? -1} motivation ${c.motivationScore}',
          );
        }
      }
      buf.writeln('');
      if (tests.isEmpty) {
        buf.writeln('Tests: none.');
      } else {
        for (final t in tests) {
          buf.writeln(
            '${t.dateKey} ${t.testType} score ${t.normalizedScore.toStringAsFixed(1)}',
          );
        }
      }
      if (summaries.isNotEmpty) {
        buf.writeln('');
        for (final s in summaries) {
          buf.writeln(
            '${s.dateKey} memory ${s.memoryScore.toStringAsFixed(1)} '
            'focus ${s.focusScore.toStringAsFixed(1)} '
            'reaction ${s.reactionScore.toStringAsFixed(1)}',
          );
        }
      }
    }

    buf.writeln('');
    if (isKo) {
      buf.writeln(
        '다음 문단은 앱이 넣어 둔 일반 참고 지식이다. 의학적 진단이나 처방을 대체하지 않는다. '
        '사용자 데이터와 충돌하면 사용자 데이터와 이 앱의 면책 고지를 우선한다.',
      );
      buf.writeln(BrainHealthKnowledge.koPlain());
    } else {
      buf.writeln(
        'The following paragraphs are general educational context bundled with the app. '
        'They do not replace medical advice. If they conflict with user data, prioritize user data and disclaimers.',
      );
      buf.writeln(BrainHealthKnowledge.enPlain());
    }

    return buf.toString().trim();
  }
}
