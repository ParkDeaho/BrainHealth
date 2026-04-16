// =============================================
// BrainFit REST API 타입 정의
// Base URL: /api/v1
// =============================================

// ===== 공통 응답 =====
export interface ApiResponse<T> {
  success: boolean;
  data: T | null;
  message: string | null;
  errorCode?: string;
}

// ===== A. 인증 / 사용자 =====

export interface LoginRequest {
  loginType: 'guest' | 'kakao' | 'google' | 'apple';
  loginKey?: string;
  nickname: string;
  birthYear?: number;
  gender?: 'male' | 'female' | 'other';
  userMode: 'senior' | 'student' | 'general';
}

export interface LoginResponse {
  userId: number;
  accessToken: string;
  refreshToken: string;
  isNewUser: boolean;
}

export interface UserMeResponse {
  userId: number;
  nickname: string;
  birthYear?: number;
  gender?: string;
  userMode: string;
  targetGoal?: string;
}

export interface ProfileUpdateRequest {
  nickname?: string;
  targetGoal?: 'memory' | 'focus' | 'routine';
  sleepTargetHours?: number;
}

// ===== B. 일일 체크인 =====

export interface DailyConditionRequest {
  sleepHours: number;
  sleepQuality: number;
  stressLevel: number;
  moodLevel: number;
  anxietyLevel?: number;
  motivationLevel?: number;
  fatigueLevel: number;
  exerciseYn: 'Y' | 'N';
  screenTimeMin?: number;
  note?: string;
  emotionNote?: string;
  mindCheckCompleted?: boolean;
}

export interface DailyConditionResponse {
  conditionId: number;
  message: string;
}

// ===== C. 문진 =====

export interface QuestionItem {
  questionId: number;
  questionText: string;
  answerType: 'scale_0_3' | 'yes_no' | 'scale_1_5';
  sortOrder: number;
}

export interface QuestionnaireSessionCreateResponse {
  sessionId: number;
}

export interface QuestionnaireAnswerRequest {
  answers: { questionId: number; answerValue: string }[];
}

export interface QuestionnaireCompleteResponse {
  sessionId: number;
  totalScore: number;
  resultLevel: 'normal' | 'observe' | 'manage';
  summary: string;
}

// ===== D. 인지 테스트 =====

export interface TestMasterItem {
  testId: number;
  testCode: string;
  testName: string;
  domainType: 'memory' | 'focus' | 'reaction' | 'executive';
  durationSec: number;
}

export interface TestSessionCreateRequest {
  testCode: string;
  sessionType: 'daily' | 'weekly' | 'baseline';
}

export interface TestSessionCreateResponse {
  sessionId: number;
  testCode: string;
}

export interface TestEventRequest {
  events: {
    eventOrder: number;
    stimulusValue?: string;
    userInputValue?: string;
    correctYn: 'Y' | 'N';
    reactionTimeMs?: number;
    extraData?: Record<string, unknown>;
  }[];
}

export interface TestCompleteRequest {
  rawScore: number;
  accuracy?: number;
  reactionTimeAvg?: number;
  reactionTimeSd?: number;
}

export interface TestCompleteResponse {
  sessionId: number;
  normalizedScore: number;
  resultLevel: string;
  domainType: string;
  summary: string;
}

// ===== E. 훈련 게임 =====

export interface GameResultRequest {
  gameCode: string;
  levelNo: number;
  score: number;
  accuracy?: number;
  durationSec?: number;
  streakCount?: number;
}

export interface GameRecommendation {
  gameCode: string;
  gameName: string;
  reason: string;
}

// ===== F. 리포트 =====

export interface TodayReportResponse {
  reportDate: string;
  memoryScore: number;
  focusScore: number;
  reactionScore: number;
  summaryText: string;
  recommendationText: string;
  detailLockedYn: 'Y' | 'N';
}

export interface WeeklyReportResponse {
  startDate: string;
  endDate: string;
  memoryAvg: number;
  focusAvg: number;
  reactionAvg: number;
  bestDay: string;
  sleepFocusCorrelation?: string;
  recommendations: string[];
}

