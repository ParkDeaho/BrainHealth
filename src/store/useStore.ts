import { useState, useCallback, useEffect } from 'react';
import type {
  DailyCheckIn,
  DailyCondition,
  TestResult,
  GameResult,
  DailyRoutine,
  RoutineItem,
  UserProfile,
  QuestionnaireResult,
  CoreMetrics,
  MetricCategory,
  AdReward,
  QuestionCategory,
  GuardianLink,
} from '../types';
import { getToday } from '../utils/date';

const KEYS = {
  CHECK_INS: 'bt_checkins',
  CONDITIONS: 'bt_conditions',
  TEST_RESULTS: 'bt_tests',
  GAME_RESULTS: 'bt_games',
  ROUTINES: 'bt_routines',
  PROFILE: 'bt_profile',
  QUESTIONNAIRES: 'bt_questionnaires',
  AD_REWARDS: 'bt_rewards',
  GUARDIANS: 'bt_guardians',
} as const;

function load<T>(key: string, fallback: T): T {
  try {
    const raw = localStorage.getItem(key);
    return raw ? JSON.parse(raw) : fallback;
  } catch {
    return fallback;
  }
}

function save(key: string, data: unknown) {
  localStorage.setItem(key, JSON.stringify(data));
}

const DEFAULT_ROUTINES: Omit<RoutineItem, 'completed'>[] = [
  { id: 'walk', label: '30분 걷기', icon: '🚶' },
  { id: 'water', label: '물 8잔 마시기', icon: '💧' },
  { id: 'sleep', label: '7시간 수면', icon: '😴' },
  { id: 'read', label: '10분 독서', icon: '📖' },
  { id: 'breathe', label: '호흡/명상', icon: '🧘' },
  { id: 'measure', label: '혈압/스트레스 측정', icon: '❤️' },
];

// ===== Profile =====
export function useProfile() {
  const [profile, setProfile] = useState<UserProfile | null>(() => load(KEYS.PROFILE, null));
  useEffect(() => { save(KEYS.PROFILE, profile); }, [profile]);

  const saveProfile = useCallback((data: Omit<UserProfile, 'createdAt' | 'streakDays' | 'lastActiveDate'>) => {
    setProfile(prev => {
      const today = getToday();
      const prevStreak = prev?.streakDays ?? 0;
      const prevDate = prev?.lastActiveDate ?? '';
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      const yesterdayStr = yesterday.toISOString().slice(0, 10);

      let streak = 1;
      if (prevDate === today) streak = prevStreak;
      else if (prevDate === yesterdayStr) streak = prevStreak + 1;

      return { ...data, createdAt: prev?.createdAt ?? Date.now(), streakDays: streak, lastActiveDate: today };
    });
  }, []);

  const updateStreak = useCallback(() => {
    setProfile(prev => {
      if (!prev) return prev;
      const today = getToday();
      if (prev.lastActiveDate === today) return prev;
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      const streak = prev.lastActiveDate === yesterday.toISOString().slice(0, 10) ? prev.streakDays + 1 : 1;
      return { ...prev, streakDays: streak, lastActiveDate: today };
    });
  }, []);

  const hasOnboarded = profile !== null;
  return { profile, saveProfile, hasOnboarded, updateStreak };
}

// ===== Questionnaire =====
export function useQuestionnaires() {
  const [data, setData] = useState<QuestionnaireResult[]>(() => load(KEYS.QUESTIONNAIRES, []));
  useEffect(() => { save(KEYS.QUESTIONNAIRES, data); }, [data]);

  const addResult = useCallback((
    category: QuestionCategory, answers: Record<string, number>, totalScore: number, maxPossible: number,
  ) => {
    setData(prev => {
      const today = getToday();
      return [...prev.filter(q => !(q.date === today && q.category === category)),
        { date: today, category, answers, totalScore, maxPossible, timestamp: Date.now() }];
    });
  }, []);

  const getTodayByCategory = useCallback((category: QuestionCategory): QuestionnaireResult | undefined => {
    return data.find(q => q.date === getToday() && q.category === category);
  }, [data]);

  const getLatestByCategory = useCallback((category: QuestionCategory): QuestionnaireResult | undefined => {
    const f = data.filter(q => q.category === category);
    return f.length > 0 ? f[f.length - 1] : undefined;
  }, [data]);

  return { questionnaires: data, addResult, getTodayByCategory, getLatestByCategory };
}

