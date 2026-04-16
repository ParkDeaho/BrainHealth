import { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGameResults } from '../../store/useStore';

const EMOJIS = ['🍎', '🌙', '🎵', '🌸', '🐱', '⭐', '🔥', '🎯'];

interface Card {
  id: number;
  emoji: string;
  flipped: boolean;
  matched: boolean;
}

function createDeck(pairs: number): Card[] {
  const selected = EMOJIS.slice(0, pairs);
  const deck = [...selected, ...selected].map((emoji, i) => ({
    id: i,
    emoji,
    flipped: false,
    matched: false,
  }));
  return deck.sort(() => Math.random() - 0.5);
}

export default function CardMatch() {
  const navigate = useNavigate();
  const { addGameResult } = useGameResults();

  const [phase, setPhase] = useState<'ready' | 'playing' | 'done'>('ready');
  const [cards, setCards] = useState<Card[]>([]);
  const [flipped, setFlipped] = useState<number[]>([]);
  const [moves, setMoves] = useState(0);
  const [matched, setMatched] = useState(0);
  const [timer, setTimer] = useState(0);
  const [pairs] = useState(6);
  const lockRef = useRef(false);
  const intervalRef = useRef<ReturnType<typeof setInterval>>(undefined);

  const startGame = () => {
    setCards(createDeck(pairs));
    setFlipped([]);
    setMoves(0);
    setMatched(0);
    setTimer(0);
    setPhase('playing');
    lockRef.current = false;
    intervalRef.current = setInterval(() => setTimer(t => t + 1), 1000);
  };

  useEffect(() => {
    return () => clearInterval(intervalRef.current);
  }, []);

  useEffect(() => {
    if (matched === pairs && phase === 'playing') {
      clearInterval(intervalRef.current);
      const timeBonus = Math.max(0, 60 - timer) * 2;
      const moveBonus = Math.max(0, 30 - moves) * 3;
      const score = Math.min(100, 40 + timeBonus + moveBonus);
      addGameResult({ type: 'card-match', score, level: pairs });
      setTimeout(() => setPhase('done'), 600);
    }
  }, [matched]);

  const handleFlip = (id: number) => {
    if (lockRef.current || phase !== 'playing') return;
    const card = cards[id];
    if (card.flipped || card.matched) return;

    const newFlipped = [...flipped, id];
    setCards(prev => prev.map((c, i) => i === id ? { ...c, flipped: true } : c));
    setFlipped(newFlipped);

    if (newFlipped.length === 2) {
      lockRef.current = true;
      setMoves(m => m + 1);
      const [first, second] = newFlipped;
      if (cards[first].emoji === cards[second].emoji) {
        setTimeout(() => {
          setCards(prev => prev.map((c, i) =>
            i === first || i === second ? { ...c, matched: true } : c
          ));
          setMatched(m => m + 1);
          setFlipped([]);
          lockRef.current = false;
        }, 400);
      } else {
        setTimeout(() => {
          setCards(prev => prev.map((c, i) =>
            i === first || i === second ? { ...c, flipped: false } : c
          ));
          setFlipped([]);
          lockRef.current = false;
        }, 800);
      }
    }
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🃏</span>
          <h1>카드 뒤집기</h1>
          <p>같은 그림의 카드 짝을 찾으세요!<br />기억력을 훈련합니다.</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>🎴</span><span>{pairs}쌍 ({pairs * 2}장)</span></div>
            <div className="game-rule"><span>👆</span><span>카드 2장씩 뒤집기</span></div>
            <div className="game-rule"><span>⏱</span><span>빠를수록 높은 점수</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startGame}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    const timeBonus = Math.max(0, 60 - timer) * 2;
    const moveBonus = Math.max(0, 30 - moves) * 3;
    const score = Math.min(100, 40 + timeBonus + moveBonus);
    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">{score >= 80 ? '🌟' : score >= 60 ? '👏' : '💪'}</span>
          <h2>게임 완료!</h2>
          <div className="game-over-stats">
            <div className="game-over-stat">
              <span className="game-over-stat-value">{score}</span>
              <span className="game-over-stat-label">점수</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{timer}초</span>
              <span className="game-over-stat-label">시간</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{moves}</span>
              <span className="game-over-stat-label">시도</span>
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
        <span className="game-level">시도: {moves}</span>
        <span className="game-score">⏱ {timer}초</span>
      </header>

      <div className="card-grid">
        {cards.map((card, i) => (
          <button
            key={card.id}
            className={`flip-card ${card.flipped || card.matched ? 'flip-card--flipped' : ''} ${card.matched ? 'flip-card--matched' : ''}`}
            onClick={() => handleFlip(i)}
          >
            <div className="flip-card-inner">
              <div className="flip-card-front">?</div>
              <div className="flip-card-back">{card.emoji}</div>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}
