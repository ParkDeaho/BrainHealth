// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '나의 뇌 건강';

  @override
  String get tabHome => '홈';

  @override
  String get tabTests => '측정';

  @override
  String get tabTraining => '훈련';

  @override
  String get tabReport => '리포트';

  @override
  String get tabMy => '마이';

  @override
  String get languageSetting => '언어';

  @override
  String get languageSystem => '시스템 따라가기';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageEnglish => 'English';

  @override
  String get mindRecordTitle => '오늘의 마음 상태 기록';

  @override
  String get mindRecordSubtitle => '하루 한 번, 짧게 기록하면 분석에 반영됩니다.';

  @override
  String get reactionShortcutTitle => '반응 속도 측정';

  @override
  String get reactionShortcutSubtitle => '바로 시작 · 초록이 되면 탭 (5회)';

  @override
  String get homeQuickMeasureTitle => '빠른 인지 측정';

  @override
  String get homeQuickMeasureNumeracySubtitle => '수리 반응 · 측정 탭과 동일 과제';

  @override
  String get homeQuickMeasureShadowSubtitle => '시각 추론 · 측정 탭과 동일 과제';

  @override
  String get homeQuickMeasureMazeSubtitle => '경로 계획 · 측정 탭과 동일 과제';

  @override
  String get wellnessSectionTitle => '관심 영역 참고';

  @override
  String get summaryCardTitle => '오늘의 한마디';

  @override
  String get recommendationCardTitle => '추천';

  @override
  String get reportSectionFlow => '오늘의 흐름';

  @override
  String get reportDementiaSectionTitle => '치매 예방 참고';

  @override
  String get reportDementiaSectionBody =>
      '치매는 한 번의 검사로 판별되지 않으며, 이 앱의 점수는 의학적 진단·예측이 아닙니다. 연구와 생활습관 관점에서는 충분한 수면, 가벼운 유산소 운동, 사회적 교류, 읽기·퍼즐·기억 훈련처럼 뇌를 자극하는 활동이 장기적인 뇌 건강에 도움이 될 수 있다고 알려져 있어요. 기억력·일상 수행에 걱정이 생기면 반드시 전문의 진료를 받으세요.';

  @override
  String get flowCardTitlePrefix => '오늘의 흐름: ';

  @override
  String get reportNoData => '오늘 분석 데이터가 아직 없습니다. 마음 기록을 남기거나 측정을 추가해 보세요.';

  @override
  String get reportPillarsTitle => '4대 지표 (오늘 측정·훈련 반영)';

  @override
  String get reportDetailPillarsTitle => '세부 인지 (훈련 · 수리·추론·공간)';

  @override
  String get reportWellnessTitle => '관심 영역 참고 (측정·훈련·마음 기록)';

  @override
  String get reportDisclaimer =>
      '아래 수치는 생활·자가 기록 기반 참고 지표이며, 의학적 진단이나 치료를 대체하지 않습니다.';

  @override
  String get reportActivityTitle => '오늘의 측정·훈련 기록';

  @override
  String get reportActivityEmpty =>
      '오늘 저장된 측정·훈련이 없습니다. 홈에서 훈련을 완료하면 여기에 표시됩니다.';

  @override
  String get pillMemory => '기억';

  @override
  String get pillFocus => '집중';

  @override
  String get pillReaction => '반응';

  @override
  String get pillCoordination => '협응';

  @override
  String get pillNumeracy => '수리';

  @override
  String get pillReasoning => '추론';

  @override
  String get pillSpatial => '시공간';

  @override
  String get pillDementia => '치매 예방';

  @override
  String get pillLearning => '학습';

  @override
  String get pillEmotional => '정서·수면';

  @override
  String pillNoTestToday(Object label) {
    return '$label (오늘 측정 없음)';
  }

  @override
  String get myPageTitle => '마이페이지';

  @override
  String get selectedMode => '선택한 모드';

  @override
  String get modeSenior => '기억력 / 예방 모드';

  @override
  String get modeStudent => '집중력 / 학습 모드';

  @override
  String get modeGeneral => '통합 모드';

  @override
  String get trendsSectionTitle => '기록 변화 (처음 → 최근)';

  @override
  String get appInfoTitle => '앱 정보';

  @override
  String get appInfoSubtitle => '나의 뇌 건강 · 로컬 저장 기반';

  @override
  String get onboardingReplayTitle => '온보딩 다시 보기';

  @override
  String get onboardingReplayBody => '처음 설정 화면으로 돌아갑니다. 계속할까요?';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get onboardingTitle => '나의 뇌 건강';

  @override
  String get onboardingSubtitle => '뇌 건강은 매일의 습관에서 시작됩니다';

  @override
  String get onboardingSeniorTitle => '기억력 / 예방 모드';

  @override
  String get onboardingSeniorSubtitle => '중장년층 · 기억력 관리 · 인지 예방';

  @override
  String get onboardingStudentTitle => '집중력 / 학습 모드';

  @override
  String get onboardingStudentSubtitle => '학생 · 집중력 강화 · 공부 루틴';

  @override
  String get onboardingGeneralTitle => '통합 모드';

  @override
  String get onboardingGeneralSubtitle => '일반 · 전반적 뇌 컨디션 관리';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get testsHubTitle => '인지 측정';

  @override
  String get trainingHubTitle => '뇌 훈련';

  @override
  String get testWordMemoryTitle => '단어 기억';

  @override
  String get testWordMemoryDesc => '5개 단어를 기억하고 떠올리기';

  @override
  String get testDigitSpanTitle => '숫자 역순';

  @override
  String get testDigitSpanDesc => '숫자를 거꾸로 기억하기';

  @override
  String get testVisualPatternTitle => '시각 패턴';

  @override
  String get testVisualPatternDesc => '격자에서 빛난 위치 기억';

  @override
  String get testStroopTitle => '스트룹';

  @override
  String get testStroopDesc => '글자의 색깔을 빠르게 선택';

  @override
  String get testReactionTitle => '반응 속도';

  @override
  String get testReactionDesc => '화면이 바뀌면 최대한 빠르게';

  @override
  String get testCptTitle => '지속 집중 (CPT)';

  @override
  String get testCptDesc => 'X가 나오면 터치';

  @override
  String get testMeasureNumeracyDesc =>
      '덧셈·뺄셈 반응으로 수리 인지를 짧게 측정합니다. 훈련 탭의 셈하기와 같은 과제입니다.';

  @override
  String get testMeasureShadowDesc =>
      '실루엣이 맞는 그림을 고르는 시각 추론을 측정합니다. 훈련 탭의 그림자 찾기와 같은 과제입니다.';

  @override
  String get testMeasureMazeDesc =>
      '인접 칸을 눌러 출구까지 가는 경로를 측정합니다. 훈련 탭의 미로 찾기와 같은 과제입니다.';

  @override
  String get testCoordinationTitle => '좌우 협응';

  @override
  String get testCoordinationDesc => '신호에 맞춰 왼쪽·오른쪽을 빠르게 탭 (12회)';

  @override
  String get trainCoordinationTitle => '좌우 협응 훈련';

  @override
  String get trainCoordinationDesc => '손–눈 협응 · 짧은 라운드 (8회)';

  @override
  String get trainNumeracyTitle => '셈하기';

  @override
  String get trainNumeracyDesc => '덧셈·뺄셈으로 수리 인지 자극 (10문항)';

  @override
  String get trainShadowTitle => '그림자 찾기';

  @override
  String get trainShadowDesc => '윤곽과 맞는 실루엣 고르기 · 문제 해결 (8회)';

  @override
  String get trainMazeTitle => '미로 찾기';

  @override
  String get trainMazeDesc => '인접 칸을 눌러 출구까지 · 시공간 경로 (프리셋)';

  @override
  String get tagCoordination => '협응';

  @override
  String get tagNumeracy => '수리';

  @override
  String get tagReasoning => '추론';

  @override
  String get tagSpatial => '시공간';

  @override
  String get coordinationAppBar => '좌우 협응';

  @override
  String get coordinationInstructions =>
      '화면에 신호가 뜨면, 밝게 강조된 쪽(왼쪽 또는 오른쪽)을 빠르게 누르세요. 잘못 누르거나 시간이 지나면 해당 라운드는 놓친 것으로 처리됩니다.';

  @override
  String get coordinationPrepare => '준비…';

  @override
  String get coordinationCueLeft => '왼쪽';

  @override
  String get coordinationCueRight => '오른쪽';

  @override
  String coordinationRoundProgress(Object n, Object total) {
    return '$n / $total 라운드';
  }

  @override
  String coordinationSnackDone(Object avgMs, Object accPct, Object score) {
    return '평균 ${avgMs}ms · 정확도 $accPct% · $score점';
  }

  @override
  String get numeracyAppBar => '셈하기';

  @override
  String get numeracyInstructions =>
      '제시된 식에 맞는 답을 고르세요. 정확도와 반응 속도가 점수에 반영됩니다.';

  @override
  String numeracyProgress(Object n, Object total) {
    return '$n / $total 문항';
  }

  @override
  String numeracySnackDone(Object correct, Object total, Object score) {
    return '정답 $correct / $total · $score점';
  }

  @override
  String get shadowAppBar => '그림자 찾기';

  @override
  String get shadowInstructions => '위 모양과 같은 실루엣(검은 그림자)을 아래에서 고르세요.';

  @override
  String shadowProgress(Object n, Object total) {
    return '$n / $total 회';
  }

  @override
  String get shadowTargetLabel => '이 모양과 같은 그림자는?';

  @override
  String get shadowPickLabel => '선택';

  @override
  String shadowSnackDone(Object correct, Object total, Object score) {
    return '정답 $correct / $total · $score점';
  }

  @override
  String get mazeAppBar => '미로 찾기';

  @override
  String get mazeInstructions =>
      '인접한 길 칸을 눌러 깃발(출구)까지 이동하세요. 벽(#)은 지나갈 수 없습니다.';

  @override
  String mazeMoves(Object n) {
    return '이동 $n회';
  }

  @override
  String mazeSnackDone(Object moves, Object shortest, Object score) {
    return '이동 $moves회 (최단 $shortest회) · $score점';
  }

  @override
  String get tagDementia => '치매 예방';

  @override
  String get tagLearning => '학습';

  @override
  String get tagFocus => '집중';

  @override
  String get trainCardMatchTitle => '카드 뒤집기';

  @override
  String get trainCardMatchDesc => '같은 그림의 카드 짝 찾기';

  @override
  String get trainNbackTitle => 'N-back 훈련';

  @override
  String get trainNbackDesc => 'N번 전과 같은 모양 판단';

  @override
  String get trainSequenceTitle => '시퀀스 기억';

  @override
  String get trainSequenceDesc => '빛나는 순서를 기억하고 재현';

  @override
  String get trainSelectiveTitle => '선택 집중';

  @override
  String get trainSelectiveDesc => '목표만 빠르게 선택하기';

  @override
  String get trainBreathingTitle => '호흡 · 집중 회복';

  @override
  String get trainBreathingDesc => '1분 호흡으로 집중 리셋 · 마이크 또는 수동';

  @override
  String get tagEmotionalSleep => '정서·수면';

  @override
  String get tagStressMood => '스트레스·우울 기분 자가 돌봄';

  @override
  String get mindMoodTitle => '오늘 기분은 어떤가요?';

  @override
  String get mindStressTitle => '오늘 스트레스 정도는?';

  @override
  String get mindAnxietyTitle => '오늘 불안감은 어느 정도인가요?';

  @override
  String get mindMotivationTitle => '오늘 의욕은 어떤가요?';

  @override
  String get mindSleepTitle => '어젯밤 수면 시간';

  @override
  String get mindNoteTitle => '한 줄 기록';

  @override
  String get mindNoteHint => '예: 일이 많아서 정신이 없었음';

  @override
  String get mindSave => '저장하기';

  @override
  String get mindSavedHint => '오늘 기록이 저장되어 분석에 반영됩니다.';

  @override
  String get mindSaveDone => '오늘의 마음 상태가 저장되었습니다.';

  @override
  String mindScoreCurrent(Object n) {
    return '현재 점수: $n';
  }

  @override
  String sleepHoursItem(Object h) {
    return '$h시간';
  }

  @override
  String get moodVeryBad => '매우 나쁨';

  @override
  String get moodBad => '나쁨';

  @override
  String get moodNeutral => '보통';

  @override
  String get moodGood => '좋음';

  @override
  String get moodVeryGood => '매우 좋음';

  @override
  String get sleepHoursHint => '선택해주세요';

  @override
  String get reactionAppBar => '반응 속도';

  @override
  String get reactionTapWhenGreen => '탭!';

  @override
  String reactionWaitGreen(Object round) {
    return '초록이 될 때까지… ($round/5)';
  }

  @override
  String reactionSnackDone(Object avgMs, Object score) {
    return '평균 ${avgMs}ms · 기록 저장됨 · $score점';
  }

  @override
  String get cardMatchTitle => '카드 뒤집기';

  @override
  String get insightSumEmotionalHeavy =>
      '기분·긴장·불안 기록이 무겁게 느껴지는 하루입니다. 무리한 과제보다 짧은 휴식과 가벼운 몸 움직임을 먼저 챙기면 좋습니다. (자가 점검일 뿐이에요)';

  @override
  String get insightSumDementiaGood =>
      '기억·반응을 함께 쓰는 활동이 잘 이어지고 있어, 치매 예방을 위한 ‘생활 속 인지 자극’ 습관으로는 무난한 편입니다. (앱 점수는 진단이 아니에요)';

  @override
  String get insightSumLearningGood => '집중·기억이 함께 올라와 학습·과제 몰입에 유리한 흐름으로 보입니다.';

  @override
  String get insightSumStressFocus => '스트레스 영향으로 집중 흐름이 다소 흔들리는 하루입니다.';

  @override
  String get insightSumMoodMemory => '기억 정리가 비교적 잘 되는 안정적인 흐름입니다.';

  @override
  String get insightSumMotivationLow => '의욕이 낮아 긴 과제보다 짧은 활동이 더 잘 맞는 날입니다.';

  @override
  String get insightSumSleep => '수면 부족 영향으로 반응속도와 집중 유지가 다소 떨어질 수 있습니다.';

  @override
  String get insightSumDefault =>
      '전반적으로 무난한 흐름입니다. 치매 예방도 꾸준한 수면·운동·사회활동과 함께, 기억·집중을 쓰는 작은 훈련이 쌓일 때 도움이 될 수 있어요. (참고용)';

  @override
  String get insightSumDementiaEncourage =>
      '오늘 측정 기준으로는 기억·집중·반응이 함께 받쳐주는 흐름이 아직 약해 보여요. 치매는 한 가지 점수로 판단되지 않지만, 생활 속에서 인지 자극을 조금씩 늘리는 것이 장기적으로 뇌 건강에 유리할 수 있습니다. (의학적 진단 아님)';

  @override
  String get insightRecEmotionalCare =>
      '정서·수면 리듬을 먼저 돌보세요. 산책·대화·호흡 등 가벼운 활동 후, 기분이 나을 때 짧은 기억 훈련을 이어가면 좋습니다. (우울 등 증상이 계속되면 전문가 상담을 권해요)';

  @override
  String get insightRecStressNoBreath =>
      '스트레스가 높게 느껴집니다. 먼저 1분 호흡·집중 회복을 하고, 이어서 Stroop·선택 집중으로 마음을 가볍게 묶어보세요.';

  @override
  String get insightRecStress => '먼저 1분 호흡 안정 훈련을 하고 짧은 집중 훈련을 진행해보세요.';

  @override
  String get insightRecMotivation => '난이도가 낮은 게임부터 시작해 작은 성공 경험을 만드는 것이 좋습니다.';

  @override
  String get insightRecDementiaLow =>
      '치매 예방·뇌 건강 관점에서는 기억·반응을 함께 쓰는 훈련이 도움이 될 수 있어요. 카드 뒤집기·단어 기억·시각 패턴을 번갈아 해보세요. (앱은 검사기가 아니며, 증상이 걱정되면 병원 상담을 권해요)';

  @override
  String get insightRecLearningLow =>
      '학습 몰입을 위해 집중 자극이 필요해 보입니다. Stroop·N-back·지속 집중(CPT)을 짧게 나눠 해보세요.';

  @override
  String get insightRecMemory =>
      '오늘은 카드 맞추기나 순서 기억 훈련을 추천합니다. 기억을 반복해서 쓰는 활동은 치매 예방을 위한 생활 습관을 만드는 데에도 도움이 될 수 있어요.';

  @override
  String get insightRecFocus => 'Stroop 또는 선택 집중 훈련을 먼저 진행해보세요.';

  @override
  String get insightRecReaction => '짧은 반응속도 훈련으로 감각을 깨워보는 것이 좋습니다.';

  @override
  String get insightRecCoordinationLow =>
      '손–눈 협응이 아직 들쭉날쭉해 보여요. 좌우 협응 측정·훈련을 하루 한 번 짧게 반복하면 일상 동작·운동 능력과도 연결되는 습관을 만들 수 있어요. (참고용)';

  @override
  String get insightRecNumeracyLow =>
      '오늘 셈하기 점수가 낮게 나왔어요. 작업 기억과 계산을 함께 쓰는 셈하기·순서 기억을 짧게 번갈아 해보면 좋아요. (앱 점수는 참고용)';

  @override
  String get insightRecReasoningLow =>
      '그림자 찾기 점수가 낮게 나왔어요. 시각 비교를 쓰는 과제를 하루 한 번 짧게 반복해 보세요. (앱 점수는 참고용)';

  @override
  String get insightRecSpatialLow =>
      '미로 점수가 낮게 나왔어요. 경로를 미리 그려 보거나 짧은 미로·공간 과제를 규칙적으로 해보면 도움이 될 수 있어요. (앱 점수는 참고용)';

  @override
  String get insightRecDefault =>
      '현재 흐름을 유지하면서 3분 정도 가볍게 훈련해보세요. 규칙적인 인지 활동은 치매 예방을 포함한 뇌 건강 습관과 함께 가져가면 좋아요.';

  @override
  String get insightForEmotionalCalm =>
      '정서 여유가 있어 보이는 날입니다. 기억·집중 훈련을 조금 더 넣기 좋은 흐름이에요.';

  @override
  String get insightForMoodMotivationMemory =>
      '오늘은 기억 정리와 몰입 흐름이 비교적 잘 맞는 날입니다.';

  @override
  String get insightForStress => '오늘은 서두르기보다 천천히 확인하면서 가는 것이 더 좋은 흐름입니다.';

  @override
  String get insightForMotivationLow => '큰 목표보다 짧고 쉬운 과제를 먼저 끝내는 것이 운을 살립니다.';

  @override
  String get insightForDementiaHigh =>
      '인지 자극을 꾸준히 주는 흐름이 이어지고 있어, 치매 예방을 생각할 때도 생활 리듬을 유지하기 좋은 편입니다. (점수는 참고용)';

  @override
  String get insightForLearningHigh => '집중·기억이 함께 받쳐줘 공부·업무 몰입에 유리한 흐름으로 보입니다.';

  @override
  String get insightForFocusHigh => '집중 운이 비교적 좋은 편이라 중요한 일은 초반에 처리하는 것이 좋습니다.';

  @override
  String get insightForCoordinationHigh =>
      '좌우 맞춤·반응이 비교적 잘 맞는 흐름이에요. 가벼운 스트레칭이나 균형 활동과 함께 유지하면 좋습니다. (참고용)';

  @override
  String get insightForDefault =>
      '무리하지 않고 리듬을 지키면 안정적인 흐름으로 이어질 수 있습니다. 치매 예방도 하루아침에 결정되지 않으니, 작은 습관을 오래 유지하는 것이 중요해요.';

  @override
  String get trendNoRecords => '아직 저장된 기록이 없습니다. 측정·훈련·마음 기록을 남겨보세요.';

  @override
  String trendAccumulated(Object count, Object days) {
    return '누적 측정·훈련 $count건 · 활동일 $days일';
  }

  @override
  String trendMindDays(Object days) {
    return '마음 기록 $days일';
  }

  @override
  String get trendNeedMoreDays => '기록이 더 쌓이면, 가장 이른 날과 가장 최근 날 점수를 비교해 드립니다.';

  @override
  String trendMoodFirstLast(Object a, Object b) {
    return '기분 기록: 처음 $a → 최근 $b';
  }

  @override
  String trendCompare(Object from, Object to) {
    return '비교: $from → $to';
  }

  @override
  String trendPillarLine(Object name, Object from, Object to, Object delta) {
    return '$name $from → $to $delta';
  }

  @override
  String trendMoodRecord(Object a, Object b) {
    return '기분(마음 기록) $a → $b';
  }

  @override
  String get trendNameMemory => '기억';

  @override
  String get trendNameFocus => '집중';

  @override
  String get trendNameReaction => '반응';

  @override
  String get trendNameCoordination => '협응';

  @override
  String get trendNameNumeracy => '수리';

  @override
  String get trendNameReasoning => '추론(그림자)';

  @override
  String get trendNameSpatial => '시공간(미로)';

  @override
  String get trendNameDementia => '치매 예방 참고';

  @override
  String get trendNameLearning => '학습 참고';

  @override
  String get trendNameEmotional => '정서·수면 참고';

  @override
  String get trendDeltaFlat => '유지';

  @override
  String get trendDeltaUp => '↑';

  @override
  String get trendDeltaDown => '↓';

  @override
  String get testTypeMemory => '기억';

  @override
  String get testTypeFocus => '집중';

  @override
  String get testTypeBreathing => '호흡';

  @override
  String get testTypeStroop => 'Stroop';

  @override
  String get testTypeCpt => '선택 집중';

  @override
  String get testTypeReaction => '반응';

  @override
  String get testTypeCoordination => '협응';

  @override
  String get testTypeNumeracy => '셈하기';

  @override
  String get testTypeShadow => '그림자 찾기';

  @override
  String get testTypeMaze => '미로';

  @override
  String reportLineTimeScore(Object time, Object score) {
    return '$time · 점수 $score';
  }

  @override
  String reportBreathingDetail(Object n, Object mode) {
    return '호흡 반영 $n/4 · $mode';
  }

  @override
  String get breathModeMic => '마이크';

  @override
  String get breathModeManual => '수동';

  @override
  String get localAiTitle => '로컬 AI (Ollama)';

  @override
  String get localAiMenuTitle => '로컬 AI 대화';

  @override
  String get localAiMenuSubtitle => 'PC의 Ollama만 사용 · 클라우드 없음';

  @override
  String get localAiDisclaimer =>
      '이 화면의 질문·답변은 같은 Wi‑Fi(또는 이 기기)에서 실행 중인 Ollama로만 전송됩니다. 인터넷으로 보내지 않습니다. 의학적 진단이 아닙니다.';

  @override
  String get localAiOllamaSetupHint =>
      '연결이 안 되면: PC에 Ollama를 설치·실행했는지 확인하세요. Windows에서는 트레이의 Ollama 아이콘 또는 터미널에서 ollama serve 가 동작해야 합니다. 모델은 ollama pull llama3.2 등으로 받을 수 있습니다. 설정의 주소가 http://127.0.0.1:11434 인지 확인하세요.';

  @override
  String get localAiErrConnectionRefused =>
      '이 PC의 11434 포트에서 Ollama가 응답하지 않습니다. Ollama를 실행한 뒤 연결 테스트를 다시 눌러 주세요.';

  @override
  String get localAiErrTimeout =>
      '응답 시간이 초과되었습니다. 잠시 후 다시 시도하거나, 모델이 무거우면 시간이 더 걸릴 수 있습니다.';

  @override
  String get localAiErrDnsFailed =>
      '서버 주소를 찾을 수 없습니다. 설정에서 주소(예: http://127.0.0.1:11434)를 확인하세요.';

  @override
  String get localAiErrEmptyBase => '서버 주소가 비어 있습니다. 설정에서 주소를 입력하세요.';

  @override
  String get localAiErrUnexpectedResponse =>
      '서버 응답을 해석할 수 없습니다. 설정의 모델 이름이 설치된 모델과 같은지 확인하세요.';

  @override
  String get localAiSettingsTitle => 'Ollama 연결';

  @override
  String get localAiBaseUrlLabel => '서버 주소';

  @override
  String get localAiModelLabel => '모델 이름';

  @override
  String get localAiSave => '저장';

  @override
  String get localAiHintEmulator =>
      'Android 에뮬레이터: http://10.0.2.2:11434 · 실제 기기: PC의 LAN IP(예: http://192.168.0.10:11434)';

  @override
  String get localAiMessageHint => '메시지 입력';

  @override
  String get localAiThinking => '답변 생성 중…';

  @override
  String get localAiTestConnection => '연결 테스트';

  @override
  String get localAiTesting => '연결 확인 중…';

  @override
  String get localAiPingOk => 'Ollama에 연결되었습니다.';

  @override
  String localAiPingFail(Object msg) {
    return '연결 실패: $msg';
  }

  @override
  String localAiErrorGeneric(Object detail) {
    return '응답을 받지 못했습니다.\n$detail';
  }

  @override
  String get localAiSpeechUnavailable =>
      '이 기기에서 음성 인식을 쓸 수 없습니다. 키보드로 입력해 주세요.';

  @override
  String get localAiMicListen => '말하기';

  @override
  String get localAiMicStop => '중지';

  @override
  String get localAiSpeakReply => '답변 읽기';

  @override
  String get localAiListening => '듣는 중… 말씀해 주세요';

  @override
  String get localAiOpenOllamaDownload => 'Ollama 다운로드 페이지 열기';

  @override
  String get localAiCouldNotOpenLink => '링크를 열 수 없습니다.';
}