const DEFAULT_DAILY_CONDITION: Omit<DailyCondition, 'date' | 'timestamp'> = {
  sleepHours: 7,
  sleepQuality: 3,
  stressLevel: 3,
  moodLevel: 3,
  anxietyLevel: 3,
  motivationLevel: 3,
  fatigueLevel: 3,
  exerciseYn: false,
  screenTimeMin: 120,
  focusTimeMin: 0,
  emotionNote: '',
  mindCheckCompleted: false,
};

export function normalizeDailyCondition(raw: DailyCondition): DailyCondition {
  return {
    ...raw,
    anxietyLevel: raw.anxietyLevel ?? 3,
    motivationLevel: raw.motivationLevel ?? 3,
    emotionNote: raw.emotionNote ?? '',
    mindCheckCompleted: raw.mindCheckCompleted ?? false,
  };
}

// ===== Daily Condition =====
export function useDailyCondition() {
  const [conditions, setConditions] = useState<DailyCondition[]>(() => {
    const raw = load<DailyCondition[]>(KEYS.CONDITIONS, []);
    return raw.map(normalizeDailyCondition);
  });
  useEffect(() => { save(KEYS.CONDITIONS, conditions); }, [conditions]);

  const addCondition = useCallback((data: Omit<DailyCondition, 'date' | 'timestamp'>) => {
    setConditions(prev => [...prev.filter(c => c.date !== getToday()),
      { ...data, date: getToday(), timestamp: Date.now() }]);
  }, []);

  /** 오늘 행이 있으면 병합, 없으면 기본값과 합쳐 저장 (마음 기록 등 부분 업데이트용) */
  const upsertTodayCondition = useCallback((partial: Partial<Omit<DailyCondition, 'date' | 'timestamp'>>) => {
    setConditions(prev => {
      const today = getToday();
      const existing = prev.find(c => c.date === today);
      const base: Omit<DailyCondition, 'date' | 'timestamp'> = existing
        ? normalizeDailyCondition(existing)
        : { ...DEFAULT_DAILY_CONDITION };
      const merged: DailyCondition = {
        ...base,
        ...partial,
        date: today,
        timestamp: Date.now(),
      };
      return [...prev.filter(c => c.date !== today), merged];
    });
  }, []);

  const getTodayCondition = useCallback((): DailyCondition | undefined => {
    const c = conditions.find(x => x.date === getToday());
    return c ? normalizeDailyCondition(c) : undefined;
  }, [conditions]);

  return { conditions, addCondition, upsertTodayCondition, getTodayCondition };
}

// ===== Check-Ins (legacy) =====
export function useCheckIns() {
  const [checkIns, setCheckIns] = useState<DailyCheckIn[]>(() => load(KEYS.CHECK_INS, []));
  useEffect(() => { save(KEYS.CHECK_INS, checkIns); }, [checkIns]);

  const addCheckIn = useCallback((data: Omit<DailyCheckIn, 'date' | 'timestamp'>) => {
    setCheckIns(prev => [...prev.filter(c => c.date !== getToday()),
      { ...data, date: getToday(), timestamp: Date.now() }]);
  }, []);

  const getTodayCheckIn = useCallback((): DailyCheckIn | undefined => {
    return checkIns.find(c => c.date === getToday());
  }, [checkIns]);

  return { checkIns, addCheckIn, getTodayCheckIn };
}

// ===== Test Results =====
export function useTestResults() {
  const [results, setResults] = useState<TestResult[]>(() => load(KEYS.TEST_RESULTS, []));
  useEffect(() => { save(KEYS.TEST_RESULTS, results); }, [results]);

  const addResult = useCallback((data: Omit<TestResult, 'date' | 'timestamp'>) => {
    setResults(prev => [...prev, { ...data, date: getToday(), timestamp: Date.now() }]);
  }, []);

  const getTodayResults = useCallback((): TestResult[] => results.filter(r => r.date === getToday()), [results]);
  const getResultsByCategory = useCallback((category: MetricCategory): TestResult[] => results.filter(r => r.category === category), [results]);
  const getResultsByDateRange = useCallback((dates: string[]): TestResult[] => { const s = new Set(dates); return results.filter(r => s.has(r.date)); }, [results]);

  return { results, addResult, getTodayResults, getResultsByCategory, getResultsByDateRange };
}

