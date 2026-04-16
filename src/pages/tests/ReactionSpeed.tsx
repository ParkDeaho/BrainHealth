import { useState, useRef, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTestResults } from '../../store/useStore';

type Phase = 'ready' | 'waiting' | 'go' | 'tooearly' | 'result' | 'done';

const TOTAL_ROUNDS = 5;

export default function ReactionSpeed() {
  const navigate = useNavigate();
  const { addResult } = useTestResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [round, setRound] = useState(0);
  const [times, setTimes] = useState<number[]>([]);
  const [currentTime, setCurrentTime] = useState(0);
  const goTimestamp = useRef(0);
  const timerRef = useRef<ReturnType<typeof setTimeout>>(undefined);

  const startRound = useCallback(() => {
    setPhase('waiting');
    const delay = 1500 + Math.random() * 3000;
    timerRef.current = setTimeout(() => {
      goTimestamp.current = Date.now();
      setPhase('go');
    }, delay);
  }, []);

  const handleTap = () => {
    if (phase === 'waiting') {
      clearTimeout(timerRef.current);
      setPhase('tooearly');
      return;
    }

    if (phase === 'go') {
      const reaction = Date.now() - goTimestamp.current;
      setCurrentTime(reaction);
      setTimes(prev => [...prev, reaction]);
      setRound(r => r + 1);
      setPhase('result');
    }
  };

  const handleNext = () => {
    if (round < TOTAL_ROUNDS) {
      startRound();
    } else {
      const avg = Math.round(times.reduce((s, t) => s + t, 0) / times.length);
      const score = Math.max(0, Math.min(100, Math.round(100 - (avg - 200) / 3)));
      addResult({
        type: 'reaction-speed',
        score,
        category: 'speed',
        metrics: {
          avgMs: avg,
          bestMs: Math.min(...times),
          worstMs: Math.max(...times),
          rounds: TOTAL_ROUNDS,
        },
      });
      setPhase('done');
    }
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">⚡</span>
          <h1>반응 속도 테스트</h1>
          <p>화면이 초록색으로 바뀌면<br />최대한 빠르게 터치하세요!</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>🔴</span><span>빨간 화면 = 대기</span></div>
            <div className="game-rule"><span>🟢</span><span>초록 화면 = 터치!</span></div>
            <div className="game-rule"><span>🔁</span><span>총 {TOTAL_ROUNDS}라운드</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startRound}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    const avg = Math.round(times.reduce((s, t) => s + t, 0) / times.length);
    const best = Math.min(...times);
    const score = Math.max(0, Math.min(100, Math.round(100 - (avg - 200) / 3)));
    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">{avg < 300 ? '⚡' : avg < 400 ? '👍' : '💪'}</span>
          <h2>테스트 완료!</h2>
          <div className="game-over-stats">
            <div className="game-over-stat">
              <span className="game-over-stat-value">{score}</span>
              <span className="game-over-stat-label">점수</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{avg}ms</span>
              <span className="game-over-stat-label">평균</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{best}ms</span>
              <span className="game-over-stat-label">최고</span>
            </div>
          </div>
          <div className="reaction-times">
            {times.map((t, i) => (
              <div key={i} className="reaction-time-row">
                <span>라운드 {i + 1}</span>
                <span className="reaction-time-val">{t}ms</span>
              </div>
            ))}
          </div>
          <div className="game-over-actions">
            <button className="btn btn--primary" onClick={() => {
              setPhase('ready'); setRound(0); setTimes([]);
            }}>다시 하기</button>
            <button className="btn btn--ghost" onClick={() => navigate('/tests')}>돌아가기</button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div
      className={`page page--reaction ${phase === 'waiting' ? 'reaction--waiting' : ''} ${phase === 'go' ? 'reaction--go' : ''} ${phase === 'tooearly' ? 'reaction--early' : ''}`}
      onClick={phase === 'waiting' || phase === 'go' ? handleTap : undefined}
    >
      <div className="reaction-round">라운드 {round + 1} / {TOTAL_ROUNDS}</div>

      {phase === 'waiting' && (
        <div className="reaction-center">
          <span className="reaction-big-text">기다리세요...</span>
        </div>
      )}

      {phase === 'go' && (
        <div className="reaction-center">
          <span className="reaction-big-text">지금 터치!</span>
        </div>
      )}

      {phase === 'tooearly' && (
        <div className="reaction-center">
          <span className="reaction-big-text">너무 빨라요! 😅</span>
          <button className="btn btn--ghost" onClick={startRound} style={{ marginTop: 20 }}>
            다시 시도
          </button>
        </div>
      )}

      {phase === 'result' && (
        <div className="reaction-center">
          <span className="reaction-time">{currentTime}ms</span>
          <p>{currentTime < 300 ? '빠르네요! ⚡' : currentTime < 400 ? '괜찮아요 👍' : '더 빨라질 수 있어요 💪'}</p>
          <button className="btn btn--primary" onClick={handleNext} style={{ marginTop: 20 }}>
            {round < TOTAL_ROUNDS ? '다음 라운드' : '결과 보기'}
          </button>
        </div>
      )}
    </div>
  );
}
