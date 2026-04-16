// ===== User =====
export type UserMode = 'senior' | 'student' | 'general';
export type AgeGroup = '10s' | '20s' | '30s' | '40s' | '50s' | '60s+';
export type Gender = 'male' | 'female' | 'other';

export interface UserProfile {
  nickname: string;
  birthYear?: number;
  gender?: Gender;
  ageGroup: AgeGroup;
  mode: UserMode;
  targetGoal: 'memory' | 'focus' | 'routine';
  guardianName?: string;
  guardianPhone?: string;
  guardianEmail?: string;
  createdAt: number;
  streakDays: number;
  lastActiveDate: string;
}

// ===== Questionnaire =====
export type QuestionCategory = 'memory' | 'focus' | 'lifestyle';

export interface QuestionItem {
  id: string;
  text: string;
  category: QuestionCategory;
  maxScore: number;
}

export interface QuestionnaireResult {
  date: string;
  category: QuestionCategory;
  answers: Record<string, number>;
  totalScore: number;
  maxPossible: number;
  timestamp: number;
}

// ===== Daily Condition =====
/** 생활 + 마음 컨디션 (하루 1회 권장). 마음 항목은 분석 해석용 보조 데이터이며 진단이 아닙니다. */
export interface DailyCondition {
  date: string;
  sleepHours: number;
  sleepQuality: number;
  stressLevel: number;
  /** 기분 (1~5) */
  moodLevel: number;
  /** 불안감·마음의 긴장 (1~5, 높을수록 불안) */
  anxietyLevel: number;
  /** 의욕·활력 (1~5) */
  motivationLevel: number;
  fatigueLevel: number;
  exerciseYn: boolean;
  screenTimeMin: number;
  focusTimeMin: number;
  /** 한 줄 메모 (선택) */
  emotionNote: string;
  /** 짧은 마음 기록 플로우 완료 여부 */
  mindCheckCompleted: boolean;
  timestamp: number;
}

// ===== Cognitive Tests =====
export type TestType =
  | 'word-memory'
  | 'digit-span'
  | 'reaction-speed'
  | 'stroop'
  | 'cpt'
  | 'visual-tracking'
  | 'visual-pattern'
  | 'trail-making'
  | 'number-memory';

export type MetricCategory = 'memory' | 'focus' | 'speed';

export interface TestResult {
  date: string;
  type: TestType;
  score: number;
  level?: number;
  accuracy?: number;
  reactionTimeAvg?: number;
  metrics?: Record<string, number>;
  category: MetricCategory;
  timestamp: number;
}

// ===== Training Games =====
export type GameType =
  | 'card-match'
  | 'nback'
  | 'selective-focus'
  | 'sequence-memory'
  | 'reaction-tap'
  | 'breathing'
  | 'number-memory-game';

export interface GameResult {
  date: string;
  type: GameType;
  score: number;
  level?: number;
  durationSec?: number;
  accuracy?: number;
  timestamp: number;
}

// ===== Core Metrics =====
export interface CoreMetrics {
  memory: number;
  focus: number;
  speed: number;
}

export interface InsightReport {
  date: string;
  memoryScore: number;
  focusScore: number;
  reactionScore: number;
  summaryText: string;
  recommendations: string[];
}

// ===== Routines =====
export interface RoutineItem {
  id: string;
  label: string;
  icon: string;
  completed: boolean;
}

export interface DailyRoutine {
  date: string;
  items: RoutineItem[];
}

// ===== Ad Rewards =====
export interface AdReward {
  type: 'detail-report' | 'extra-game' | 'special-report' | 'badge';
  rewardedAt: number;
}

// ===== Guardian =====
export interface GuardianLink {
  id: string;
  name: string;
  phone?: string;
  email?: string;
  shareSummary: boolean;
  shareAlert: boolean;
  status: 'pending' | 'active';
  createdAt: number;
}

// ===== Weather =====
export type WeatherType = 'sunny' | 'cloudy' | 'overcast' | 'rain' | 'snow' | 'fog';

export interface WeatherData {
  date: string;
  temperature: number;
  humidity: number;
  weatherType: WeatherType;
  pm25: number;
  feelsLike?: number;
  pressure?: number;
  fetchedAt: number;
}

export type WeatherImpact = 'focus_down' | 'focus_up' | 'speed_down' | 'speed_up' | 'memory_down' | 'memory_up' | 'neutral';

export interface WeatherInsight {
  impact: WeatherImpact;
  message: string;
  detail: string;
  recommendation: string;
  icon: string;
}

export interface BrainFortune {
  date: string;
  memoryForecast: string;
  focusForecast: string;
  overallMessage: string;
  weatherFactor: string;
  icon: string;
}

// ===== Legacy compat =====
export type CheckInField = 'sleep' | 'focus' | 'fatigue' | 'mood';
export interface DailyCheckIn {
  date: string;
  sleep: number;
  focus: number;
  fatigue: number;
  mood: number;
  timestamp: number;
}
