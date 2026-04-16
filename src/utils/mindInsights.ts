import type { DailyCondition } from '../types';

type TestRow = { date: string; score: number; category: string };
type GameRow = { date: string };

function avgFocusOnDays(ds: string[], testResults: TestRow[]): number | null {
  const scores = ds.flatMap(d =>
    testResults.filter(t => t.date === d && t.category === 'focus').map(t => t.score),
  );
  return scores.length ? scores.reduce((a, b) => a + b, 0) / scores.length : null;
}

/** 주간 리포트용: 마음 기록과 측정·훈련의 관계 문구 (해석용, 진단 아님) */
export function buildMindCorrelationLines(
  dates: string[],
  conditions: DailyCondition[],
  testResults: TestRow[],
  gameResults: GameRow[],
): string[] {
  const lines: string[] = [];
  const byDate = new Map(conditions.map(c => [c.date, c]));

  const withMind = dates.filter(d => byDate.has(d));
  if (withMind.length < 3) {
    return ['마음 컨디션을 며칠 더 기록하면 패턴 분석이 정교해져요.'];
  }

  const stressHigh = withMind.filter(d => (byDate.get(d)?.stressLevel ?? 0) >= 4);
  const stressLow = withMind.filter(d => (byDate.get(d)?.stressLevel ?? 0) <= 2);
  const fSt = avgFocusOnDays(stressHigh, testResults);
  const fCalm = avgFocusOnDays(stressLow, testResults);
  if (stressHigh.length >= 2 && stressLow.length >= 2 && fSt !== null && fCalm !== null && fCalm - fSt > 5) {
    lines.push('스트레스가 높게 기록된 날에는 집중력 측정 점수가 평균적으로 더 낮았습니다.');
  }

  const moodLow = withMind.filter(d => (byDate.get(d)?.moodLevel ?? 0) <= 2);
  if (moodLow.length >= 2) {
    const gLow = moodLow.reduce((n, d) => n + gameResults.filter(g => g.date === d).length, 0) / moodLow.length;
    const rest = withMind.filter(d => !moodLow.includes(d));
    const gRest = rest.length
      ? rest.reduce((n, d) => n + gameResults.filter(g => g.date === d).length, 0) / rest.length
      : 0;
    if (rest.length >= 2 && gLow + 0.15 < gRest) {
      lines.push('기분이 가라앉았다고 느낀 날에는 훈련 참여가 줄어든 경향이 있었습니다.');
    }
  }

  const anxHigh = withMind.filter(d => (byDate.get(d)?.anxietyLevel ?? 0) >= 4);
  const speedOnAnx = anxHigh.flatMap(d =>
    testResults.filter(t => t.date === d && t.category === 'speed').map(t => t.score),
  );
  const speedOther = withMind
    .filter(d => !anxHigh.includes(d))
    .flatMap(d => testResults.filter(t => t.date === d && t.category === 'speed').map(t => t.score));
  if (anxHigh.length >= 2 && speedOnAnx.length >= 2 && speedOther.length >= 2) {
    const a = speedOnAnx.reduce((x, y) => x + y, 0) / speedOnAnx.length;
    const b = speedOther.reduce((x, y) => x + y, 0) / speedOther.length;
    if (b - a > 5) {
      lines.push('불안이 높게 느껴졌던 날에는 반응속도 점수 변동이 커진 경향이 있습니다.');
    }
  }

  const motLow = withMind.filter(d => (byDate.get(d)?.motivationLevel ?? 0) <= 2);
  if (motLow.length >= 2) {
    lines.push('의욕이 낮게 기록된 날이 있었다면, 긴 과제보다 짧은 훈련부터 시작해 보는 것을 권해 드려요.');
  }

  if (lines.length === 0) {
    lines.push('최근 마음 컨디션과 측정 결과를 함께 보면, 본인에게 맞는 리듬을 찾는 데 도움이 됩니다.');
  }

  return lines;
}
