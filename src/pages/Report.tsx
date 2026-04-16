import { useState, useMemo } from 'react';
import { Link } from 'react-router-dom';
import { AreaChart, Area, XAxis, YAxis, ResponsiveContainer, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar, Tooltip } from 'recharts';
import {
  useTestResults,
  useCheckIns,
  useCoreMetrics,
  useDailyCondition,
  useAdRewards,
  useGameResults,
} from '../store/useStore';
import { useWeather, analyzeWeatherImpact, analyzeWeatherCorrelation } from '../store/useWeather';
import { getLast7Days, getLast14Days, formatShort, getToday } from '../utils/date';
import { buildMindCorrelationLines } from '../utils/mindInsights';
import { generateTodayMessage, recommendContent } from '../services/mindInsightEngine';
import type { WeatherData, DailyCondition } from '../types';

type TabType = 'today' | 'weekly' | 'monthly' | 'insight';

export default function Report() {
  const [tab, setTab] = useState<TabType>('today');
  const { results, getResultsByDateRange } = useTestResults();
  const { checkIns } = useCheckIns();
  const { calculate } = useCoreMetrics();
  const { conditions } = useDailyCondition();
  const { gameResults } = useGameResults();
  const { hasRewardToday, addReward } = useAdRewards();
  const { weather } = useWeather();
  const [detailUnlocked, setDetailUnlocked] = useState(false);

  const metrics = calculate();
  const overallScore = Math.round((metrics.memory + metrics.focus + metrics.speed) / 3) || 0;
  const todayCondition = conditions.find(c => c.date === getToday());
  const todayCheckIn = checkIns.find(c => c.date === getToday());
  const weatherInsight = analyzeWeatherImpact(weather, metrics, todayCondition, todayCheckIn);

  const handleAdReward = () => {
    addReward('detail-report');
    setDetailUnlocked(true);
  };

  const radarData = [
    { area: '기억력', score: metrics.memory, fullMark: 100 },
    { area: '집중력', score: metrics.focus, fullMark: 100 },
    { area: '반응속도', score: metrics.speed, fullMark: 100 },
  ];

  const tabs: { key: TabType; label: string }[] = [
    { key: 'today', label: '오늘' },
    { key: 'weekly', label: '주간' },
    { key: 'monthly', label: '월간' },
    { key: 'insight', label: '인사이트' },
  ];

  return (
    <div className="page page--report">
      <h1 className="page-title">리포트</h1>

      <div className="report-tabs">
        {tabs.map(t => (
          <button key={t.key} className={`report-tab ${tab === t.key ? 'report-tab--active' : ''}`} onClick={() => setTab(t.key)}>
            {t.label}
          </button>
        ))}
      </div>

      {tab === 'today' && (
        <TodayTab
          metrics={metrics}
          radarData={radarData}
          overallScore={overallScore}
          results={results}
          weather={weather}
          weatherInsight={weatherInsight}
          todayCondition={todayCondition}
        />
      )}
      {tab === 'weekly' && (
        <WeeklyTab
          checkIns={checkIns}
          metrics={metrics}
          conditions={conditions}
          testResults={results}
          gameResults={gameResults}
          getResultsByDateRange={getResultsByDateRange}
        />
      )}
      {tab === 'monthly' && <MonthlyTab results={results} getResultsByDateRange={getResultsByDateRange} />}
      {tab === 'insight' && (
        <InsightTab
          metrics={metrics}
          conditions={conditions}
          checkIns={checkIns}
          weather={weather}
          results={results}
          detailUnlocked={detailUnlocked || hasRewardToday('detail-report')}
          onAdReward={handleAdReward}
        />
      )}
    </div>
  );
}

