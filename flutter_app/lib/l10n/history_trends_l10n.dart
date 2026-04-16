import 'package:braintrain_flutter/l10n/app_localizations.dart';

import '../domain/services/history_trends_service.dart';

String _fmt(double? v) => v == null ? '—' : '${v.round()}';

String _shortDate(String dateKey) {
  final parts = dateKey.split('-');
  if (parts.length == 3) {
    return '${parts[1]}.${parts[2]}';
  }
  return dateKey;
}

extension HistoryTrendsResultL10n on HistoryTrendsResult {
  String _deltaWord(AppLocalizations l10n, double d) {
    if (d.abs() < 1.5) return l10n.trendDeltaFlat;
    return d > 0 ? l10n.trendDeltaUp : l10n.trendDeltaDown;
  }

  List<String> localizedBullets(AppLocalizations l10n) {
    final lines = <String>[];
    if (totalTests == 0 && dailyConditionDays == 0) {
      lines.add(l10n.trendNoRecords);
      return lines;
    }
    if (totalTests > 0) {
      lines.add(l10n.trendAccumulated(totalTests, distinctDays));
    }
    if (dailyConditionDays > 0) {
      lines.add(l10n.trendMindDays(dailyConditionDays));
    }
    if (!canCompareDays) {
      if (distinctDays < 2 && totalTests > 0) {
        lines.add(l10n.trendNeedMoreDays);
      }
      if (moodFirst != null && moodLast != null && dailyConditionDays >= 2) {
        lines.add(l10n.trendMoodFirstLast(moodFirst!, moodLast!));
      }
      return lines;
    }
    final f = first!;
    final l = last!;
    lines.add(
      l10n.trendCompare(_shortDate(f.dateKey), _shortDate(l.dateKey)),
    );
    if (f.memory != null && l.memory != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameMemory,
          _fmt(f.memory),
          _fmt(l.memory),
          _deltaWord(l10n, l.memory! - f.memory!),
        ),
      );
    }
    if (f.focus != null && l.focus != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameFocus,
          _fmt(f.focus),
          _fmt(l.focus),
          _deltaWord(l10n, l.focus! - f.focus!),
        ),
      );
    }
    if (f.reaction != null && l.reaction != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameReaction,
          _fmt(f.reaction),
          _fmt(l.reaction),
          _deltaWord(l10n, l.reaction! - f.reaction!),
        ),
      );
    }
    if (f.coordination != null && l.coordination != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameCoordination,
          _fmt(f.coordination),
          _fmt(l.coordination),
          _deltaWord(l10n, l.coordination! - f.coordination!),
        ),
      );
    }
    if (f.numeracy != null && l.numeracy != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameNumeracy,
          _fmt(f.numeracy),
          _fmt(l.numeracy),
          _deltaWord(l10n, l.numeracy! - f.numeracy!),
        ),
      );
    }
    if (f.reasoning != null && l.reasoning != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameReasoning,
          _fmt(f.reasoning),
          _fmt(l.reasoning),
          _deltaWord(l10n, l.reasoning! - f.reasoning!),
        ),
      );
    }
    if (f.spatial != null && l.spatial != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameSpatial,
          _fmt(f.spatial),
          _fmt(l.spatial),
          _deltaWord(l10n, l.spatial! - f.spatial!),
        ),
      );
    }
    if (f.dementiaHint != null && l.dementiaHint != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameDementia,
          _fmt(f.dementiaHint),
          _fmt(l.dementiaHint),
          _deltaWord(l10n, l.dementiaHint! - f.dementiaHint!),
        ),
      );
    }
    if (f.learningHint != null && l.learningHint != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameLearning,
          _fmt(f.learningHint),
          _fmt(l.learningHint),
          _deltaWord(l10n, l.learningHint! - f.learningHint!),
        ),
      );
    }
    if (f.emotionalHint != null && l.emotionalHint != null) {
      lines.add(
        l10n.trendPillarLine(
          l10n.trendNameEmotional,
          _fmt(f.emotionalHint),
          _fmt(l.emotionalHint),
          _deltaWord(l10n, l.emotionalHint! - f.emotionalHint!),
        ),
      );
    }
    if (moodFirst != null && moodLast != null) {
      lines.add(l10n.trendMoodRecord(moodFirst!, moodLast!));
    }
    return lines;
  }
}
