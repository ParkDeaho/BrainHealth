import { useState, useEffect, useCallback, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTestResults } from '../../store/useStore';

type Phase = 'ready' | 'playing' | 'done';

interface StroopItem {
  word: string;
  color: string;
  correctAnswer: string;
}

const COLORS: { name: string; hex: string }[] = [
  { name: '빨강', hex: '#EF4444' },
  { name: '파랑', hex: '#3B82F6' },
  { name: '초록', hex: '#22C55E' },
  { name: '노랑', hex: '#EAB308' },
];

const TOTAL_ITEMS = 15;
const TIME_LIMIT = 45;

function generateItem(): StroopItem {
  const wordColor = COLORS[Math.floor(Math.random() * COLORS.length)];
  let displayColor = COLORS[Math.floor(Math.random() * COLORS.length)];
  while (displayColor.name === wordColor.name && Math.random() < 0.7) {
    displayColor = COLORS[Math.floor(Math.random() * COLORS.length)];
  }
  return {
    word: wordColor.name,
    color: displayColor.hex,
    correctAnswer: displayColor.name,
  };
}

export default function StroopTest() {
  const navigate = useNavigate();
  const { addResult } = useTestResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [current, setCurrent] = useState<StroopItem | null>(null);
  const [round, setRound] = useState(0);
  const [correct, setCorrect] = useState(0);
  const [wrong, setWrong] = useState(0);
  const [timeLeft, setTimeLeft] = useState(TIME_LIMIT);
  const [reactionTimes, setReactionTimes] = useState<number[]>([]);
  const roundStart = useRef(Date.now());

  const nextItem = useCallback(() => {
    setCurrent(generateItem());
    roundStart.current = Date.now();
  }, []);

  const startGame = () => {
    setPhase('playing');
    setRound(0);
    setCorrect(0);
    setWrong(0);
    setTimeLeft(TIME_LIMIT);
    setReactionTimes([]);
    nextItem();
  };

  useEffect(() => {
    if (phase !== 'playing') return;
    const timer = setInterval(() => {
      setTimeLeft(prev => {
        if (prev <= 1) {
          clearInterval(timer);
          setPhase('done');
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, [phase]);

  const handleAnswer = (colorName: string) => {
    if (!current || phase !== 'playing') return;
    const rt = Date.now() - roundStart.current;
    setReactionTimes(prev => [...prev, rt]);

    if (colorName === current.correctAnswer) {
      setCorrect(c => c + 1);
    } else {
      setWrong(w => w + 1);
    }

    const nextRound = round + 1;
    setRound(nextRound);

    if (nextRound >= TOTAL_ITEMS) {
      setPhase('done');
    } else {
      nextItem();
    }
  };

  useEffect(() => {
    if (phase === 'done' && round > 0) {
      const accuracy = Math.round((correct / round) * 100);
      const avgRt = reactionTimes.length > 0
        ? Math.round(reactionTimes.reduce((s, t) => s + t, 0) / reactionTimes.length)
        : 0;
      const score = Math.round(accuracy * 0.6 + Math.max(0, 100 - avgRt / 10) * 0.4);
      addResult({
        type: 'stroop',
        score: Math.min(score, 100),
        category: 'focus',
        metrics: { accuracy, avgReactionMs: avgRt, correct, wrong, total: round },
      });
    }
  }, [phase]);

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🎨</span>
          <h1>스트룹 테스트</h1>
          <p>
            글자의 <strong>의미가 아니라</strong>,<br />
            글자의 <strong>색깔</strong>을 선택하세요!
          </p>
          <div className="stroop-example">
            <span style={{ color: '#3B82F6', fontSize: 28, fontWeight: 800 }}>빨강</span>
            <span style={{ fontSize: 14, color: 'var(--color-muted)' }}>→ 정답: 파랑 (글자 색)</span>
          </div>
          <div className="game-ready-rules">
            <div className="game-rule"><span>🎯</span><span>글자의 "색깔"을 보세요</span></div>
            <div className="game-rule"><span>⏱</span><span>{TIME_LIMIT}초 / {TOTAL_ITEMS}문제</span></div>
            <div className="game-rule"><span>🧠</span><span>집중력 + 충동 억제 측정</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startGame}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    const accuracy = round > 0 ? Math.round((correct / round) * 100) : 0;
    const avgRt = reactionTimes.length > 0
      ? Math.round(reactionTimes.reduce((s, t) => s + t, 0) / reactionTimes.length)
      : 0;
    const score = Math.round(accuracy * 0.6 + Math.max(0, 100 - avgRt / 10) * 0.4);

    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">{score >= 80 ? '🌟' : score >= 60 ? '👏' : '💪'}</span>
          <h2>테스트 완료!</h2>
          <div className="game-over-stats">
            <div className="game-over-stat">
              <span className="game-over-stat-value">{Math.min(score, 100)}</span>
              <span className="game-over-stat-label">점수</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{accuracy}%</span>
              <span className="game-over-stat-label">정확도</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{avgRt}ms</span>
              <span className="game-over-stat-label">평균 반응</span>
            </div>
          </div>
          <div className="game-over-actions">
            <button className="btn btn--primary" onClick={startGame}>다시 하기</button>
            <button className="btn btn--ghost" onClick={() => navigate('/tests')}>돌아가기</button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="page page--game">
      <header className="game-header">
        <span className="game-level">{round + 1}/{TOTAL_ITEMS}</span>
        <span className="game-score">⏱ {timeLeft}초</span>
      </header>

      <div className="stroop-play">
        <p className="test-hint">이 글자의 <strong>색깔</strong>은?</p>
        {current && (
          <div className="stroop-word" style={{ color: current.color }}>
            {current.word}
          </div>
        )}
        <div className="stroop-buttons">
          {COLORS.map(c => (
            <button
              key={c.name}
              className="stroop-btn"
              style={{ background: c.hex }}
              onClick={() => handleAnswer(c.name)}
            >
              {c.name}
            </button>
          ))}
        </div>
        <div className="stroop-score-bar">
          <span>✅ {correct}</span>
          <span>❌ {wrong}</span>
        </div>
      </div>
    </div>
  );
}
