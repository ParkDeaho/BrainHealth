import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../coordination/coordination_screen.dart';
import 'screens/breathing_screen.dart';
import 'screens/card_match_screen.dart';
import 'screens/maze_training_screen.dart';
import 'screens/nback_screen.dart';
import 'screens/numeracy_training_screen.dart';
import 'screens/selective_focus_screen.dart';
import 'screens/sequence_memory_screen.dart';
import 'screens/shadow_match_screen.dart';

/// 뇌 훈련 게임 허브
class TrainingHubPage extends StatelessWidget {
  const TrainingHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final items = <_TrainItem>[
      _TrainItem(
        l10n.trainCardMatchTitle,
        l10n.trainCardMatchDesc,
        '🃏',
        const CardMatchScreen(),
        [l10n.tagDementia, l10n.tagLearning],
      ),
      _TrainItem(
        l10n.trainNbackTitle,
        l10n.trainNbackDesc,
        '🧩',
        const NBackScreen(),
        [l10n.tagLearning, l10n.tagFocus],
      ),
      _TrainItem(
        l10n.trainSequenceTitle,
        l10n.trainSequenceDesc,
        '🎵',
        const SequenceMemoryScreen(),
        [l10n.tagDementia, l10n.tagLearning],
      ),
      _TrainItem(
        l10n.trainSelectiveTitle,
        l10n.trainSelectiveDesc,
        '⭐',
        const SelectiveFocusScreen(),
        [l10n.tagLearning],
      ),
      _TrainItem(
        l10n.trainCoordinationTitle,
        l10n.trainCoordinationDesc,
        '🤝',
        const CoordinationScreen(isTraining: true),
        [l10n.tagDementia, l10n.tagLearning, l10n.tagCoordination],
      ),
      _TrainItem(
        l10n.trainNumeracyTitle,
        l10n.trainNumeracyDesc,
        '🔢',
        const NumeracyTrainingScreen(),
        [l10n.tagLearning, l10n.tagNumeracy],
      ),
      _TrainItem(
        l10n.trainShadowTitle,
        l10n.trainShadowDesc,
        '👤',
        const ShadowMatchScreen(),
        [l10n.tagLearning, l10n.tagReasoning],
      ),
      _TrainItem(
        l10n.trainMazeTitle,
        l10n.trainMazeDesc,
        '🧭',
        const MazeTrainingScreen(),
        [l10n.tagDementia, l10n.tagSpatial],
      ),
      _TrainItem(
        l10n.trainBreathingTitle,
        l10n.trainBreathingDesc,
        '🧘',
        const BreathingScreen(),
        [l10n.tagEmotionalSleep, l10n.tagStressMood],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.trainingHubTitle)),
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

class _TrainItem {
  const _TrainItem(
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
