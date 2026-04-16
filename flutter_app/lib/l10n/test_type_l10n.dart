import 'package:braintrain_flutter/l10n/app_localizations.dart';

String testTypeLabel(AppLocalizations l10n, String testType) {
  switch (testType) {
    case 'memory':
      return l10n.testTypeMemory;
    case 'focus':
      return l10n.testTypeFocus;
    case 'breathing':
      return l10n.testTypeBreathing;
    case 'stroop':
      return l10n.testTypeStroop;
    case 'cpt':
      return l10n.testTypeCpt;
    case 'reaction':
      return l10n.testTypeReaction;
    case 'coordination':
      return l10n.testTypeCoordination;
    case 'numeracy':
      return l10n.testTypeNumeracy;
    case 'shadow':
      return l10n.testTypeShadow;
    case 'maze':
      return l10n.testTypeMaze;
    default:
      return testType;
  }
}
