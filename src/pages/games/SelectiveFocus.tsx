import { useState, useEffect, useCallback, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGameResults } from '../../store/useStore';

type Phase = 'ready' | 'playing' | 'done';

interface FocusItem {
  id: number;
  emoji: string;
  isTarget: boolean;
  x: number;
  y: number;
  tapped: boolean;
}

const TARGET_EMOJI = '⭐';
const DISTRACTOR_EMOJIS = ['🔵', '🔴', '🟢', '🟡', '🟣', '💎', '🔶'];
const TOTAL_ROUNDS = 5;
const ITEMS_PER_ROUND = 12;
const TARGETS_PER_ROUND = 3;
const ROUND_TIME = 5;

function generateItems(): FocusItem[] {
  const items: FocusItem[] = [];
  for (let i = 0; i < TARGETS_PER_ROUND; i++) {
    items.push({
      id: i,
      emoji: TARGET_EMOJI,
      isTarget: true,
      x: 10 + Math.random() * 75,
      y: 10 + Math.random() * 75,
      tapped: false,
    });
  }
  for (let i = TARGETS_PER_ROUND; i < ITEMS_PER_ROUND; i++) {
    items.push({
      id: i,
      emoji: DISTRACTOR_EMOJIS[Math.floor(Math.random() * DISTRACTOR_EMOJIS.length)],
      isTarget: false,
      x: 10 + Math.random() * 75,
      y: 10 + Math.random() * 75,
      tapped: false,
    });
  }
  return items.sort(() => Math.random() - 0.5);
}

export default function SelectiveFocus() {
  const navigate = useNavigate();
  const { addGameResult } = useGameResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [round, setRound] = useState(0);
  const [items, setItems] = useState<FocusItem[]>([]);
  const [timeLeft, setTimeLeft] = useState(ROUND_TIME);
  const [totalHits, setTotalHits] = useState(0);
  const [, setTotalMisses] = useState(0);
  const [totalFalse, setTotalFalse] = useState(0);
  const timerRef = useRef<ReturnType<typeof setInterval>>(undefined);

  const startRound = useCallback(() => {
    setItems(generateItems());
    setTimeLeft(ROUND_TIME);
    timerRef.current = setInterval(() => {
      setTimeLeft(prev => {
        if (prev <= 1) {
          clearInterval(timerRef.current);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);
  }, []);

  useEffect(() => {
    return () => clearInterval(timerRef.current);
  }, []);

  useEffect(() => {
    if (timeLeft === 0 && phase === 'playing') {
      const missed = items.filter(i => i.isTarget && !i.tapped).length;
      setTotalMisses(m => m + missed);

      const nextRound = round + 1;
      if (nextRound >= TOTAL_ROUNDS) {
        const totalTargets = TOTAL_ROUNDS * TARGETS_PER_ROUND;
        const score = Math.round(
          Math.max(0, (totalHits / totalTargets) * 80 - (totalFalse * 5) + 20)
        );
        addGameResult({ type: 'selective-focus', score: Math.min(score, 100) });
        setPhase('done');
      } else {
        setRound(nextRound);
        startRound();
      }
    }
  }, [timeLeft]);

  const startGame = () => {
    setPhase('playing');
    setRound(0);
    setTotalHits(0);
    setTotalMisses(0);
    setTotalFalse(0);
    startRound();
  };

  const handleTap = (item: FocusItem) => {
    if (item.tapped || phase !== 'playing') return;
    setItems(prev => prev.map(i => i.id === item.id ? { ...i, tapped: true } : i));
    if (item.isTarget) {
      setTotalHits(h => h + 1);
    } else {
      setTotalFalse(f => f + 1);
    }
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">⭐</span>
          <h1>선택 집중 훈련</h1>
          <p>화면에서 <strong>⭐ 별</strong>만 빠르게 찾아 터치하세요!<br />다른 것은 무시!</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>⭐</span><span>별만 터치</span></div>
            <div className="game-rule"><span>⏱</span><span>라운드당 {ROUND_TIME}초</span></div>
            <div className="game-rule"><span>🔁</span><span>총 {TOTAL_ROUNDS}라운드</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startGame}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    const totalTargets = TOTAL_ROUNDS * TARGETS_PER_ROUND;
    const accuracy = totalTargets > 0 ? Math.round((totalHits / totalTargets) * 100) : 0;
    const score = Math.min(100, Math.round(Math.max(0, (totalHits / totalTargets) * 80 - (totalFalse * 5) + 20)));

    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">{score >= 80 ? '🌟' : score >= 60 ? '👏' : '💪'}</span>
          <h2>훈련 완료!</h2>
          <div className="game-over-stats">
            <div className="game-over-stat">
              <span className="game-over-stat-value">{score}</span>
              <span className="game-over-stat-label">점수</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{accuracy}%</span>
              <span className="game-over-stat-label">탐지율</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{totalFalse}</span>
              <span className="game-over-stat-label">오선택</span>
            </div>
          </div>
          <div className="game-over-actions">
            <button className="btn btn--primary" onClick={startGame}>다시 하기</button>
            <button className="btn btn--ghost" onClick={() => navigate('/training')}>돌아가기</button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="page page--game">
      <header className="game-header">
        <span className="game-level">라운드 {round + 1}/{TOTAL_ROUNDS}</span>
        <span className="game-score">⏱ {timeLeft}초</span>
      </header>

      <p className="sf-hint">⭐ 별만 터치하세요!</p>

      <div className="sf-area">
        {items.map(item => (
          <button
            key={item.id}
            className={`sf-item ${item.tapped ? (item.isTarget ? 'sf-item--hit' : 'sf-item--false') : ''}`}
            style={{ left: `${item.x}%`, top: `${item.y}%` }}
            onClick={() => handleTap(item)}
          >
            {item.emoji}
          </button>
        ))}
      </div>

      <div className="sf-stats">
        <span>⭐ {totalHits}</span>
        <span>❌ {totalFalse}</span>
      </div>
    </div>
  );
}