// ===== Game Results =====
export function useGameResults() {
  const [results, setResults] = useState<GameResult[]>(() => load(KEYS.GAME_RESULTS, []));
  useEffect(() => { save(KEYS.GAME_RESULTS, results); }, [results]);

  const addResult = useCallback((data: Omit<GameResult, 'date' | 'timestamp'>) => {
    setResults(prev => [...prev, { ...data, date: getToday(), timestamp: Date.now() }]);
  }, []);

  const getTodayResults = useCallback((): GameResult[] => results.filter(r => r.date === getToday()), [results]);
  return { gameResults: results, addGameResult: addResult, getTodayGameResults: getTodayResults };
}

// ===== Core Metrics =====
export function useCoreMetrics() {
  const { results } = useTestResults();
  const { questionnaires } = useQuestionnaires();

  const calculate = useCallback((dates?: string[]): CoreMetrics => {
    const filtered = dates ? results.filter(r => dates.includes(r.date)) : results;
    const byCategory = (cat: MetricCategory) => {
      const catResults = filtered.filter(r => r.category === cat);
      if (catResults.length === 0) return 0;
      const recent = catResults.slice(-5);
      return Math.round(recent.reduce((s, r) => s + r.score, 0) / recent.length);
    };
    return { memory: byCategory('memory'), focus: byCategory('focus'), speed: byCategory('speed') };
  }, [results]);

  const getLatestSCI = useCallback((): number => {
    const memQ = questionnaires.filter(q => q.category === 'memory');
    if (memQ.length === 0) return 0;
    const latest = memQ[memQ.length - 1];
    return Math.round((1 - latest.totalScore / latest.maxPossible) * 100);
  }, [questionnaires]);

  return { calculate, getLatestSCI };
}

// ===== Routines =====
export function useRoutines() {
  const [routines, setRoutines] = useState<DailyRoutine[]>(() => load(KEYS.ROUTINES, []));
  useEffect(() => { save(KEYS.ROUTINES, routines); }, [routines]);

  const getTodayRoutine = useCallback((): DailyRoutine => {
    const today = getToday();
    const existing = routines.find(r => r.date === today);
    if (existing) return existing;
    return { date: today, items: DEFAULT_ROUTINES.map(r => ({ ...r, completed: false })) };
  }, [routines]);

  const toggleRoutineItem = useCallback((itemId: string) => {
    setRoutines(prev => {
      const today = getToday();
      const existing = prev.find(r => r.date === today);
      if (existing) {
        return prev.map(r => r.date === today
          ? { ...r, items: r.items.map(item => item.id === itemId ? { ...item, completed: !item.completed } : item) }
          : r);
      }
      return [...prev, { date: today, items: DEFAULT_ROUTINES.map(r => ({ ...r, completed: r.id === itemId })) }];
    });
  }, []);

  return { routines, getTodayRoutine, toggleRoutineItem };
}

// ===== Ad Rewards =====
export function useAdRewards() {
  const [rewards, setRewards] = useState<AdReward[]>(() => load(KEYS.AD_REWARDS, []));
  useEffect(() => { save(KEYS.AD_REWARDS, rewards); }, [rewards]);

  const addReward = useCallback((type: AdReward['type']) => {
    setRewards(prev => [...prev, { type, rewardedAt: Date.now() }]);
  }, []);

  const hasRewardToday = useCallback((type: AdReward['type']): boolean => {
    const todayStr = new Date().toDateString();
    return rewards.some(r => r.type === type && new Date(r.rewardedAt).toDateString() === todayStr);
  }, [rewards]);

  const todayRewardCount = rewards.filter(r => new Date(r.rewardedAt).toDateString() === new Date().toDateString()).length;

  return { rewards, addReward, hasRewardToday, todayRewardCount };
}

// ===== Guardians =====
export function useGuardians() {
  const [guardians, setGuardians] = useState<GuardianLink[]>(() => load(KEYS.GUARDIANS, []));
  useEffect(() => { save(KEYS.GUARDIANS, guardians); }, [guardians]);

  const addGuardian = useCallback((data: Omit<GuardianLink, 'id' | 'createdAt' | 'status'>) => {
    setGuardians(prev => [...prev, { ...data, id: Date.now().toString(36), status: 'active', createdAt: Date.now() }]);
  }, []);

  const removeGuardian = useCallback((id: string) => {
    setGuardians(prev => prev.filter(g => g.id !== id));
  }, []);

  return { guardians, addGuardian, removeGuardian };
}