// ===== Today Tab =====
function TodayTab({ metrics, radarData, overallScore, results, weather, weatherInsight, todayCondition }: {
  metrics: { memory: number; focus: number; speed: number };
  radarData: { area: string; score: number; fullMark: number }[];
  overallScore: number;
  results: { date: string; type: string; score: number; category: string; timestamp: number }[];
  weather: WeatherData | null;
  weatherInsight: { impact: string; message: string; icon: string };
  todayCondition: DailyCondition | undefined;
}) {
  const todayResults = results.filter(r => r.date === getToday());
  const statusText = overallScore >= 70 ? '전반적으로 안정적인 상태입니다' : overallScore >= 40 ? '일부 영역 관리가 필요합니다' : overallScore > 0 ? '회복 훈련을 추천합니다' : '아직 측정 데이터가 없어요';

  const mindInsight = todayCondition?.mindCheckCompleted
    ? generateTodayMessage({
      mood: todayCondition.moodLevel,
      stress: todayCondition.stressLevel,
      motivation: todayCondition.motivationLevel,
      focusScore: metrics.focus,
      memoryScore: metrics.memory,
      speedScore: metrics.speed,
      sleepHours: todayCondition.sleepHours,
    })
    : null;

  const contentRec = todayCondition?.mindCheckCompleted
    ? recommendContent({
      mood: todayCondition.moodLevel,
      stress: todayCondition.stressLevel,
      motivation: todayCondition.motivationLevel,
      focusScore: metrics.focus,
      memoryScore: metrics.memory,
      speedScore: metrics.speed,
      sleepHours: todayCondition.sleepHours,
    })
    : null;

  return (
    <>
      {mindInsight && (
        <section className="card report-mind-today">
          <h3 className="card-title">오늘의 한마디</h3>
          <p className="report-mind-today-text">{mindInsight}</p>
          {contentRec && (
            <Link to={contentRec.path} className="report-mind-rec">
              <span className="report-mind-rec-title">{contentRec.title}</span>
              <span className="report-mind-rec-reason">{contentRec.reason}</span>
            </Link>
          )}
        </section>
      )}
      {!todayCondition?.mindCheckCompleted && (
        <section className="card report-mind-today report-mind-today--soft">
          <p className="report-mind-today-text">
            마음 기록을 남기면 오늘 측정과 함께 부드러운 해석을 드려요. 원하실 때만 홈에서 기록해 보세요.
          </p>
          <Link to="/mind" className="btn btn--primary btn--small report-mind-today-link">기록하러 가기</Link>
        </section>
      )}

      <section className="card report-radar-card">
        <h2 className="card-title">3대 핵심 지표</h2>
        <ResponsiveContainer width="100%" height={220}>
          <RadarChart data={radarData}>
            <PolarGrid />
            <PolarAngleAxis dataKey="area" tick={{ fontSize: 13 }} />
            <PolarRadiusAxis domain={[0, 100]} tick={false} />
            <Radar dataKey="score" stroke="var(--color-primary)" fill="var(--color-primary)" fillOpacity={0.25} />
          </RadarChart>
        </ResponsiveContainer>
        <div className="report-metric-pills">
          <span className="pill pill--memory">기억력 {metrics.memory}</span>
          <span className="pill pill--focus">집중력 {metrics.focus}</span>
          <span className="pill pill--speed">속도 {metrics.speed}</span>
        </div>
      </section>

      <section className="card">
        <h3 className="card-title">오늘 상태 총평</h3>
        <p className="report-summary">{statusText}</p>
      </section>

      {/* 날씨 영향 */}
      {weather && (
        <section className="card report-weather-card">
          <h3 className="card-title">{weatherInsight.icon} 날씨 영향</h3>
          <div className="report-weather-row">
            <span className="report-weather-temp">{weather.temperature}°C</span>
            <span className="report-weather-meta">습도 {weather.humidity}% · PM2.5 {weather.pm25}</span>
          </div>
          <p className="report-weather-msg">{weatherInsight.message}</p>
        </section>
      )}

      {todayResults.length > 0 && (
        <section className="card">
          <h3 className="card-title">오늘 측정 기록</h3>
          <div className="report-records">
            {todayResults.map((r, i) => (
              <div key={i} className="report-record">
                <span className="report-record-type">{r.type}</span>
                <span className="report-record-score">{r.score}점</span>
              </div>
            ))}
          </div>
        </section>
      )}
    </>
  );
}

