import { useState, useEffect, useCallback, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGameResults } from '../../store/useStore';

type Phase = 'ready' | 'playing' | 'feedback' | 'done';

const SHAPES = ['🔵', '🔴', '🟢', '🟡', '🟣', '🟠'];
const TOTAL_STIMULI = 20;
const MATCH_RATIO = 0.3;
const DISPLAY_MS = 1500;
const GAP_MS = 500;

function generateSequence(n: number): { items: string[]; matches: boolean[] } {
  const items: string[] = [];
  const matches: boolean[] = [];

  for (let i = 0; i < TOTAL_STIMULI; i++) {
    if (i >= n && Math.random() < MATCH_RATIO) {
      items.push(items[i - n]);
      matches.push(true);
    } else {
      let shape = SHAPES[Math.floor(Math.random() * SHAPES.length)];
      if (i >= n) {
        while (shape === items[i - n]) {
          shape = SHAPES[Math.floor(Math.random() * SHAPES.length)];
        }
      }
      items.push(shape);
      matches.push(false);
    }
  }
  return { items, matches };
}

export default function NBack() {
  const navigate = useNavigate();
  const { addGameResult } = useGameResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [nLevel, setNLevel] = useState(2);
  const [currentIndex, setCurrentIndex] = useState(-1);
  const [currentItem, setCurrentItem] = useState('');
  const [hits, setHits] = useState(0);
  const [misses, setMisses] = useState(0);
  const [falseAlarms, setFalseAlarms] = useState(0);
  const [lastFeedback, setLastFeedback] = useState<'correct' | 'wrong' | null>(null);

  const sequence = useRef<{ items: string[]; matches: boolean[] }>({ items: [], matches: [] });
  const responded = useRef(false);
  const timerRef = useRef<ReturnType<typeof setTimeout>>(undefined);

  const showNext = useCallback((index: number) => {
    const seq = sequence.current;
    if (index >= seq.items.length) {
      setPhase('done');
      return;
    }

    setCurrentIndex(index);
    setCurrentItem(seq.items[index]);
    setLastFeedback(null);
    responded.current = false;

    timerRef.current = setTimeout(() => {
      if (!responded.current && index >= nLevel && seq.matches[index]) {
        setMisses(m => m + 1);
      }
      setCurrentItem('');
      setTimeout(() => showNext(index + 1), GAP_MS);
    }, DISPLAY_MS);
  }, [nLevel]);

  const startGame = () => {
    sequence.current = generateSequence(nLevel);
    setPhase('playing');
    setCurrentIndex(-1);
    setHits(0);
    setMisses(0);
    setFalseAlarms(0);
    setLastFeedback(null);
    setTimeout(() => showNext(0), 500);
  };

  useEffect(() => {
    return () => clearTimeout(timerRef.current);
  }, []);

  const handleMatch = () => {
    if (phase !== 'playing' || responded.current || currentIndex < nLevel) return;
    responded.current = true;
    const isMatch = sequence.current.matches[currentIndex];
    if (isMatch) {
      setHits(h => h + 1);
      setLastFeedback('correct');
    } else {
      setFalseAlarms(f => f + 1);
      setLastFeedback('wrong');
    }
  };

  useEffect(() => {
    if (phase === 'done') {
      const totalMatches = sequence.current.matches.filter(Boolean).length;
      const accuracy = totalMatches > 0 ? (hits / totalMatches) : 0;
      const precision = (hits + falseAlarms) > 0 ? hits / (hits + falseAlarms) : 0;
      const score = Math.round((accuracy * 0.5 + precision * 0.5) * 100);
      addGameResult({ type: 'nback', score, level: nLevel });
    }
  }, [phase]);

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🧩</span>
          <h1>N-back 훈련</h1>
          <p>
            <strong>{nLevel}번 전</strong>과 같은 모양이 나오면<br />
            "같음" 버튼을 누르세요!
          </p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>👀</span><span>모양이 하나씩 표시</span></div>
            <div className="game-rule"><span>🔙</span><span>{nLevel}번 전과 비교</span></div>
            <div className="game-rule"><span>🧠</span><span>작업 기억 강화</span></div>
          </div>
          <div className="nback-level-select">
            {[1, 2, 3].map(n => (
              <button
                key={n}
                className={`nback-level-btn ${nLevel === n ? 'nback-level-btn--active' : ''}`}
                onClick={() => setNLevel(n)}
              >
                {n}-back
              </button>
            ))}
          </div>
          <button className="btn btn--primary btn--large" onClick={startGame}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    const totalMatches = sequence.current.matches.filter(Boolean).length;
    const accuracy = totalMatches > 0 ? Math.round((hits / totalMatches) * 100) : 0;
    const score = Math.round(
      ((totalMatches > 0 ? hits / totalMatches : 0) * 0.5 +
        ((hits + falseAlarms) > 0 ? hits / (hits + falseAlarms) : 0) * 0.5) * 100
    );

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
              <span className="game-over-stat-label">정확도</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{nLevel}-back</span>
              <span className="game-over-stat-label">레벨</span>
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
        <span className="game-level">{nLevel}-back</span>
        <span className="game-score">{currentIndex + 1}/{TOTAL_STIMULI}</span>
      </header>

      <div className="nback-play">
        <div className="nback-display">
          <span className="nback-shape">{currentItem || '·'}</span>
        </div>

        {lastFeedback && (
          <span className={`nback-feedback ${lastFeedback === 'correct' ? 'nback-feedback--correct' : 'nback-feedback--wrong'}`}>
            {lastFeedback === 'correct' ? '✅ 정답!' : '❌ 오답'}
          </span>
        )}

        <button
          className="btn btn--primary btn--large nback-match-btn"
          onClick={handleMatch}
          disabled={currentIndex < nLevel || responded.current}
        >
          같음! ({nLevel}번 전과 동일)
        </button>

        <div className="nback-stats">
          <span>✅ {hits}</span>
          <span>❌ {falseAlarms}</span>
          <span>😕 {misses}</span>
        </div>
      </div>
    </div>
  );
}
