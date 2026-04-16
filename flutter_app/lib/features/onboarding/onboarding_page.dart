import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../core/storage/app_prefs.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
    required this.onComplete,
  });

  final VoidCallback onComplete;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  String _mode = 'general';

  Future<void> _finish() async {
    await AppPrefs.setUserMode(_mode);
    await AppPrefs.setOnboarded(true);
    if (!mounted) return;
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                l10n.onboardingTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.onboardingSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              _ModeCard(
                selected: _mode == 'senior',
                icon: '🧠',
                title: l10n.onboardingSeniorTitle,
                subtitle: l10n.onboardingSeniorSubtitle,
                onTap: () => setState(() => _mode = 'senior'),
              ),
              const SizedBox(height: 12),
              _ModeCard(
                selected: _mode == 'student',
                icon: '🎯',
                title: l10n.onboardingStudentTitle,
                subtitle: l10n.onboardingStudentSubtitle,
                onTap: () => setState(() => _mode = 'student'),
              ),
              const SizedBox(height: 12),
              _ModeCard(
                selected: _mode == 'general',
                icon: '💡',
                title: l10n.onboardingGeneralTitle,
                subtitle: l10n.onboardingGeneralSubtitle,
                onTap: () => setState(() => _mode = 'general'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: _finish,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(l10n.onboardingStart),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? scheme.primaryContainer.withValues(alpha: 0.55)
          : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: scheme.primary)
              else
                Icon(Icons.circle_outlined, color: scheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
