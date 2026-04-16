import { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTestResults } from '../../store/useStore';

type Phase = 'ready' | 'highlight' | 'moving' | 'select' | 'feedback' | 'done';

interface Ball {
  id: number;
  x: number;
  y: number;
  vx: number;
  vy: number;
  isTarget: boolean;
}

const BALL_COUNT = 6;
const TARGET_COUNT = 2;
const TOTAL_ROUNDS = 5;
const MOVE_DURATION = 4000;
const AREA = { width: 300, height: 400 };
const BALL_R = 18;

function initBalls(): Ball[] {
  const balls: Ball[] = [];
  for (let i = 0; i < BALL_COUNT; i++) {
    balls.push({
      id: i,
      x: 40 + Math.random() * (AREA.width - 80),
      y: 40 + Math.random() * (AREA.height - 80),
      vx: (Math.random() - 0.5) * 2.5,
      vy: (Math.random() - 0.5) * 2.5,
      isTarget: i < TARGET_COUNT,
    });
  }
  return balls;
}

export default function VisualTracking() {
  const navigate = useNavigate();
  const { addResult } = useTestResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [round, setRound] = useState(0);
  const [balls, setBalls] = useState<Ball[]>([]);
  const [selected, setSelected] = useState<Set<number>>(new Set());
  const [correctCount, setCorrectCount] = useState(0);
  const [totalCorrect, setTotalCorrect] = useState(0);
  const animRef = useRef<number>(0);

  const startRound = useCallback(() => {
    const newBalls = initBalls();
    setBalls(newBalls);
    setSelected(new Set());
    setCorrectCount(0);
    setPhase('highlight');

    setTimeout(() => {
      setPhase('moving');
      const startTime = Date.now();

      const animate = () => {
        if (Date.now() - startTime > MOVE_DURATION) {
          setPhase('select');
          return;
        }
        setBalls(prev => prev.map(b => {
          let nx = b.x + b.vx;
          let ny = b.y + b.vy;
          let nvx = b.vx;
          let nvy = b.vy;
          if (nx < BALL_R || nx > AREA.width - BALL_R) nvx = -nvx;
          if (ny < BALL_R || ny > AREA.height - BALL_R) nvy = -nvy;
          return { ...b, x: Math.max(BALL_R, Math.min(AREA.width - BALL_R, nx)), y: Math.max(BALL_R, Math.min(AREA.height - BALL_R, ny)), vx: nvx, vy: nvy };
        }));
        animRef.current = requestAnimationFrame(animate);
      };
      animRef.current = requestAnimationFrame(animate);
    }, 2000);
  }, []);

  useEffect(() => {
    return () => cancelAnimationFrame(animRef.current);
  }, []);

  const handleSelect = (id: number) => {
    if (phase !== 'select') return;
    setSelected(prev => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else if (next.size < TARGET_COUNT) next.add(id);
      return next;
    });
  };

  const handleConfirm = () => {
    const correct = [...selected].filter(id => balls.find(b => b.id === id)?.isTarget).length;
    setCorrectCount(correct);
    setTotalCorrect(prev => prev + correct);
    setPhase('feedback');
  };

  const handleNext = () => {
    const nextRound = round + 1;
    setRound(nextRound);
    if (nextRound >= TOTAL_ROUNDS) {
      const score = Math.round((totalCorrect / (TOTAL_ROUNDS * TARGET_COUNT)) * 100);
      addResult({
        type: 'visual-tracking',
        score,
        category: 'focus',
        metrics: { totalCorrect, totalTargets: TOTAL_ROUNDS * TARGET_COUNT, rounds: TOTAL_ROUNDS },
      });
      setPhase('done');
    } else {
      startRound();
    }
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">👁️</span>
          <h1>시각 추적 테스트</h1>
          <p>강조된 공을 기억한 뒤,<br />공들이 섞인 후 원래 공을 찾으세요!</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>🔴</span><span>빨간 공 {TARGET_COUNT}개를 기억</span></div>
            <div className="game-rule"><span>🔀</span><span>공들이 움직임</span></div>
            <div className="game-rule"><span>🎯</span><span>기억한 공을 선택</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={() => { setRound(0); setTotalCorrect(0); startRound(); }}>
            시작하기
          </button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    const score = Math.round((totalCorrect / (TOTAL_ROUNDS * TARGET_COUNT)) * 100);
    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">{score >= 80 ? '🌟' : score >= 60 ? '👏' : '💪'}</span>
          <h2>테스트 완료!</h2>
          <div className="game-over-stats">
            <div className="game-over-stat">
              <span className="game-over-stat-value">{score}</span>
              <span className="game-over-stat-label">점수</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{totalCorrect}/{TOTAL_ROUNDS * TARGET_COUNT}</span>
              <span className="game-over-stat-label">정답</span>
            </div>
          </div>
          <div className="game-over-actions">
            <button className="btn btn--primary" onClick={() => { setRound(0); setTotalCorrect(0); startRound(); }}>다시 하기</button>
            <button className="btn btn--ghost" onClick={() => navigate('/tests')}>돌아가기</button>
          </div>
        </div>
      </div>
    );
  }

  const showTargets = phase === 'highlight' || phase === 'feedback';

  return (
    <div className="page page--game">
      <header className="game-header">
        <span className="game-level">라운드 {round + 1}/{TOTAL_ROUNDS}</span>
        <span className="game-score">
          {phase === 'highlight' && '빨간 공을 기억하세요!'}
          {phase === 'moving' && '공을 눈으로 쫓으세요...'}
          {phase === 'select' && '빨간 공이었던 것을 선택!'}
          {phase === 'feedback' && `${correctCount}/${TARGET_COUNT} 정답!`}
        </span>
      </header>

      <div className="vt-area" style={{ width: AREA.width, height: AREA.height }}>
        {balls.map(ball => (
          <div
            key={ball.id}
            className={`vt-ball ${showTargets && ball.isTarget ? 'vt-ball--target' : ''} ${selected.has(ball.id) ? 'vt-ball--selected' : ''} ${phase === 'feedback' && ball.isTarget ? 'vt-ball--reveal' : ''}`}
            style={{ left: ball.x - BALL_R, top: ball.y - BALL_R, width: BALL_R * 2, height: BALL_R * 2 }}
            onClick={() => handleSelect(ball.id)}
          />
        ))}
      </div>

      {phase === 'select' && (
        <button
          className="btn btn--primary btn--large"
          onClick={handleConfirm}
          disabled={selected.size !== TARGET_COUNT}
          style={{ marginTop: 16 }}
        >
          확인 ({selected.size}/{TARGET_COUNT})
        </button>
      )}

      {phase === 'feedback' && (
        <button className="btn btn--primary" onClick={handleNext} style={{ marginTop: 16 }}>
          {round + 1 < TOTAL_ROUNDS ? '다음 라운드' : '결과 보기'}
        </button>
      )}
    </div>
  );
}
