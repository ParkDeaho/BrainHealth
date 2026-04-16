import 'package:braintrain_flutter/l10n/app_localizations.dart';

import '../../core/utils/date_utils.dart';
import '../../data/local/app_database.dart';
import '../models/analysis_result.dart';
import 'mind_insight_engine.dart';

/// 오늘 날짜 기준 마음 기록 + 테스트 결과 결합 분석
class TodayAnalysisService {
  TodayAnalysisService._();

  static Future<AnalysisResult> load(AppDatabase db, AppLocalizations l10n) async {
    final dateKey = toDateKey(DateTime.now());
    final daily = await db.dailyConditionDao.getByDateKey(dateKey);
    final tests = await db.testResultDao.getResultsByDate(dateKey);
    return MindInsightEngine.generate(
      dailyCondition: daily,
      todayTests: tests,
      l10n: l10n,
    );
  }
}
