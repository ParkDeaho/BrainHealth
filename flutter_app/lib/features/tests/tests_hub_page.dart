import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../coordination/coordination_screen.dart';
import '../training/screens/maze_training_screen.dart';
import '../training/screens/numeracy_training_screen.dart';
import '../training/screens/shadow_match_screen.dart';
import 'screens/cpt_screen.dart';
import 'screens/digit_span_screen.dart';
import 'screens/reaction_screen.dart';
import 'screens/stroop_screen.dart';
import 'screens/visual_pattern_screen.dart';
import 'screens/word_memory_screen.dart';

/// 인지 측정 허브
class TestsHubPage extends StatelessWidget {
  const TestsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final items = <_TestItem>[
      _TestItem(
        l10n.testWordMemoryTitle,
        l10n.testWordMemoryDesc,
        '📝',
        const WordMemoryScreen(),
        [l10n.tagDementia, l10n.tagLearning],
      ),
      _TestItem(
        l10n.testDigitSpanTitle,
        l10n.testDigitSpanDesc,
        '🔄',
        const DigitSpanScreen(),
        [l10n.tagDementia, l10n.tagLearning],
      ),
      _TestItem(
        l10n.testVisualPatternTitle,
        l10n.testVisualPatternDesc,
        '🔲',
        const VisualPatternScreen(),
        [l10n.tagDementia, l10n.tagLearning],
      ),
      _TestItem(
        l10n.testStroopTitle,
        l10n.testStroopDesc,
        '🎨',
        const StroopScreen(),
        [l10n.tagLearning, l10n.tagFocus],
      ),
      _TestItem(
        l10n.testReactionTitle,
        l10n.testReactionDesc,
        '⚡',
        const ReactionScreen(),
        [l10n.tagDementia, l10n.tagLearning],
      ),
      _TestItem(
        l10n.testCoordinationTitle,
        l10n.testCoordinationDesc,
        '🤝',
        const CoordinationScreen(isTraining: false),
        [l10n.tagDementia, l10n.tagLearning, l10n.tagCoordination],
      ),
      _TestItem(
        l10n.testCptTitle,
        l10n.testCptDesc,
        '🔤',
        const CptScreen(),
        [l10n.tagLearning, l10n.tagFocus],
      ),
      _TestItem(
        l10n.trainNumeracyTitle,
        l10n.testMeasureNumeracyDesc,
        '🔢',
        const NumeracyTrainingScreen(),
        [l10n.tagLearning, l10n.tagNumeracy, l10n.tagDementia],
      ),
      _TestItem(
        l10n.trainShadowTitle,
        l10n.testMeasureShadowDesc,
        '👤',
        const ShadowMatchScreen(),
        [l10n.tagLearning, l10n.tagReasoning],
      ),
      _TestItem(
        l10n.trainMazeTitle,
        l10n.testMeasureMazeDesc,
        '🧭',
        const MazeTrainingScreen(),
        [l10n.tagDementia, l10n.tagSpatial],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.testsHubTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final t = items[i];
          return Card(
            child: ListTile(
              isThreeLine: true,
              leading: Text(t.icon, style: const TextStyle(fontSize: 28)),
              title: Text(t.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.desc),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: t.tags
                        .map(
                          (s) => Chip(
                            label: Text(
                              s,
                              style: const TextStyle(fontSize: 11),
                            ),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (_) => t.screen),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TestItem {
  const _TestItem(
    this.title,
    this.desc,
    this.icon,
    this.screen,
    this.tags,
  );

  final String title;
  final String desc;
  final String icon;
  final Widget screen;
  final List<String> tags;
}