// ===== Weekly Tab =====
function WeeklyTab({ checkIns, metrics, conditions, testResults, gameResults, getResultsByDateRange }: {
  checkIns: { date: string; sleep: number; focus: number; fatigue: number; mood: number }[];
  metrics: { memory: number; focus: number; speed: number };
  conditions: DailyCondition[];
  testResults: { date: string; score: number; category: string }[];
  gameResults: { date: string }[];
  getResultsByDateRange: (dates: string[]) => { date: string; score: number; category: string }[];
}) {
  const last7 = getLast7Days();
  const weekResults = getResultsByDateRange(last7);
  const mindLines = useMemo(() => {
    const d = getLast7Days();
    return buildMindCorrelationLines(d, conditions, testResults, gameResults);
  }, [conditions, testResults, gameResults]);

  const trendData = last7.map(d => {
    const dayResults = weekResults.filter(r => r.date === d);
    const dayCheckIn = checkIns.find(c => c.date === d);
    const testAvg = dayResults.length > 0 ? Math.round(dayResults.reduce((s, r) => s + r.score, 0) / dayResults.length) : null;
    const checkAvg = dayCheckIn ? Math.round(((dayCheckIn.sleep + dayCheckIn.focus + (6 - dayCheckIn.fatigue) + dayCheckIn.mood) / 4) * 20) : null;
    return { date: formatShort(d), 테스트: testAvg, 체크인: checkAvg };
  });

  const bestDay = trendData.reduce((best, d) => {
    const score = d.테스트 ?? 0;
    return score > (best.테스트 ?? 0) ? d : best;
  }, trendData[0]);

  return (
    <>
      <section className="card">
        <h3 className="card-title">7일 추이</h3>
        <ResponsiveContainer width="100%" height={220}>
          <AreaChart data={trendData}>
            <XAxis dataKey="date" tick={{ fontSize: 11 }} />
            <YAxis domain={[0, 100]} tick={{ fontSize: 11 }} />
            <Tooltip />
            <Area type="monotone" dataKey="테스트" stroke="var(--color-primary)" fill="var(--color-primary)" fillOpacity={0.2} connectNulls />
            <Area type="monotone" dataKey="체크인" stroke="var(--color-accent)" fill="var(--color-accent)" fillOpacity={0.15} connectNulls />
          </AreaChart>
        </ResponsiveContainer>
      </section>

      <section className="card">
        <h3 className="card-title">주간 요약</h3>
        <div className="report-weekly-summary">
          <div className="report-summary-row"><span>기억력 평균</span><strong>{metrics.memory}점</strong></div>
          <div className="report-summary-row"><span>집중력 평균</span><strong>{metrics.focus}점</strong></div>
          <div className="report-summary-row"><span>반응속도 평균</span><strong>{metrics.speed}점</strong></div>
          {bestDay && bestDay.테스트 !== null && <div className="report-summary-row"><span>가장 좋은 날</span><strong>{bestDay.date}</strong></div>}
        </div>
      </section>

      <section className="card report-mind-card">
        <h3 className="card-title">💚 마음 컨디션과 측정·훈련</h3>
        <p className="report-mind-disclaimer">감정 기록 기반 참고 해석이며, 의학적 진단이 아닙니다.</p>
        <ul className="report-mind-list">
          {mindLines.map((line, i) => (
            <li key={i}>{line}</li>
          ))}
        </ul>
      </section>
    </>
  );
}

// ===== Monthly Tab =====
function MonthlyTab({ results, getResultsByDateRange }: {
  results: { date: string; score: number; category: string }[];
  getResultsByDateRange: (dates: string[]) => { date: string; score: number; category: string }[];
}) {
  const last14 = getLast14Days();
  const recent = getResultsByDateRange(last14);

  const calcCatAvg = (cat: string) => {
    const f = recent.filter(r => r.category === cat);
    return f.length > 0 ? Math.round(f.reduce((s, r) => s + r.score, 0) / f.length) : 0;
  };

  const first7 = last14.slice(0, 7);
  const second7 = last14.slice(7);

  const calcTrend = (cat: string) => {
    const a = results.filter(r => first7.includes(r.date) && r.category === cat);
    const b = results.filter(r => second7.includes(r.date) && r.category === cat);
    const avgA = a.length > 0 ? a.reduce((s, r) => s + r.score, 0) / a.length : 0;
    const avgB = b.length > 0 ? b.reduce((s, r) => s + r.score, 0) / b.length : 0;
    return avgB - avgA;
  };

  const areas = [
    { label: '기억력', cat: 'memory', icon: '🧠' },
    { label: '집중력', cat: 'focus', icon: '🎯' },
    { label: '반응속도', cat: 'speed', icon: '⚡' },
  ];

  return (
    <>
      <section className="card">
        <h3 className="card-title">영역별 평균</h3>
        {areas.map(a => {
          const avg = calcCatAvg(a.cat);
          const trend = calcTrend(a.cat);
          return (
            <div key={a.cat} className="report-monthly-row">
              <span className="report-monthly-icon">{a.icon}</span>
              <span className="report-monthly-label">{a.label}</span>
              <span className="report-monthly-score">{avg}점</span>
              <span className={`report-monthly-trend ${trend > 0 ? 'up' : trend < 0 ? 'down' : ''}`}>
                {trend > 0 ? `▲${Math.round(trend)}` : trend < 0 ? `▼${Math.abs(Math.round(trend))}` : '-'}
              </span>
            </div>
          );
        })}
      </section>

      <section className="card">
        <h3 className="card-title">추천</h3>
        <ul className="report-recommend-list">
          {calcCatAvg('memory') < 50 && <li>기억력 훈련을 더 자주 시도해보세요</li>}
          {calcCatAvg('focus') < 50 && <li>집중력 훈련이 도움이 될 수 있어요</li>}
          {calcCatAvg('speed') < 50 && <li>반응속도 훈련을 추천합니다</li>}
          {calcCatAvg('memory') >= 70 && calcCatAvg('focus') >= 70 && <li>전반적으로 좋은 상태를 유지하고 있어요!</li>}
        </ul>
      </section>
    </>
  );
}