export interface MonthlyReportResponse {
  month: string;
  memoryAvg: number;
  focusAvg: number;
  reactionAvg: number;
  improvedAreas: string[];
  stagnantAreas: string[];
  recommendations: string[];
}

// ===== G. 광고 보상 =====

export interface AdRewardCompleteRequest {
  rewardType: 'report_detail' | 'extra_training' | 'bonus_ticket';
  adNetwork: 'admob';
}

export interface AdRewardCompleteResponse {
  rewardId: number;
  expireAt: string;
}

export interface AdRewardStatusResponse {
  available: boolean;
  expireAt?: string;
}

// ===== H. 보호자 연결 =====

export interface GuardianLinkRequest {
  guardianName: string;
  guardianPhone?: string;
  guardianEmail?: string;
  shareSummaryYn: 'Y' | 'N';
  shareAlertYn: 'Y' | 'N';
}

export interface GuardianLinkResponse {
  linkId: number;
  guardianName: string;
  status: 'pending' | 'active';
}

export interface GuardianLinkUpdateRequest {
  shareSummaryYn?: 'Y' | 'N';
  shareAlertYn?: 'Y' | 'N';
}

// ===== I. 센서/키오스크 =====

export interface DeviceMeasurementRequest {
  sourceType: 'kiosk' | 'wearable' | 'sensor';
  measureType: 'hrv' | 'bp' | 'sleep' | 'steps' | 'body_composition';
  measureValue?: number;
  measureJson?: Record<string, unknown>;
  measuredAt: string;
}

// ===== J. 날씨 =====

export interface WeatherCurrentResponse {
  temperature: number;
  humidity: number;
  weatherType: 'sunny' | 'cloudy' | 'overcast' | 'rain' | 'snow' | 'fog';
  pm25: number;
  feelsLike: number;
  pressure?: number;
  recordedAt: string;
}

export interface WeatherInsightResponse {
  temperature: number;
  weatherType: string;
  pm25: number;
  impact: 'focus_down' | 'focus_up' | 'speed_down' | 'speed_up' | 'memory_down' | 'memory_up' | 'neutral';
  message: string;
  detail: string;
  recommendation: string;
}

export interface WeatherCorrelationResponse {
  period: string;
  correlations: {
    factor: string;
    metric: string;
    difference: number;
    description: string;
  }[];
}

// ===== API 엔드포인트 경로 =====

export const API_PATHS = {
  AUTH_LOGIN: '/api/v1/auth/login',
  USERS_ME: '/api/v1/users/me',
  USERS_PROFILE: '/api/v1/users/profile',

  DAILY_CONDITIONS: '/api/v1/daily-conditions',
  DAILY_CONDITIONS_LATEST: '/api/v1/daily-conditions/latest',

  QUESTIONNAIRES: '/api/v1/questionnaires',
  QUESTIONNAIRE_SESSIONS: '/api/v1/questionnaire-sessions',

  TESTS: '/api/v1/tests',
  TEST_SESSIONS: '/api/v1/test-sessions',
  TESTS_SUMMARY_TODAY: '/api/v1/tests/summary/today',

  GAMES: '/api/v1/games',
  GAME_RESULTS: '/api/v1/game-results',
  GAME_RECOMMENDATIONS: '/api/v1/games/recommendations',

  REPORTS_TODAY: '/api/v1/reports/today',
  REPORTS_WEEKLY: '/api/v1/reports/weekly',
  REPORTS_MONTHLY: '/api/v1/reports/monthly',
  REPORTS_INSIGHT: '/api/v1/reports/insight',

  AD_REWARDS_COMPLETE: '/api/v1/ad-rewards/complete',
  AD_REWARDS_STATUS: '/api/v1/ad-rewards/status',

  GUARDIAN_LINKS: '/api/v1/guardian-links',

  DEVICE_MEASUREMENTS: '/api/v1/device-measurements',
  DEVICE_MEASUREMENTS_SUMMARY: '/api/v1/device-measurements/summary',

  WEATHER_CURRENT: '/api/v1/weather/current',
  WEATHER_INSIGHT: '/api/v1/weather/insight',
  WEATHER_CORRELATION: '/api/v1/weather/correlation',
} as const;
