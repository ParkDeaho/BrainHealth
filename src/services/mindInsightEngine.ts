/**
 * 마음 기록 + 측정 점수 룰 기반 해석 (점수 조작 없음, 설명·추천 전용)
 * Flutter MindInsightEngine 와 동일 역할을 하도록 유지합니다.
 */

export type UserModeLite = 'senior' | 'student' | 'general';

export interface MindInsightInput {
  mood: number;
  stress: number;
  motivation: number;
  focusScore: number;
  memoryScore: number;
  speedScore: number;
  sleepHours?: number;
}

/** 기분 1~5 → 짧은 라벨 (홈 카드 등) */
export function moodShortLabel(mood: number): { emoji: string; text: string } {
  const m = Math.round(mood);
  const rows: { min: number; emoji: string; text: string }[] = [
    { min: 5, emoji: '😄', text: '매우 좋음' },
    { min: 4, emoji: '🙂', text: '좋음' },
    { min: 3, emoji: '😐', text: '보통' },
    { min: 2, emoji: '😟', text: '나쁨' },
    { min: 1, emoji: '😣', text: '매우 나쁨' },
  ];
  const hit = rows.find(r => m >= r.min) ?? rows[rows.length - 1];
  return { emoji: hit.emoji, text: hit.text };
}

export function generateInsight(input: MindInsightInput): string {
  const { mood, stress, motivation, focusScore, memoryScore, speedScore, sleepHours } = input;

  if (stress >= 4 && focusScore > 0 && focusScore < 70) {
    return '스트레스 영향으로 집중 흐름이 흔들릴 수 있습니다. 짧게 나눠 진행해 보세요.';
  }

  if (mood >= 4 && memoryScore > 75) {
    return '기억 정리가 잘 되는 흐름입니다. 암기·정리 작업에 맞는 날이에요.';
  }

  if (motivation <= 2) {
    return '의욕이 낮게 느껴지는 날입니다. 가벼운 훈련부터 시작해 보세요.';
  }

  if (mood <= 2 && focusScore > 0 && focusScore < 65) {
    return '기분이 가라앉은 날에는 집중이 잠깐 끊기기 쉬워요. 짧은 성공 경험부터 쌓아 보세요.';
  }

  if (sleepHours !== undefined && sleepHours < 6 && speedScore > 0 && speedScore < 60) {
    return '수면 여유가 적은 날에는 반응속도가 느려질 수 있어요. 휴식을 먼저 챙겨 보세요.';
  }

  if (focusScore > 0 && memoryScore > 0 && focusScore >= 70 && memoryScore >= 70) {
    return '안정적인 흐름입니다. 꾸준히 유지해 보세요.';
  }

  return '오늘 기록과 측정을 바탕으로, 본인에게 맞는 리듬을 찾아가면 좋아요.';
}

/** 오늘 리포트 상단 한마디 (감정 + 점수 결합) */
export function generateTodayMessage(input: MindInsightInput): string {
  const base = generateInsight(input);
  if (input.stress >= 4 && input.focusScore > 0 && input.focusScore < 70) {
    return `최근 마음 기록상 스트레스가 높은 편입니다. ${base}`;
  }
  return base;
}

export interface ContentRecommendation {
  title: string;
  path: string;
  reason: string;
}

/** 추천 콘텐츠 (규칙 예시와 동일한 방향) */
export function recommendContent(input: MindInsightInput): ContentRecommendation {
  const { stress, motivation, mood, focusScore, memoryScore } = input;

  if (stress >= 4) {
    return { title: '호흡·안정 훈련', path: '/training/breathing', reason: '스트레스가 높게 느껴질 때는 호흡으로 마음부터 가볍게 할 수 있어요.' };
  }
  if (motivation <= 2) {
    return { title: '쉬운 기억 게임', path: '/training/card-match', reason: '의욕이 낮은 날에는 부담 적은 게임부터 시작해 보세요.' };
  }
  if (mood <= 2) {
    return { title: '짧은 집중 회복', path: '/training/sequence-memory', reason: '기분이 가라앉은 날에는 짧은 성공 경험이 도움이 될 수 있어요.' };
  }
  if (focusScore > 0 && focusScore < 60) {
    return { title: 'Stroop 집중', path: '/tests/stroop', reason: '집중 점수가 낮게 보일 때는 짧은 집중 과제가 잘 맞아요.' };
  }
  if (memoryScore > 0 && memoryScore < 60) {
    return { title: '카드 맞추기', path: '/training/card-match', reason: '기억력을 가볍게 깨워 보고 싶을 때 추천해요.' };
  }

  return { title: '오늘의 루틴', path: '/routine', reason: '꾸준한 작은 습관이 뇌 컨디션에 도움이 됩니다.' };
}

/** 모드별 감성 한 줄 (운세 톤, 진단 아님) */
export function modeFortuneLine(mode: UserModeLite, input: Pick<MindInsightInput, 'stress' | 'motivation' | 'mood'>): string {
  if (mode === 'student') {
    if (input.stress >= 4) {
      return '오늘은 마음이 다소 분산되는 흐름입니다. 짧은 시간 집중 후 휴식을 반복해 보세요.';
    }
    return '오늘 컨디션에 맞게 공부 리듬을 조절해 보세요.';
  }
  if (mode === 'senior') {
    return '오늘은 무리한 활동보다 안정적인 루틴이 도움이 되는 날일 수 있어요.';
  }
  return '환경과 마음 상태에 맞춰 천천히 진행해 보세요.';
}