interface InsightItem {
  text: string;
  isWeather: boolean;
}

// ===== Insight Tab =====
function InsightTab({ metrics, conditions, checkIns, weather, results, detailUnlocked, onAdReward }: {
  metrics: { memory: number; focus: number; speed: number };
  conditions: DailyCondition[];
  checkIns: { date: string; sleep: number; focus: number; fatigue: number }[];
  weather: WeatherData | null;
  results: { date: string; score: number; category: string }[];
  detailUnlocked: boolean;
  onAdReward: () => void;
}) {
  const weatherCorrelations = useMemo(() => {
    const weatherHistory = weather ? [weather] : [];
    return analyzeWeatherCorrelation(weatherHistory, results);
  }, [weather, results]);

  const baseInsights = generateInsights(metrics, conditions, checkIns, weather);
  const correlationItems: InsightItem[] = weatherCorrelations.map(text => ({ text, isWeather: true }));
  const insights = [...correlationItems, ...baseInsights];

  return (
    <>
      <section className="card">
        <h3 className="card-title">🔍 AI 인사이트</h3>
        <div className="report-insights">
          {insights.slice(0, detailUnlocked ? insights.length : 2).map((ins, i) => (
            <div key={i} className={`report-insight-item ${ins.isWeather ? 'report-insight-item--weather' : ''}`}>
              <span className="report-insight-dot" />
              <p>{ins.text}</p>
            </div>
          ))}
        </div>

        {!detailUnlocked && insights.length > 2 && (
          <div className="report-lock-overlay">
            <p>🔒 상세 분석 {insights.length - 2}개가 잠겨있습니다</p>
            <button className="btn btn--accent" onClick={onAdReward}>
              광고 보고 잠금 해제
            </button>
          </div>
        )}
      </section>

      {/* 날씨 상관 분석 */}
      {weatherCorrelations.length > 0 && (
        <section className="card">
          <h3 className="card-title">🌤️ 날씨 × 인지 패턴</h3>
          <div className="report-insights">
            {weatherCorrelations.map((text, i) => (
              <div key={i} className="report-insight-item report-insight-item--weather">
                <span className="report-insight-dot" style={{ background: 'var(--color-warning)' }} />
                <p>{text}</p>
              </div>
            ))}
          </div>
        </section>
      )}
    </>
  );
}

