import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import ScoreCircle from '../components/ScoreCircle';
import WeatherCard from '../components/WeatherCard';
import BrainFortuneCard from '../components/BrainFortune';
import {
  useCheckIns,
  useTestResults,
  useGameResults,
  useRoutines,
  useQuestionnaires,
  useCoreMetrics,
  useProfile,
  useDailyCondition,
} from '../store/useStore';
import { useWeather, analyzeWeatherImpact, generateBrainFortune } from '../store/useWeather';
import { formatDisplay, getToday } from '../utils/date';
import { moodShortLabel } from '../services/mindInsightEngine';

function getGreeting(mode?: string): string {
  const h = new Date().getHours();
  if (h < 12) return '좋은 아침이에요';
  if (h < 18) return mode === 'student' ? '오늘 집중 잘 되나요?' : '좋은 오후에요';
  return '수고한 하루에요';
}

export default function Home() {
  const navigate = useNavigate();
  const { getTodayCheckIn } = useCheckIns();
  const { getTodayResults } = useTestResults();
  const { getTodayGameResults } = useGameResults();
  const { getTodayRoutine } = useRoutines();
  const { getTodayByCategory } = useQuestionnaires();
  const { profile, updateStreak } = useProfile();
  const { calculate } = useCoreMetrics();
  const { getTodayCondition } = useDailyCondition();
  const { weather } = useWeather();

  useEffect(() => { updateStreak(); }, [updateStreak]);

  const checkIn = getTodayCheckIn();
  const todayTests = getTodayResults();
  const todayGames = getTodayGameResults();
  const todayRoutine = getTodayRoutine();
  const todayQ = getTodayByCategory(profile?.mode === 'senior' ? 'memory' : 'focus');
  const todayCondition = getTodayCondition();
  const mindMoodLabel = todayCondition?.mindCheckCompleted
    ? moodShortLabel(todayCondition.moodLevel)
    : null;
  const metrics = calculate();
  const completedRoutines = todayRoutine.items.filter(i => i.completed).length;
  const overallScore = Math.round((metrics.memory + metrics.focus + metrics.speed) / 3) || 0;
  const allStepsDone = !!todayQ && todayTests.length > 0 && todayGames.length > 0;

  const weatherInsight = analyzeWeatherImpact(weather, metrics, todayCondition, checkIn);
  const fortune = generateBrainFortune(weather, metrics, todayCondition, profile?.mode ?? 'general');

  const flowSteps = [
    { label: '문진', done: !!todayQ, path: '/questionnaire', icon: '📋' },
    { label: '테스트', done: todayTests.length > 0, path: '/tests', icon: '🧪' },
    { label: '훈련', done: todayGames.length > 0, path: '/training', icon: '🎮' },
    { label: '리포트', done: allStepsDone, path: '/report', icon: '📊' },
  ];

  return (
    <div className="page page--home">
      <header className="home-header">
        <div className="home-header-top">
          <div>
            <p className="home-greeting">{getGreeting(profile?.mode)} 👋</p>
            <h1 className="home-date">{formatDisplay(getToday())}</h1>
          </div>
          {(profile?.streakDays ?? 0) > 0 && (
            <div className="home-streak">
              <span className="home-streak-num">{profile?.streakDays}</span>
              <span className="home-streak-label">일 연속</span>
            </div>
          )}
        </div>
      </header>

      {/* 날씨 + 뇌 영향 카드 */}
      <WeatherCard weather={weather} insight={weatherInsight} />

      {/* 마음 컨디션 기록 */}
      <section
        className={`card home-mind-card ${todayCondition?.mindCheckCompleted ? 'home-mind-card--done' : ''}`}
        onClick={() => navigate('/mind')}
        role="button"
        tabIndex={0}
        onKeyDown={e => { if (e.key === 'Enter' || e.key === ' ') navigate('/mind'); }}
      >
        <div className="home-mind-text">
          <h3 className="home-mind-title">
            {mindMoodLabel
              ? (
                <>
                  오늘의 마음 상태 <span className="home-mind-mood-emoji">{mindMoodLabel.emoji}</span> {mindMoodLabel.text}
                </>
              )
              : '오늘의 마음 상태를 기록해보세요'}
          </h3>
          <p className="home-mind-sub">
            {todayCondition?.mindCheckCompleted
              ? '탭하면 다시 기록할 수 있어요'
              : '아직 기록하지 않았어요'}
          </p>
        </div>
        <span className="home-mind-cta">{todayCondition?.mindCheckCompleted ? '다시 기록하기' : '10초 기록 시작'}</span>
      </section>

      {/* 두뇌 컨디션 */}
      <section className="card home-metrics-card">
        <h2 className="card-title">두뇌 컨디션</h2>
        <div className="home-metrics">
          <div className="home-metric-main">
            <ScoreCircle
              score={overallScore}
              size={110}
              label="종합"
              color={overallScore >= 70 ? 'var(--color-success)' : overallScore >= 40 ? 'var(--color-primary)' : 'var(--color-warning)'}
            />
          </div>
          <div className="home-metric-bars">
            {[
              { label: '기억력', value: metrics.memory, color: '#6C63FF' },
              { label: '집중력', value: metrics.focus, color: '#00C9A7' },
              { label: '반응속도', value: metrics.speed, color: '#FFB020' },
            ].map(m => (
              <div key={m.label} className="home-metric-row">
                <span className="home-metric-label">{m.label}</span>
                <div className="home-bar-track">
                  <div className="home-bar-fill" style={{ width: `${m.value}%`, background: m.color }} />
                </div>
                <span className="home-metric-value">{m.value}</span>
              </div>
            ))}
          </div>
        </div>
        {overallScore === 0 && <p className="home-metrics-empty">테스트를 완료하면 점수가 나타나요</p>}
      </section>

      {/* 뇌 컨디션 운세 */}
      <BrainFortuneCard fortune={fortune} />

      {/* 오늘의 코스 */}
      <section className="card home-flow-card">
        <h3 className="card-title">오늘의 코스</h3>
        <div className="home-flow">
          {flowSteps.map((s, i) => (
            <button key={s.label} className={`home-flow-step ${s.done ? 'home-flow-step--done' : ''}`} onClick={() => navigate(s.path)}>
              <span className="home-flow-icon">{s.icon}</span>
              <span className="home-flow-label">{s.label}</span>
              {s.done && <span className="home-flow-check">✓</span>}
              {i < flowSteps.length - 1 && <span className="home-flow-arrow">→</span>}
            </button>
          ))}
        </div>
      </section>

      {/* 빠른 시작 */}
      <section className="card home-quick-card">
        <h3 className="card-title">빠른 시작</h3>
        <div className="home-quick-buttons">
          <button className="home-quick-btn" onClick={() => navigate('/tests/stroop')}>
            <span>🎯</span><span>1분 집중 테스트</span>
          </button>
          <button className="home-quick-btn" onClick={() => navigate('/tests/word-memory')}>
            <span>📝</span><span>기억력 체크</span>
          </button>
          <button className="home-quick-btn" onClick={() => navigate('/report')}>
            <span>📊</span><span>리포트 보기</span>
          </button>
        </div>
      </section>

      {/* 미니 카드 */}
      <div className="home-grid">
        <section className="card home-mini-card" onClick={() => navigate(checkIn ? '/questionnaire/lifestyle' : '/checkin')}>
          <span className="home-mini-icon">✅</span>
          <div>
            <p className="home-mini-title">상태 체크</p>
            <p className="home-mini-sub">{checkIn ? '완료' : '미완료'}</p>
          </div>
        </section>
        <section className="card home-mini-card" onClick={() => navigate('/routine')}>
          <span className="home-mini-icon">🔄</span>
          <div>
            <p className="home-mini-title">루틴</p>
            <p className="home-mini-sub">{completedRoutines}/{todayRoutine.items.length}</p>
          </div>
        </section>
      </div>

      {/* 광고 배너 */}
      <section className="home-ad-banner" onClick={() => navigate('/report')}>
        <span>📊</span>
        <p>광고 보고 <strong>상세 분석</strong> 열기</p>
      </section>
    </div>
  );
}
