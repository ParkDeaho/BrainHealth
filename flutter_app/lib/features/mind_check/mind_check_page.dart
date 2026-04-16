import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mind_check_notifier.dart';

class MindCheckPage extends ConsumerStatefulWidget {
  const MindCheckPage({super.key});

  @override
  ConsumerState<MindCheckPage> createState() => _MindCheckPageState();
}

class _MindCheckPageState extends ConsumerState<MindCheckPage> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(mindCheckProvider.notifier).loadToday();
      if (!mounted) return;
      final state = ref.read(mindCheckProvider);
      _noteController.text = state.note;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(mindCheckProvider);
    final notifier = ref.read(mindCheckProvider.notifier);

    const sleepItems = <double>[
      4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0,
    ];
    final sleepValue = state.sleepHours ?? 7.0;
    final safeSleep = sleepItems.contains(sleepValue) ? sleepValue : 7.0;

    final moodLabels = [
      l10n.moodVeryBad,
      l10n.moodBad,
      l10n.moodNeutral,
      l10n.moodGood,
      l10n.moodVeryGood,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mindRecordTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle(l10n.mindMoodTitle),
          _EmojiScoreSelector(
            value: state.mood,
            onChanged: notifier.setMood,
            labels: moodLabels,
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.mindStressTitle),
          _ScoreSlider(
            value: state.stress.toDouble(),
            onChanged: (v) => notifier.setStress(v.toInt()),
            l10n: l10n,
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.mindAnxietyTitle),
          _ScoreSlider(
            value: state.anxiety.toDouble(),
            onChanged: (v) => notifier.setAnxiety(v.toInt()),
            l10n: l10n,
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.mindMotivationTitle),
          _ScoreSlider(
            value: state.motivation.toDouble(),
            onChanged: (v) => notifier.setMotivation(v.toInt()),
            l10n: l10n,
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.mindSleepTitle),
          DropdownButtonFormField<double>(
            initialValue: safeSleep,
            items: sleepItems
                .map(
                  (h) => DropdownMenuItem(
                    value: h,
                    child: Text(l10n.sleepHoursItem(h.toStringAsFixed(1))),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) notifier.setSleepHours(value);
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: l10n.sleepHoursHint,
            ),
          ),
          const SizedBox(height: 24),
          _SectionTitle(l10n.mindNoteTitle),
          TextField(
            controller: _noteController,
            maxLines: 3,
            onChanged: notifier.setNote,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: l10n.mindNoteHint,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              await notifier.save();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.mindSaveDone)),
              );
            },
            child: Text(l10n.mindSave),
          ),
          if (state.isSaved) ...[
            const SizedBox(height: 12),
            Text(
              l10n.mindSavedHint,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmojiScoreSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final List<String> labels;

  const _EmojiScoreSelector({
    required this.value,
    required this.onChanged,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    const emojis = ['😣', '😟', '😐', '🙂', '😄'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 4,
          runSpacing: 8,
          children: List.generate(5, (index) {
            final score = index + 1;
            final selected = value == score;

            return GestureDetector(
              onTap: () => onChanged(score),
              child: Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selected ? Colors.blue : Colors.grey.shade300,
                    width: selected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      emojis[index],
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 9),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ScoreSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final AppLocalizations l10n;

  const _ScoreSlider({
    required this.value,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          label: value.toInt().toString(),
          onChanged: onChanged,
        ),
        Text(
          l10n.mindScoreCurrent(value.toInt()),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