function generateInsights(
  metrics: { memory: number; focus: number; speed: number },
  conditions: DailyCondition[],
  checkIns: { date: string; sleep: number; focus: number; fatigue: number }[],
  weather: WeatherData | null,
): InsightItem[] {
  const tips: InsightItem[] = [];

  const todayC = conditions.find(c => c.date === getToday());
  if (todayC && metrics.focus > 0 && metrics.focus < 62 && todayC.stressLevel >= 4) {
    tips.push({
      text: '오늘 집중 점수가 낮게 보이며, 기록하신 스트레스도 높은 편입니다. 점수는 그대로 두고 컨디션 해석으로 참고해 보세요.',
      isWeather: false,
    });
  }
  if (todayC && todayC.anxietyLevel >= 4 && metrics.speed > 0 && metrics.speed < 58) {
    tips.push({
      text: '불안이 높게 느껴지는 날에는 반응속도가 흔들릴 수 있어요. 호흡 훈련 후 짧게 다시 측정해 보세요.',
      isWeather: false,
    });
  }
  if (todayC && todayC.motivationLevel <= 2) {
    tips.push({
      text: '의욕이 낮게 기록된 날에는 긴 훈련보다 호흡·짧은 회복 모드가 잘 맞을 수 있어요.',
      isWeather: false,
    });
  }

  // 날씨 기반 인사이트
  if (weather) {
    const { temperature, weatherType, pm25, humidity } = weather;
    if ((weatherType === 'cloudy' || weatherType === 'overcast' || weatherType === 'rain') && metrics.focus < 60 && metrics.focus > 0) {
      tips.push({ text: '흐린 날씨 영향으로 집중력이 다소 흔들릴 수 있습니다. 짧은 단위로 나눠 진행해보세요.', isWeather: true });
    }
    if (temperature >= 28 && metrics.speed < 50 && metrics.speed > 0) {
      tips.push({ text: '높은 기온이 반응속도에 영향을 줄 수 있습니다. 시원한 환경에서 훈련하세요.', isWeather: true });
    }
    if (pm25 >= 50) {
      tips.push({ text: `미세먼지(PM2.5 ${pm25})가 높아 외출이 줄고 활동량이 저하될 수 있습니다. 실내 훈련을 추천합니다.`, isWeather: true });
    }
    if (weatherType === 'sunny' && temperature >= 15 && temperature <= 25 && humidity <= 65) {
      tips.push({ text: '오늘은 뇌 활동에 이상적인 날씨입니다. 중요한 학습이나 측정을 진행하기 좋아요!', isWeather: true });
    }
  }

  // 생활 패턴 인사이트
  if (conditions.length >= 3) {
    const recentCond = conditions.slice(-7);
    const avgSleep = recentCond.reduce((s, c) => s + c.sleepHours, 0) / recentCond.length;
    const avgStress = recentCond.reduce((s, c) => s + c.stressLevel, 0) / recentCond.length;
    const exerciseDays = recentCond.filter(c => c.exerciseYn).length;

    if (avgSleep < 6.5) tips.push({ text: '수면이 부족한 날 집중력과 반응속도가 낮아지는 경향이 있습니다. 7시간 이상 수면을 추천합니다.', isWeather: false });
    if (avgStress >= 3.5) tips.push({ text: '최근 스트레스 수준이 높습니다. 호흡 훈련이나 가벼운 산책을 시도해보세요.', isWeather: false });
    if (exerciseDays >= 3) tips.push({ text: '운동을 꾸준히 하고 있어요! 운동하는 날 인지 점수가 더 높은 편입니다.', isWeather: false });
    if (exerciseDays < 2) tips.push({ text: '운동 빈도가 낮습니다. 가벼운 걷기만으로도 뇌 건강에 도움이 됩니다.', isWeather: false });
  }

  if (checkIns.length >= 3) {
    const recentCI = checkIns.slice(-7);
    const avgFatigue = recentCI.reduce((s, c) => s + c.fatigue, 0) / recentCI.length;
    if (avgFatigue >= 4) tips.push({ text: '최근 피로도가 높습니다. 충분한 휴식과 수면이 필요합니다.', isWeather: false });
  }

  // 메트릭 인사이트
  if (metrics.memory >= 70 && metrics.focus >= 70) tips.push({ text: '기억력과 집중력이 모두 안정적입니다. 현재 루틴을 유지하세요.', isWeather: false });
  if (metrics.speed < 50 && metrics.speed > 0) tips.push({ text: '반응속도가 다소 낮습니다. 반응속도 탭 훈련을 추천합니다.', isWeather: false });
  if (metrics.focus > 0 && metrics.memory > 0 && Math.abs(metrics.focus - metrics.memory) > 25) {
    tips.push({
      text: metrics.focus > metrics.memory
        ? '집중력 대비 기억력이 낮습니다. 기억력 훈련에 더 집중해보세요.'
        : '기억력 대비 집중력이 낮습니다. 집중력 훈련을 더 시도해보세요.',
      isWeather: false,
    });
  }

  if (tips.length === 0) tips.push({ text: '꾸준히 측정하면 더 정확한 인사이트를 제공할 수 있어요.', isWeather: false });
  return tips;
}
