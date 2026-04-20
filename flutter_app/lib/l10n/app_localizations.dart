import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain Health'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabTests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get tabTests;

  /// No description provided for @tabTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get tabTraining;

  /// No description provided for @tabReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get tabReport;

  /// No description provided for @tabMy.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabMy;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @mindRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s mood log'**
  String get mindRecordTitle;

  /// No description provided for @mindRecordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log once a day — it feeds into your analysis.'**
  String get mindRecordSubtitle;

  /// No description provided for @reactionShortcutTitle.
  ///
  /// In en, this message translates to:
  /// **'Reaction speed test'**
  String get reactionShortcutTitle;

  /// No description provided for @reactionShortcutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start now · tap when the screen turns green (5 rounds)'**
  String get reactionShortcutSubtitle;

  /// No description provided for @homeQuickMeasureTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick cognitive checks'**
  String get homeQuickMeasureTitle;

  /// No description provided for @homeQuickMeasureNumeracySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Numeracy reaction — same task as on the Measure tab'**
  String get homeQuickMeasureNumeracySubtitle;

  /// No description provided for @homeQuickMeasureShadowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visual reasoning — same task as on the Measure tab'**
  String get homeQuickMeasureShadowSubtitle;

  /// No description provided for @homeQuickMeasureMazeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Path planning — same task as on the Measure tab'**
  String get homeQuickMeasureMazeSubtitle;

  /// No description provided for @wellnessSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus areas (reference)'**
  String get wellnessSectionTitle;

  /// No description provided for @summaryCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s takeaway'**
  String get summaryCardTitle;

  /// No description provided for @recommendationCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get recommendationCardTitle;

  /// No description provided for @reportSectionFlow.
  ///
  /// In en, this message translates to:
  /// **'Today\'s flow'**
  String get reportSectionFlow;

  /// No description provided for @reportDementiaSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Dementia prevention (reference)'**
  String get reportDementiaSectionTitle;

  /// No description provided for @reportDementiaSectionBody.
  ///
  /// In en, this message translates to:
  /// **'Dementia cannot be diagnosed from a single score, and this app does not predict or diagnose disease. Research and lifestyle guidance often mention sleep, light exercise, social connection, and mentally stimulating activities as helpful for long-term brain health. If you notice memory or thinking changes that worry you, see a clinician.'**
  String get reportDementiaSectionBody;

  /// No description provided for @flowCardTitlePrefix.
  ///
  /// In en, this message translates to:
  /// **'Today\'s flow: '**
  String get flowCardTitlePrefix;

  /// No description provided for @reportNoData.
  ///
  /// In en, this message translates to:
  /// **'No analysis data yet. Log your mood or add a test.'**
  String get reportNoData;

  /// No description provided for @reportPillarsTitle.
  ///
  /// In en, this message translates to:
  /// **'Four pillars (today\'s tests & training)'**
  String get reportPillarsTitle;

  /// No description provided for @reportDetailPillarsTitle.
  ///
  /// In en, this message translates to:
  /// **'Detailed cognition (training · numeracy · reasoning · spatial)'**
  String get reportDetailPillarsTitle;

  /// No description provided for @reportWellnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus areas (tests, training & mood)'**
  String get reportWellnessTitle;

  /// No description provided for @reportDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These numbers are for self-care reference only. They are not medical advice.'**
  String get reportDisclaimer;

  /// No description provided for @reportActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tests & training'**
  String get reportActivityTitle;

  /// No description provided for @reportActivityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tests or training saved for today. Complete one from Home to see it here.'**
  String get reportActivityEmpty;

  /// No description provided for @pillMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get pillMemory;

  /// No description provided for @pillFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get pillFocus;

  /// No description provided for @pillReaction.
  ///
  /// In en, this message translates to:
  /// **'Reaction'**
  String get pillReaction;

  /// No description provided for @pillCoordination.
  ///
  /// In en, this message translates to:
  /// **'Coordination'**
  String get pillCoordination;

  /// No description provided for @pillNumeracy.
  ///
  /// In en, this message translates to:
  /// **'Numeracy'**
  String get pillNumeracy;

  /// No description provided for @pillReasoning.
  ///
  /// In en, this message translates to:
  /// **'Reasoning'**
  String get pillReasoning;

  /// No description provided for @pillSpatial.
  ///
  /// In en, this message translates to:
  /// **'Spatial'**
  String get pillSpatial;

  /// No description provided for @pillDementia.
  ///
  /// In en, this message translates to:
  /// **'Brain health'**
  String get pillDementia;

  /// No description provided for @pillLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get pillLearning;

  /// No description provided for @pillEmotional.
  ///
  /// In en, this message translates to:
  /// **'Mood & sleep'**
  String get pillEmotional;

  /// No description provided for @pillNoTestToday.
  ///
  /// In en, this message translates to:
  /// **'{label} (no test today)'**
  String pillNoTestToday(Object label);

  /// No description provided for @myPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get myPageTitle;

  /// No description provided for @selectedMode.
  ///
  /// In en, this message translates to:
  /// **'Selected mode'**
  String get selectedMode;

  /// No description provided for @modeSenior.
  ///
  /// In en, this message translates to:
  /// **'Memory / prevention'**
  String get modeSenior;

  /// No description provided for @modeStudent.
  ///
  /// In en, this message translates to:
  /// **'Focus / study'**
  String get modeStudent;

  /// No description provided for @modeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get modeGeneral;

  /// No description provided for @trendsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress (first → latest)'**
  String get trendsSectionTitle;

  /// No description provided for @appInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get appInfoTitle;

  /// No description provided for @appInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Brain health · stored on device'**
  String get appInfoSubtitle;

  /// No description provided for @onboardingReplayTitle.
  ///
  /// In en, this message translates to:
  /// **'Show onboarding again'**
  String get onboardingReplayTitle;

  /// No description provided for @onboardingReplayBody.
  ///
  /// In en, this message translates to:
  /// **'Return to the first-time setup. Continue?'**
  String get onboardingReplayBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get confirm;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain Health'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Healthy habits start with small daily steps.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingSeniorTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory / prevention'**
  String get onboardingSeniorTitle;

  /// No description provided for @onboardingSeniorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adults · memory care · cognitive habits'**
  String get onboardingSeniorSubtitle;

  /// No description provided for @onboardingStudentTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus / study'**
  String get onboardingStudentTitle;

  /// No description provided for @onboardingStudentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Students · focus · study routine'**
  String get onboardingStudentSubtitle;

  /// No description provided for @onboardingGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get onboardingGeneralTitle;

  /// No description provided for @onboardingGeneralSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Overall brain wellness'**
  String get onboardingGeneralSubtitle;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @testsHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Cognitive tests'**
  String get testsHubTitle;

  /// No description provided for @trainingHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain training'**
  String get trainingHubTitle;

  /// No description provided for @testWordMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Word memory'**
  String get testWordMemoryTitle;

  /// No description provided for @testWordMemoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Memorize and recall 5 words'**
  String get testWordMemoryDesc;

  /// No description provided for @testDigitSpanTitle.
  ///
  /// In en, this message translates to:
  /// **'Digit span'**
  String get testDigitSpanTitle;

  /// No description provided for @testDigitSpanDesc.
  ///
  /// In en, this message translates to:
  /// **'Remember digits in reverse order'**
  String get testDigitSpanDesc;

  /// No description provided for @testVisualPatternTitle.
  ///
  /// In en, this message translates to:
  /// **'Visual pattern'**
  String get testVisualPatternTitle;

  /// No description provided for @testVisualPatternDesc.
  ///
  /// In en, this message translates to:
  /// **'Recall lit cells on the grid'**
  String get testVisualPatternDesc;

  /// No description provided for @testStroopTitle.
  ///
  /// In en, this message translates to:
  /// **'Stroop'**
  String get testStroopTitle;

  /// No description provided for @testStroopDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick the ink color quickly'**
  String get testStroopDesc;

  /// No description provided for @testReactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reaction time'**
  String get testReactionTitle;

  /// No description provided for @testReactionDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap as soon as the screen changes'**
  String get testReactionDesc;

  /// No description provided for @testCptTitle.
  ///
  /// In en, this message translates to:
  /// **'Sustained attention (CPT)'**
  String get testCptTitle;

  /// No description provided for @testCptDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap when you see X'**
  String get testCptDesc;

  /// No description provided for @testMeasureNumeracyDesc.
  ///
  /// In en, this message translates to:
  /// **'Short numeracy reaction test with addition and subtraction (10 items). Same task as Quick math on the Train tab.'**
  String get testMeasureNumeracyDesc;

  /// No description provided for @testMeasureShadowDesc.
  ///
  /// In en, this message translates to:
  /// **'Visual reasoning: pick the matching silhouette (8 rounds). Same task as Find the shadow on the Train tab.'**
  String get testMeasureShadowDesc;

  /// No description provided for @testMeasureMazeDesc.
  ///
  /// In en, this message translates to:
  /// **'Path planning to the exit by tapping adjacent cells. Same task as Maze on the Train tab.'**
  String get testMeasureMazeDesc;

  /// No description provided for @testCoordinationTitle.
  ///
  /// In en, this message translates to:
  /// **'Left–right coordination'**
  String get testCoordinationTitle;

  /// No description provided for @testCoordinationDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the highlighted side quickly (12 rounds)'**
  String get testCoordinationDesc;

  /// No description provided for @trainCoordinationTitle.
  ///
  /// In en, this message translates to:
  /// **'Coordination practice'**
  String get trainCoordinationTitle;

  /// No description provided for @trainCoordinationDesc.
  ///
  /// In en, this message translates to:
  /// **'Hand–eye coordination · short rounds (8)'**
  String get trainCoordinationDesc;

  /// No description provided for @trainNumeracyTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick math'**
  String get trainNumeracyTitle;

  /// No description provided for @trainNumeracyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add & subtract to train numeracy (10 items)'**
  String get trainNumeracyDesc;

  /// No description provided for @trainShadowTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the shadow'**
  String get trainShadowTitle;

  /// No description provided for @trainShadowDesc.
  ///
  /// In en, this message translates to:
  /// **'Pick the matching silhouette · problem solving (8 rounds)'**
  String get trainShadowDesc;

  /// No description provided for @trainMazeTitle.
  ///
  /// In en, this message translates to:
  /// **'Maze'**
  String get trainMazeTitle;

  /// No description provided for @trainMazeDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap adjacent path cells to the flag · spatial route (presets)'**
  String get trainMazeDesc;

  /// No description provided for @tagCoordination.
  ///
  /// In en, this message translates to:
  /// **'Coordination'**
  String get tagCoordination;

  /// No description provided for @tagNumeracy.
  ///
  /// In en, this message translates to:
  /// **'Numeracy'**
  String get tagNumeracy;

  /// No description provided for @tagReasoning.
  ///
  /// In en, this message translates to:
  /// **'Reasoning'**
  String get tagReasoning;

  /// No description provided for @tagSpatial.
  ///
  /// In en, this message translates to:
  /// **'Spatial'**
  String get tagSpatial;

  /// No description provided for @coordinationAppBar.
  ///
  /// In en, this message translates to:
  /// **'Left–right coordination'**
  String get coordinationAppBar;

  /// No description provided for @coordinationInstructions.
  ///
  /// In en, this message translates to:
  /// **'When the cue appears, tap the highlighted side (left or right). Wrong side or too slow counts as a miss.'**
  String get coordinationInstructions;

  /// No description provided for @coordinationPrepare.
  ///
  /// In en, this message translates to:
  /// **'Get ready…'**
  String get coordinationPrepare;

  /// No description provided for @coordinationCueLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get coordinationCueLeft;

  /// No description provided for @coordinationCueRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get coordinationCueRight;

  /// No description provided for @coordinationRoundProgress.
  ///
  /// In en, this message translates to:
  /// **'Round {n} / {total}'**
  String coordinationRoundProgress(Object n, Object total);

  /// No description provided for @coordinationSnackDone.
  ///
  /// In en, this message translates to:
  /// **'Avg {avgMs} ms · accuracy {accPct}% · {score} pts'**
  String coordinationSnackDone(Object avgMs, Object accPct, Object score);

  /// No description provided for @numeracyAppBar.
  ///
  /// In en, this message translates to:
  /// **'Quick math'**
  String get numeracyAppBar;

  /// No description provided for @numeracyInstructions.
  ///
  /// In en, this message translates to:
  /// **'Pick the correct answer. Accuracy and response time affect your score.'**
  String get numeracyInstructions;

  /// No description provided for @numeracyProgress.
  ///
  /// In en, this message translates to:
  /// **'Item {n} / {total}'**
  String numeracyProgress(Object n, Object total);

  /// No description provided for @numeracySnackDone.
  ///
  /// In en, this message translates to:
  /// **'Correct {correct} / {total} · {score} pts'**
  String numeracySnackDone(Object correct, Object total, Object score);

  /// No description provided for @shadowAppBar.
  ///
  /// In en, this message translates to:
  /// **'Find the shadow'**
  String get shadowAppBar;

  /// No description provided for @shadowInstructions.
  ///
  /// In en, this message translates to:
  /// **'Choose the filled silhouette that matches the outline above.'**
  String get shadowInstructions;

  /// No description provided for @shadowProgress.
  ///
  /// In en, this message translates to:
  /// **'Round {n} / {total}'**
  String shadowProgress(Object n, Object total);

  /// No description provided for @shadowTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Which shadow matches?'**
  String get shadowTargetLabel;

  /// No description provided for @shadowPickLabel.
  ///
  /// In en, this message translates to:
  /// **'Choices'**
  String get shadowPickLabel;

  /// No description provided for @shadowSnackDone.
  ///
  /// In en, this message translates to:
  /// **'Correct {correct} / {total} · {score} pts'**
  String shadowSnackDone(Object correct, Object total, Object score);

  /// No description provided for @mazeAppBar.
  ///
  /// In en, this message translates to:
  /// **'Maze'**
  String get mazeAppBar;

  /// No description provided for @mazeInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap adjacent open cells to reach the flag. Walls (#) block you.'**
  String get mazeInstructions;

  /// No description provided for @mazeMoves.
  ///
  /// In en, this message translates to:
  /// **'Moves: {n}'**
  String mazeMoves(Object n);

  /// No description provided for @mazeSnackDone.
  ///
  /// In en, this message translates to:
  /// **'{moves} moves (shortest {shortest}) · {score} pts'**
  String mazeSnackDone(Object moves, Object shortest, Object score);

  /// No description provided for @mazeNewPuzzle.
  ///
  /// In en, this message translates to:
  /// **'New maze'**
  String get mazeNewPuzzle;

  /// No description provided for @tagDementia.
  ///
  /// In en, this message translates to:
  /// **'Brain health'**
  String get tagDementia;

  /// No description provided for @tagLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get tagLearning;

  /// No description provided for @tagFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get tagFocus;

  /// No description provided for @trainCardMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Card match'**
  String get trainCardMatchTitle;

  /// No description provided for @trainCardMatchDesc.
  ///
  /// In en, this message translates to:
  /// **'Find matching pairs'**
  String get trainCardMatchDesc;

  /// No description provided for @trainNbackTitle.
  ///
  /// In en, this message translates to:
  /// **'N-back'**
  String get trainNbackTitle;

  /// No description provided for @trainNbackDesc.
  ///
  /// In en, this message translates to:
  /// **'Decide if it matches N steps back'**
  String get trainNbackDesc;

  /// No description provided for @trainSequenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Sequence memory'**
  String get trainSequenceTitle;

  /// No description provided for @trainSequenceDesc.
  ///
  /// In en, this message translates to:
  /// **'Remember and replay the light order'**
  String get trainSequenceDesc;

  /// No description provided for @trainSelectiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Selective attention'**
  String get trainSelectiveTitle;

  /// No description provided for @trainSelectiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap only the target shape'**
  String get trainSelectiveDesc;

  /// No description provided for @trainBreathingTitle.
  ///
  /// In en, this message translates to:
  /// **'Breathing · focus reset'**
  String get trainBreathingTitle;

  /// No description provided for @trainBreathingDesc.
  ///
  /// In en, this message translates to:
  /// **'1 min breathing · mic or manual'**
  String get trainBreathingDesc;

  /// No description provided for @tagEmotionalSleep.
  ///
  /// In en, this message translates to:
  /// **'Mood & sleep'**
  String get tagEmotionalSleep;

  /// No description provided for @tagStressMood.
  ///
  /// In en, this message translates to:
  /// **'Stress & low mood self-care'**
  String get tagStressMood;

  /// No description provided for @mindMoodTitle.
  ///
  /// In en, this message translates to:
  /// **'How is your mood today?'**
  String get mindMoodTitle;

  /// No description provided for @mindStressTitle.
  ///
  /// In en, this message translates to:
  /// **'Stress level today?'**
  String get mindStressTitle;

  /// No description provided for @mindAnxietyTitle.
  ///
  /// In en, this message translates to:
  /// **'How anxious do you feel?'**
  String get mindAnxietyTitle;

  /// No description provided for @mindMotivationTitle.
  ///
  /// In en, this message translates to:
  /// **'How motivated do you feel?'**
  String get mindMotivationTitle;

  /// No description provided for @mindSleepTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep last night'**
  String get mindSleepTitle;

  /// No description provided for @mindNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Short note'**
  String get mindNoteTitle;

  /// No description provided for @mindNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Busy day, felt scattered'**
  String get mindNoteHint;

  /// No description provided for @mindSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get mindSave;

  /// No description provided for @mindSavedHint.
  ///
  /// In en, this message translates to:
  /// **'Today\'s log is saved and used in analysis.'**
  String get mindSavedHint;

  /// No description provided for @mindSaveDone.
  ///
  /// In en, this message translates to:
  /// **'Saved.'**
  String get mindSaveDone;

  /// No description provided for @mindScoreCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current score: {n}'**
  String mindScoreCurrent(Object n);

  /// No description provided for @sleepHoursItem.
  ///
  /// In en, this message translates to:
  /// **'{h} h'**
  String sleepHoursItem(Object h);

  /// No description provided for @moodVeryBad.
  ///
  /// In en, this message translates to:
  /// **'Very bad'**
  String get moodVeryBad;

  /// No description provided for @moodBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get moodBad;

  /// No description provided for @moodNeutral.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get moodNeutral;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get moodVeryGood;

  /// No description provided for @sleepHoursHint.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get sleepHoursHint;

  /// No description provided for @reactionAppBar.
  ///
  /// In en, this message translates to:
  /// **'Reaction time'**
  String get reactionAppBar;

  /// No description provided for @reactionTapWhenGreen.
  ///
  /// In en, this message translates to:
  /// **'Tap!'**
  String get reactionTapWhenGreen;

  /// No description provided for @reactionWaitGreen.
  ///
  /// In en, this message translates to:
  /// **'Wait for green… ({round}/5)'**
  String reactionWaitGreen(Object round);

  /// No description provided for @reactionSnackDone.
  ///
  /// In en, this message translates to:
  /// **'Avg {avgMs} ms · saved · {score} pts'**
  String reactionSnackDone(Object avgMs, Object score);

  /// No description provided for @cardMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Card match'**
  String get cardMatchTitle;

  /// No description provided for @insightSumEmotionalHeavy.
  ///
  /// In en, this message translates to:
  /// **'Mood, tension or anxiety feels heavy today. Prefer short breaks and light movement before hard tasks. (Self-check only.)'**
  String get insightSumEmotionalHeavy;

  /// No description provided for @insightSumDementiaGood.
  ///
  /// In en, this message translates to:
  /// **'Memory and reaction training are going well — from a “cognitive stimulation” habit angle, today looks solid for long-term brain care. (App scores are not a diagnosis.)'**
  String get insightSumDementiaGood;

  /// No description provided for @insightSumLearningGood.
  ///
  /// In en, this message translates to:
  /// **'Focus and memory look strong — a good day for study or deep work.'**
  String get insightSumLearningGood;

  /// No description provided for @insightSumStressFocus.
  ///
  /// In en, this message translates to:
  /// **'Stress may be shaking your focus today.'**
  String get insightSumStressFocus;

  /// No description provided for @insightSumMoodMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory feels stable and organized today.'**
  String get insightSumMoodMemory;

  /// No description provided for @insightSumMotivationLow.
  ///
  /// In en, this message translates to:
  /// **'Motivation is low — short tasks fit better than long ones.'**
  String get insightSumMotivationLow;

  /// No description provided for @insightSumSleep.
  ///
  /// In en, this message translates to:
  /// **'Short sleep may slow reaction time and focus.'**
  String get insightSumSleep;

  /// No description provided for @insightSumDefault.
  ///
  /// In en, this message translates to:
  /// **'Overall steady. Keep the rhythm — small daily habits for sleep, movement, social time, and memory games can support brain health over time. (Reference only.)'**
  String get insightSumDefault;

  /// No description provided for @insightSumDementiaEncourage.
  ///
  /// In en, this message translates to:
  /// **'Today’s pattern looks a bit light on memory, focus, and reaction working together. Dementia isn’t judged from one score, but adding gentle cognitive stimulation over time can support brain health. (Not medical advice.)'**
  String get insightSumDementiaEncourage;

  /// No description provided for @insightRecEmotionalCare.
  ///
  /// In en, this message translates to:
  /// **'Care for mood and sleep first. Walk, talk, breathe — then add short memory games when you feel better. (Seek help if low mood persists.)'**
  String get insightRecEmotionalCare;

  /// No description provided for @insightRecStressNoBreath.
  ///
  /// In en, this message translates to:
  /// **'Stress feels high. Try 1 min breathing, then Stroop or selective attention to settle focus.'**
  String get insightRecStressNoBreath;

  /// No description provided for @insightRecStress.
  ///
  /// In en, this message translates to:
  /// **'Start with 1 min breathing, then a short focus task.'**
  String get insightRecStress;

  /// No description provided for @insightRecMotivation.
  ///
  /// In en, this message translates to:
  /// **'Begin with easy games to build small wins.'**
  String get insightRecMotivation;

  /// No description provided for @insightRecDementiaLow.
  ///
  /// In en, this message translates to:
  /// **'For brain-health habits, try alternating card match, word memory, and visual pattern. (This app isn’t a clinical test — seek care if you’re worried.)'**
  String get insightRecDementiaLow;

  /// No description provided for @insightRecLearningLow.
  ///
  /// In en, this message translates to:
  /// **'Add focus drills: Stroop, N-back, or CPT in short bursts.'**
  String get insightRecLearningLow;

  /// No description provided for @insightRecMemory.
  ///
  /// In en, this message translates to:
  /// **'Try card match or sequence memory today — repeating memory tasks can also help build habits often linked with long-term cognitive care.'**
  String get insightRecMemory;

  /// No description provided for @insightRecFocus.
  ///
  /// In en, this message translates to:
  /// **'Try Stroop or selective attention first.'**
  String get insightRecFocus;

  /// No description provided for @insightRecReaction.
  ///
  /// In en, this message translates to:
  /// **'A short reaction-time drill can wake your senses.'**
  String get insightRecReaction;

  /// No description provided for @insightRecCoordinationLow.
  ///
  /// In en, this message translates to:
  /// **'Hand–eye coordination looks a bit uneven. Short daily left–right drills can build habits that also support everyday movement. (Reference only.)'**
  String get insightRecCoordinationLow;

  /// No description provided for @insightRecNumeracyLow.
  ///
  /// In en, this message translates to:
  /// **'Today’s numeracy score looks low. Try alternating short numeracy and sequence-memory tasks. (Scores are informational only.)'**
  String get insightRecNumeracyLow;

  /// No description provided for @insightRecReasoningLow.
  ///
  /// In en, this message translates to:
  /// **'Shadow matching looks low today. Repeat short visual comparison rounds once a day. (Scores are informational only.)'**
  String get insightRecReasoningLow;

  /// No description provided for @insightRecSpatialLow.
  ///
  /// In en, this message translates to:
  /// **'Maze score looks low today. Try planning the path ahead or short spatial tasks regularly. (Scores are informational only.)'**
  String get insightRecSpatialLow;

  /// No description provided for @insightRecDefault.
  ///
  /// In en, this message translates to:
  /// **'Keep a light 3-minute routine — regular cognitive play fits well alongside other brain-health habits.'**
  String get insightRecDefault;

  /// No description provided for @insightForEmotionalCalm.
  ///
  /// In en, this message translates to:
  /// **'Mood has some room — a good day to add memory and focus work.'**
  String get insightForEmotionalCalm;

  /// No description provided for @insightForMoodMotivationMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory and engagement line up well today.'**
  String get insightForMoodMotivationMemory;

  /// No description provided for @insightForStress.
  ///
  /// In en, this message translates to:
  /// **'Go slow and double-check — a better flow than rushing.'**
  String get insightForStress;

  /// No description provided for @insightForMotivationLow.
  ///
  /// In en, this message translates to:
  /// **'Finish small easy tasks first — that builds momentum.'**
  String get insightForMotivationLow;

  /// No description provided for @insightForDementiaHigh.
  ///
  /// In en, this message translates to:
  /// **'Steady cognitive stimulation — easy to keep a rhythm that supports long-term brain care. (Scores are reference only.)'**
  String get insightForDementiaHigh;

  /// No description provided for @insightForLearningHigh.
  ///
  /// In en, this message translates to:
  /// **'Focus and memory support study or work immersion.'**
  String get insightForLearningHigh;

  /// No description provided for @insightForFocusHigh.
  ///
  /// In en, this message translates to:
  /// **'Focus is strong — tackle important work early.'**
  String get insightForFocusHigh;

  /// No description provided for @insightForCoordinationHigh.
  ///
  /// In en, this message translates to:
  /// **'Left–right taps look fairly crisp today — easy to keep a steady motor rhythm. (Reference only.)'**
  String get insightForCoordinationHigh;

  /// No description provided for @insightForDefault.
  ///
  /// In en, this message translates to:
  /// **'Keep a steady pace without overdoing it — brain-health habits are built in small steps over time.'**
  String get insightForDefault;

  /// No description provided for @trendNoRecords.
  ///
  /// In en, this message translates to:
  /// **'No saved records yet. Add tests, training, or a mood log.'**
  String get trendNoRecords;

  /// No description provided for @trendAccumulated.
  ///
  /// In en, this message translates to:
  /// **'{count} tests & training · active days {days}'**
  String trendAccumulated(Object count, Object days);

  /// No description provided for @trendMindDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days of mood logs'**
  String trendMindDays(Object days);

  /// No description provided for @trendNeedMoreDays.
  ///
  /// In en, this message translates to:
  /// **'As you add more days, we can compare your earliest and latest scores.'**
  String get trendNeedMoreDays;

  /// No description provided for @trendMoodFirstLast.
  ///
  /// In en, this message translates to:
  /// **'Mood log: first {a} → latest {b}'**
  String trendMoodFirstLast(Object a, Object b);

  /// No description provided for @trendCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare: {from} → {to}'**
  String trendCompare(Object from, Object to);

  /// No description provided for @trendPillarLine.
  ///
  /// In en, this message translates to:
  /// **'{name} {from} → {to} {delta}'**
  String trendPillarLine(Object name, Object from, Object to, Object delta);

  /// No description provided for @trendMoodRecord.
  ///
  /// In en, this message translates to:
  /// **'Mood (log) {a} → {b}'**
  String trendMoodRecord(Object a, Object b);

  /// No description provided for @trendNameMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get trendNameMemory;

  /// No description provided for @trendNameFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get trendNameFocus;

  /// No description provided for @trendNameReaction.
  ///
  /// In en, this message translates to:
  /// **'Reaction'**
  String get trendNameReaction;

  /// No description provided for @trendNameCoordination.
  ///
  /// In en, this message translates to:
  /// **'Coordination'**
  String get trendNameCoordination;

  /// No description provided for @trendNameNumeracy.
  ///
  /// In en, this message translates to:
  /// **'Numeracy'**
  String get trendNameNumeracy;

  /// No description provided for @trendNameReasoning.
  ///
  /// In en, this message translates to:
  /// **'Reasoning (shadow)'**
  String get trendNameReasoning;

  /// No description provided for @trendNameSpatial.
  ///
  /// In en, this message translates to:
  /// **'Spatial (maze)'**
  String get trendNameSpatial;

  /// No description provided for @trendNameDementia.
  ///
  /// In en, this message translates to:
  /// **'Brain health ref.'**
  String get trendNameDementia;

  /// No description provided for @trendNameLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning ref.'**
  String get trendNameLearning;

  /// No description provided for @trendNameEmotional.
  ///
  /// In en, this message translates to:
  /// **'Mood & sleep ref.'**
  String get trendNameEmotional;

  /// No description provided for @trendDeltaFlat.
  ///
  /// In en, this message translates to:
  /// **'flat'**
  String get trendDeltaFlat;

  /// No description provided for @trendDeltaUp.
  ///
  /// In en, this message translates to:
  /// **'up'**
  String get trendDeltaUp;

  /// No description provided for @trendDeltaDown.
  ///
  /// In en, this message translates to:
  /// **'down'**
  String get trendDeltaDown;

  /// No description provided for @testTypeMemory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get testTypeMemory;

  /// No description provided for @testTypeFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get testTypeFocus;

  /// No description provided for @testTypeBreathing.
  ///
  /// In en, this message translates to:
  /// **'Breathing'**
  String get testTypeBreathing;

  /// No description provided for @testTypeStroop.
  ///
  /// In en, this message translates to:
  /// **'Stroop'**
  String get testTypeStroop;

  /// No description provided for @testTypeCpt.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get testTypeCpt;

  /// No description provided for @testTypeReaction.
  ///
  /// In en, this message translates to:
  /// **'Reaction'**
  String get testTypeReaction;

  /// No description provided for @testTypeCoordination.
  ///
  /// In en, this message translates to:
  /// **'Coordination'**
  String get testTypeCoordination;

  /// No description provided for @testTypeNumeracy.
  ///
  /// In en, this message translates to:
  /// **'Quick math'**
  String get testTypeNumeracy;

  /// No description provided for @testTypeShadow.
  ///
  /// In en, this message translates to:
  /// **'Shadow match'**
  String get testTypeShadow;

  /// No description provided for @testTypeMaze.
  ///
  /// In en, this message translates to:
  /// **'Maze'**
  String get testTypeMaze;

  /// No description provided for @reportLineTimeScore.
  ///
  /// In en, this message translates to:
  /// **'{time} · score {score}'**
  String reportLineTimeScore(Object time, Object score);

  /// No description provided for @reportBreathingDetail.
  ///
  /// In en, this message translates to:
  /// **'Breathing {n}/4 · {mode}'**
  String reportBreathingDetail(Object n, Object mode);

  /// No description provided for @breathModeMic.
  ///
  /// In en, this message translates to:
  /// **'Mic'**
  String get breathModeMic;

  /// No description provided for @breathModeManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get breathModeManual;

  /// No description provided for @localAiTitle.
  ///
  /// In en, this message translates to:
  /// **'Local AI (Ollama)'**
  String get localAiTitle;

  /// No description provided for @localAiMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Local AI chat'**
  String get localAiMenuTitle;

  /// No description provided for @localAiMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ollama on your PC only · no cloud'**
  String get localAiMenuSubtitle;

  /// No description provided for @localAiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Messages go only to Ollama running on your network or device. Nothing is sent to the public internet. Not medical advice.'**
  String get localAiDisclaimer;

  /// No description provided for @localAiOllamaSetupHint.
  ///
  /// In en, this message translates to:
  /// **'If connection fails: install Ollama on your PC from the download page (pick Windows or macOS for your computer — not Linux for the emulator). Keep it running (Windows: tray icon, or ollama serve). Pull a model, e.g. ollama pull llama3.2. On Android emulator the app defaults to http://10.0.2.2:11434 in Settings; on a physical phone use your PC\'s LAN IP. Desktop app uses http://127.0.0.1:11434.'**
  String get localAiOllamaSetupHint;

  /// No description provided for @localAiErrConnectionRefused.
  ///
  /// In en, this message translates to:
  /// **'Nothing is listening on port 11434 — Ollama is probably not running. Start Ollama, then tap Test connection again.'**
  String get localAiErrConnectionRefused;

  /// No description provided for @localAiErrTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Try again, or wait if the model is large.'**
  String get localAiErrTimeout;

  /// No description provided for @localAiErrDnsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not resolve the server address. Check the URL in Settings (e.g. http://127.0.0.1:11434).'**
  String get localAiErrDnsFailed;

  /// No description provided for @localAiErrEmptyBase.
  ///
  /// In en, this message translates to:
  /// **'Server URL is empty. Open Settings and enter the Ollama address.'**
  String get localAiErrEmptyBase;

  /// No description provided for @localAiErrUnexpectedResponse.
  ///
  /// In en, this message translates to:
  /// **'Could not parse the server response. Check that the model name in Settings matches an installed model.'**
  String get localAiErrUnexpectedResponse;

  /// No description provided for @localAiSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ollama connection'**
  String get localAiSettingsTitle;

  /// No description provided for @localAiBaseUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get localAiBaseUrlLabel;

  /// No description provided for @localAiModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model name'**
  String get localAiModelLabel;

  /// No description provided for @localAiSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get localAiSave;

  /// No description provided for @localAiHintEmulator.
  ///
  /// In en, this message translates to:
  /// **'Android emulator: http://10.0.2.2:11434 · Physical device: your PC LAN IP (e.g. http://192.168.0.10:11434)'**
  String get localAiHintEmulator;

  /// No description provided for @localAiMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get localAiMessageHint;

  /// No description provided for @localAiThinking.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get localAiThinking;

  /// No description provided for @localAiTestConnection.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get localAiTestConnection;

  /// No description provided for @localAiTesting.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get localAiTesting;

  /// No description provided for @localAiPingOk.
  ///
  /// In en, this message translates to:
  /// **'Connected to Ollama.'**
  String get localAiPingOk;

  /// No description provided for @localAiPingFail.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {msg}'**
  String localAiPingFail(Object msg);

  /// No description provided for @localAiErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Could not get a reply.\n{detail}'**
  String localAiErrorGeneric(Object detail);

  /// No description provided for @localAiSpeechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device. Type your message instead.'**
  String get localAiSpeechUnavailable;

  /// No description provided for @localAiMicListen.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get localAiMicListen;

  /// No description provided for @localAiMicStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get localAiMicStop;

  /// No description provided for @localAiSpeakReply.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get localAiSpeakReply;

  /// No description provided for @localAiListening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get localAiListening;

  /// No description provided for @localAiOpenOllamaDownload.
  ///
  /// In en, this message translates to:
  /// **'Open Ollama download page'**
  String get localAiOpenOllamaDownload;

  /// No description provided for @localAiCouldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open the link.'**
  String get localAiCouldNotOpenLink;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
