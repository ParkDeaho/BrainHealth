// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Brain Health';

  @override
  String get tabHome => 'Home';

  @override
  String get tabTests => 'Tests';

  @override
  String get tabTraining => 'Training';

  @override
  String get tabReport => 'Report';

  @override
  String get tabMy => 'Profile';

  @override
  String get languageSetting => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageKorean => 'Korean';

  @override
  String get languageEnglish => 'English';

  @override
  String get mindRecordTitle => 'Today\'s mood log';

  @override
  String get mindRecordSubtitle =>
      'Log once a day — it feeds into your analysis.';

  @override
  String get reactionShortcutTitle => 'Reaction speed test';

  @override
  String get reactionShortcutSubtitle =>
      'Start now · tap when the screen turns green (5 rounds)';

  @override
  String get homeQuickMeasureTitle => 'Quick cognitive checks';

  @override
  String get homeQuickMeasureNumeracySubtitle =>
      'Numeracy reaction — same task as on the Measure tab';

  @override
  String get homeQuickMeasureShadowSubtitle =>
      'Visual reasoning — same task as on the Measure tab';

  @override
  String get homeQuickMeasureMazeSubtitle =>
      'Path planning — same task as on the Measure tab';

  @override
  String get wellnessSectionTitle => 'Focus areas (reference)';

  @override
  String get summaryCardTitle => 'Today\'s takeaway';

  @override
  String get recommendationCardTitle => 'Suggestion';

  @override
  String get reportSectionFlow => 'Today\'s flow';

  @override
  String get reportDementiaSectionTitle => 'Dementia prevention (reference)';

  @override
  String get reportDementiaSectionBody =>
      'Dementia cannot be diagnosed from a single score, and this app does not predict or diagnose disease. Research and lifestyle guidance often mention sleep, light exercise, social connection, and mentally stimulating activities as helpful for long-term brain health. If you notice memory or thinking changes that worry you, see a clinician.';

  @override
  String get flowCardTitlePrefix => 'Today\'s flow: ';

  @override
  String get reportNoData =>
      'No analysis data yet. Log your mood or add a test.';

  @override
  String get reportPillarsTitle => 'Four pillars (today\'s tests & training)';

  @override
  String get reportDetailPillarsTitle =>
      'Detailed cognition (training · numeracy · reasoning · spatial)';

  @override
  String get reportWellnessTitle => 'Focus areas (tests, training & mood)';

  @override
  String get reportDisclaimer =>
      'These numbers are for self-care reference only. They are not medical advice.';

  @override
  String get reportActivityTitle => 'Today\'s tests & training';

  @override
  String get reportActivityEmpty =>
      'No tests or training saved for today. Complete one from Home to see it here.';

  @override
  String get pillMemory => 'Memory';

  @override
  String get pillFocus => 'Focus';

  @override
  String get pillReaction => 'Reaction';

  @override
  String get pillCoordination => 'Coordination';

  @override
  String get pillNumeracy => 'Numeracy';

  @override
  String get pillReasoning => 'Reasoning';

  @override
  String get pillSpatial => 'Spatial';

  @override
  String get pillDementia => 'Brain health';

  @override
  String get pillLearning => 'Learning';

  @override
  String get pillEmotional => 'Mood & sleep';

  @override
  String pillNoTestToday(Object label) {
    return '$label (no test today)';
  }

  @override
  String get myPageTitle => 'Profile';

  @override
  String get selectedMode => 'Selected mode';

  @override
  String get modeSenior => 'Memory / prevention';

  @override
  String get modeStudent => 'Focus / study';

  @override
  String get modeGeneral => 'General';

  @override
  String get trendsSectionTitle => 'Progress (first → latest)';

  @override
  String get appInfoTitle => 'About';

  @override
  String get appInfoSubtitle => 'Brain health · stored on device';

  @override
  String get onboardingReplayTitle => 'Show onboarding again';

  @override
  String get onboardingReplayBody =>
      'Return to the first-time setup. Continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'OK';

  @override
  String get onboardingTitle => 'Brain Health';

  @override
  String get onboardingSubtitle =>
      'Healthy habits start with small daily steps.';

  @override
  String get onboardingSeniorTitle => 'Memory / prevention';

  @override
  String get onboardingSeniorSubtitle =>
      'Adults · memory care · cognitive habits';

  @override
  String get onboardingStudentTitle => 'Focus / study';

  @override
  String get onboardingStudentSubtitle => 'Students · focus · study routine';

  @override
  String get onboardingGeneralTitle => 'General';

  @override
  String get onboardingGeneralSubtitle => 'Overall brain wellness';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get testsHubTitle => 'Cognitive tests';

  @override
  String get trainingHubTitle => 'Brain training';

  @override
  String get testWordMemoryTitle => 'Word memory';

  @override
  String get testWordMemoryDesc => 'Memorize and recall 5 words';

  @override
  String get testDigitSpanTitle => 'Digit span';

  @override
  String get testDigitSpanDesc => 'Remember digits in reverse order';

  @override
  String get testVisualPatternTitle => 'Visual pattern';

  @override
  String get testVisualPatternDesc => 'Recall lit cells on the grid';

  @override
  String get testStroopTitle => 'Stroop';

  @override
  String get testStroopDesc => 'Pick the ink color quickly';

  @override
  String get testReactionTitle => 'Reaction time';

  @override
  String get testReactionDesc => 'Tap as soon as the screen changes';

  @override
  String get testCptTitle => 'Sustained attention (CPT)';

  @override
  String get testCptDesc => 'Tap when you see X';

  @override
  String get testMeasureNumeracyDesc =>
      'Short numeracy reaction test with addition and subtraction (10 items). Same task as Quick math on the Train tab.';

  @override
  String get testMeasureShadowDesc =>
      'Visual reasoning: pick the matching silhouette (8 rounds). Same task as Find the shadow on the Train tab.';

  @override
  String get testMeasureMazeDesc =>
      'Path planning to the exit by tapping adjacent cells. Same task as Maze on the Train tab.';

  @override
  String get testCoordinationTitle => 'Left–right coordination';

  @override
  String get testCoordinationDesc =>
      'Tap the highlighted side quickly (12 rounds)';

  @override
  String get trainCoordinationTitle => 'Coordination practice';

  @override
  String get trainCoordinationDesc =>
      'Hand–eye coordination · short rounds (8)';

  @override
  String get trainNumeracyTitle => 'Quick math';

  @override
  String get trainNumeracyDesc => 'Add & subtract to train numeracy (10 items)';

  @override
  String get trainShadowTitle => 'Find the shadow';

  @override
  String get trainShadowDesc =>
      'Pick the matching silhouette · problem solving (8 rounds)';

  @override
  String get trainMazeTitle => 'Maze';

  @override
  String get trainMazeDesc =>
      'Tap adjacent path cells to the flag · spatial route (presets)';

  @override
  String get tagCoordination => 'Coordination';

  @override
  String get tagNumeracy => 'Numeracy';

  @override
  String get tagReasoning => 'Reasoning';

  @override
  String get tagSpatial => 'Spatial';

  @override
  String get coordinationAppBar => 'Left–right coordination';

  @override
  String get coordinationInstructions =>
      'When the cue appears, tap the highlighted side (left or right). Wrong side or too slow counts as a miss.';

  @override
  String get coordinationPrepare => 'Get ready…';

  @override
  String get coordinationCueLeft => 'Left';

  @override
  String get coordinationCueRight => 'Right';

  @override
  String coordinationRoundProgress(Object n, Object total) {
    return 'Round $n / $total';
  }

  @override
  String coordinationSnackDone(Object avgMs, Object accPct, Object score) {
    return 'Avg $avgMs ms · accuracy $accPct% · $score pts';
  }

  @override
  String get numeracyAppBar => 'Quick math';

  @override
  String get numeracyInstructions =>
      'Pick the correct answer. Accuracy and response time affect your score.';

  @override
  String numeracyProgress(Object n, Object total) {
    return 'Item $n / $total';
  }

  @override
  String numeracySnackDone(Object correct, Object total, Object score) {
    return 'Correct $correct / $total · $score pts';
  }

  @override
  String get shadowAppBar => 'Find the shadow';

  @override
  String get shadowInstructions =>
      'Choose the filled silhouette that matches the outline above.';

  @override
  String shadowProgress(Object n, Object total) {
    return 'Round $n / $total';
  }

  @override
  String get shadowTargetLabel => 'Which shadow matches?';

  @override
  String get shadowPickLabel => 'Choices';

  @override
  String shadowSnackDone(Object correct, Object total, Object score) {
    return 'Correct $correct / $total · $score pts';
  }

  @override
  String get mazeAppBar => 'Maze';

  @override
  String get mazeInstructions =>
      'Tap adjacent open cells to reach the flag. Walls (#) block you.';

  @override
  String mazeMoves(Object n) {
    return 'Moves: $n';
  }

  @override
  String mazeSnackDone(Object moves, Object shortest, Object score) {
    return '$moves moves (shortest $shortest) · $score pts';
  }

  @override
  String get tagDementia => 'Brain health';

  @override
  String get tagLearning => 'Learning';

  @override
  String get tagFocus => 'Focus';

  @override
  String get trainCardMatchTitle => 'Card match';

  @override
  String get trainCardMatchDesc => 'Find matching pairs';

  @override
  String get trainNbackTitle => 'N-back';

  @override
  String get trainNbackDesc => 'Decide if it matches N steps back';

  @override
  String get trainSequenceTitle => 'Sequence memory';

  @override
  String get trainSequenceDesc => 'Remember and replay the light order';

  @override
  String get trainSelectiveTitle => 'Selective attention';

  @override
  String get trainSelectiveDesc => 'Tap only the target shape';

  @override
  String get trainBreathingTitle => 'Breathing · focus reset';

  @override
  String get trainBreathingDesc => '1 min breathing · mic or manual';

  @override
  String get tagEmotionalSleep => 'Mood & sleep';

  @override
  String get tagStressMood => 'Stress & low mood self-care';

  @override
  String get mindMoodTitle => 'How is your mood today?';

  @override
  String get mindStressTitle => 'Stress level today?';

  @override
  String get mindAnxietyTitle => 'How anxious do you feel?';

  @override
  String get mindMotivationTitle => 'How motivated do you feel?';

  @override
  String get mindSleepTitle => 'Sleep last night';

  @override
  String get mindNoteTitle => 'Short note';

  @override
  String get mindNoteHint => 'e.g. Busy day, felt scattered';

  @override
  String get mindSave => 'Save';

  @override
  String get mindSavedHint => 'Today\'s log is saved and used in analysis.';

  @override
  String get mindSaveDone => 'Saved.';

  @override
  String mindScoreCurrent(Object n) {
    return 'Current score: $n';
  }

  @override
  String sleepHoursItem(Object h) {
    return '$h h';
  }

  @override
  String get moodVeryBad => 'Very bad';

  @override
  String get moodBad => 'Bad';

  @override
  String get moodNeutral => 'OK';

  @override
  String get moodGood => 'Good';

  @override
  String get moodVeryGood => 'Very good';

  @override
  String get sleepHoursHint => 'Choose';

  @override
  String get reactionAppBar => 'Reaction time';

  @override
  String get reactionTapWhenGreen => 'Tap!';

  @override
  String reactionWaitGreen(Object round) {
    return 'Wait for green… ($round/5)';
  }

  @override
  String reactionSnackDone(Object avgMs, Object score) {
    return 'Avg $avgMs ms · saved · $score pts';
  }

  @override
  String get cardMatchTitle => 'Card match';

  @override
  String get insightSumEmotionalHeavy =>
      'Mood, tension or anxiety feels heavy today. Prefer short breaks and light movement before hard tasks. (Self-check only.)';

  @override
  String get insightSumDementiaGood =>
      'Memory and reaction training are going well — from a “cognitive stimulation” habit angle, today looks solid for long-term brain care. (App scores are not a diagnosis.)';

  @override
  String get insightSumLearningGood =>
      'Focus and memory look strong — a good day for study or deep work.';

  @override
  String get insightSumStressFocus => 'Stress may be shaking your focus today.';

  @override
  String get insightSumMoodMemory => 'Memory feels stable and organized today.';

  @override
  String get insightSumMotivationLow =>
      'Motivation is low — short tasks fit better than long ones.';

  @override
  String get insightSumSleep => 'Short sleep may slow reaction time and focus.';

  @override
  String get insightSumDefault =>
      'Overall steady. Keep the rhythm — small daily habits for sleep, movement, social time, and memory games can support brain health over time. (Reference only.)';

  @override
  String get insightSumDementiaEncourage =>
      'Today’s pattern looks a bit light on memory, focus, and reaction working together. Dementia isn’t judged from one score, but adding gentle cognitive stimulation over time can support brain health. (Not medical advice.)';

  @override
  String get insightRecEmotionalCare =>
      'Care for mood and sleep first. Walk, talk, breathe — then add short memory games when you feel better. (Seek help if low mood persists.)';

  @override
  String get insightRecStressNoBreath =>
      'Stress feels high. Try 1 min breathing, then Stroop or selective attention to settle focus.';

  @override
  String get insightRecStress =>
      'Start with 1 min breathing, then a short focus task.';

  @override
  String get insightRecMotivation =>
      'Begin with easy games to build small wins.';

  @override
  String get insightRecDementiaLow =>
      'For brain-health habits, try alternating card match, word memory, and visual pattern. (This app isn’t a clinical test — seek care if you’re worried.)';

  @override
  String get insightRecLearningLow =>
      'Add focus drills: Stroop, N-back, or CPT in short bursts.';

  @override
  String get insightRecMemory =>
      'Try card match or sequence memory today — repeating memory tasks can also help build habits often linked with long-term cognitive care.';

  @override
  String get insightRecFocus => 'Try Stroop or selective attention first.';

  @override
  String get insightRecReaction =>
      'A short reaction-time drill can wake your senses.';

  @override
  String get insightRecCoordinationLow =>
      'Hand–eye coordination looks a bit uneven. Short daily left–right drills can build habits that also support everyday movement. (Reference only.)';

  @override
  String get insightRecNumeracyLow =>
      'Today’s numeracy score looks low. Try alternating short numeracy and sequence-memory tasks. (Scores are informational only.)';

  @override
  String get insightRecReasoningLow =>
      'Shadow matching looks low today. Repeat short visual comparison rounds once a day. (Scores are informational only.)';

  @override
  String get insightRecSpatialLow =>
      'Maze score looks low today. Try planning the path ahead or short spatial tasks regularly. (Scores are informational only.)';

  @override
  String get insightRecDefault =>
      'Keep a light 3-minute routine — regular cognitive play fits well alongside other brain-health habits.';

  @override
  String get insightForEmotionalCalm =>
      'Mood has some room — a good day to add memory and focus work.';

  @override
  String get insightForMoodMotivationMemory =>
      'Memory and engagement line up well today.';

  @override
  String get insightForStress =>
      'Go slow and double-check — a better flow than rushing.';

  @override
  String get insightForMotivationLow =>
      'Finish small easy tasks first — that builds momentum.';

  @override
  String get insightForDementiaHigh =>
      'Steady cognitive stimulation — easy to keep a rhythm that supports long-term brain care. (Scores are reference only.)';

  @override
  String get insightForLearningHigh =>
      'Focus and memory support study or work immersion.';

  @override
  String get insightForFocusHigh =>
      'Focus is strong — tackle important work early.';

  @override
  String get insightForCoordinationHigh =>
      'Left–right taps look fairly crisp today — easy to keep a steady motor rhythm. (Reference only.)';

  @override
  String get insightForDefault =>
      'Keep a steady pace without overdoing it — brain-health habits are built in small steps over time.';

  @override
  String get trendNoRecords =>
      'No saved records yet. Add tests, training, or a mood log.';

  @override
  String trendAccumulated(Object count, Object days) {
    return '$count tests & training · active days $days';
  }

  @override
  String trendMindDays(Object days) {
    return '$days days of mood logs';
  }

  @override
  String get trendNeedMoreDays =>
      'As you add more days, we can compare your earliest and latest scores.';

  @override
  String trendMoodFirstLast(Object a, Object b) {
    return 'Mood log: first $a → latest $b';
  }

  @override
  String trendCompare(Object from, Object to) {
    return 'Compare: $from → $to';
  }

  @override
  String trendPillarLine(Object name, Object from, Object to, Object delta) {
    return '$name $from → $to $delta';
  }

  @override
  String trendMoodRecord(Object a, Object b) {
    return 'Mood (log) $a → $b';
  }

  @override
  String get trendNameMemory => 'Memory';

  @override
  String get trendNameFocus => 'Focus';

  @override
  String get trendNameReaction => 'Reaction';

  @override
  String get trendNameCoordination => 'Coordination';

  @override
  String get trendNameNumeracy => 'Numeracy';

  @override
  String get trendNameReasoning => 'Reasoning (shadow)';

  @override
  String get trendNameSpatial => 'Spatial (maze)';

  @override
  String get trendNameDementia => 'Brain health ref.';

  @override
  String get trendNameLearning => 'Learning ref.';

  @override
  String get trendNameEmotional => 'Mood & sleep ref.';

  @override
  String get trendDeltaFlat => 'flat';

  @override
  String get trendDeltaUp => 'up';

  @override
  String get trendDeltaDown => 'down';

  @override
  String get testTypeMemory => 'Memory';

  @override
  String get testTypeFocus => 'Focus';

  @override
  String get testTypeBreathing => 'Breathing';

  @override
  String get testTypeStroop => 'Stroop';

  @override
  String get testTypeCpt => 'Attention';

  @override
  String get testTypeReaction => 'Reaction';

  @override
  String get testTypeCoordination => 'Coordination';

  @override
  String get testTypeNumeracy => 'Quick math';

  @override
  String get testTypeShadow => 'Shadow match';

  @override
  String get testTypeMaze => 'Maze';

  @override
  String reportLineTimeScore(Object time, Object score) {
    return '$time · score $score';
  }

  @override
  String reportBreathingDetail(Object n, Object mode) {
    return 'Breathing $n/4 · $mode';
  }

  @override
  String get breathModeMic => 'Mic';

  @override
  String get breathModeManual => 'Manual';

  @override
  String get localAiTitle => 'Local AI (Ollama)';

  @override
  String get localAiMenuTitle => 'Local AI chat';

  @override
  String get localAiMenuSubtitle => 'Ollama on your PC only · no cloud';

  @override
  String get localAiDisclaimer =>
      'Messages go only to Ollama running on your network or device. Nothing is sent to the public internet. Not medical advice.';

  @override
  String get localAiOllamaSetupHint =>
      'If connection fails: install Ollama and keep it running (Windows: tray icon, or run ollama serve in a terminal). Pull a model with e.g. ollama pull llama3.2. Check Settings that the URL is http://127.0.0.1:11434 (default).';

  @override
  String get localAiErrConnectionRefused =>
      'Nothing is listening on port 11434 — Ollama is probably not running. Start Ollama, then tap Test connection again.';

  @override
  String get localAiErrTimeout =>
      'The request timed out. Try again, or wait if the model is large.';

  @override
  String get localAiErrDnsFailed =>
      'Could not resolve the server address. Check the URL in Settings (e.g. http://127.0.0.1:11434).';

  @override
  String get localAiErrEmptyBase =>
      'Server URL is empty. Open Settings and enter the Ollama address.';

  @override
  String get localAiErrUnexpectedResponse =>
      'Could not parse the server response. Check that the model name in Settings matches an installed model.';

  @override
  String get localAiSettingsTitle => 'Ollama connection';

  @override
  String get localAiBaseUrlLabel => 'Server URL';

  @override
  String get localAiModelLabel => 'Model name';

  @override
  String get localAiSave => 'Save';

  @override
  String get localAiHintEmulator =>
      'Android emulator: http://10.0.2.2:11434 · Physical device: your PC LAN IP (e.g. http://192.168.0.10:11434)';

  @override
  String get localAiMessageHint => 'Type a message';

  @override
  String get localAiThinking => 'Generating…';

  @override
  String get localAiTestConnection => 'Test connection';

  @override
  String get localAiTesting => 'Checking…';

  @override
  String get localAiPingOk => 'Connected to Ollama.';

  @override
  String localAiPingFail(Object msg) {
    return 'Connection failed: $msg';
  }

  @override
  String localAiErrorGeneric(Object detail) {
    return 'Could not get a reply.\n$detail';
  }

  @override
  String get localAiSpeechUnavailable =>
      'Speech recognition is not available on this device. Type your message instead.';

  @override
  String get localAiMicListen => 'Speak';

  @override
  String get localAiMicStop => 'Stop';

  @override
  String get localAiSpeakReply => 'Read aloud';

  @override
  String get localAiListening => 'Listening…';

  @override
  String get localAiOpenOllamaDownload => 'Open Ollama download page';

  @override
  String get localAiCouldNotOpenLink => 'Could not open the link.';
}
