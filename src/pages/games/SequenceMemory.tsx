import { useState, useEffect, useCallback, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGameResults } from '../../store/useStore';

type Phase = 'ready' | 'show' | 'input' | 'feedback' | 'done';

const GRID = 9;
const COLORS = ['#6C63FF', '#00C9A7', '#FFB020', '#EF4444'];

export default function SequenceMemory() {
  const navigate = useNavigate();
  const { addGameResult } = useGameResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [sequence, setSequence] = useState<number[]>([]);
  const [userInput, setUserInput] = useState<number[]>([]);
  const [activeCell, setActiveCell] = useState<number | null>(null);
  const [level, setLevel] = useState(1);
  const [score, setScore] = useState(0);
  const [isCorrect, setIsCorrect] = useState(false);
  const showTimer = useRef<ReturnType<typeof setTimeout>>(undefined);

  const showSequence = useCallback((seq: number[]) => {
    setPhase('show');
    let i = 0;
    const show = () => {
      if (i < seq.length) {
        setActiveCell(seq[i]);
        showTimer.current = setTimeout(() => {
          setActiveCell(null);
          i++;
          showTimer.current = setTimeout(show, 300);
        }, 600);
      } else {
        setPhase('input');
        setUserInput([]);
      }
    };
    showTimer.current = setTimeout(show, 500);
  }, []);

  const startGame = () => {
    setLevel(1);
    setScore(0);
    const first = [Math.floor(Math.random() * GRID)];
    setSequence(first);
    showSequence(first);
  };

  useEffect(() => {
    return () => clearTimeout(showTimer.current);
  }, []);

  const handleTap = (idx: number) => {
    if (phase !== 'input') return;
    setActiveCell(idx);
    setTimeout(() => setActiveCell(null), 200);

    const newInput = [...userInput, idx];
    setUserInput(newInput);

    const pos = newInput.length - 1;
    if (newInput[pos] !== sequence[pos]) {
      setIsCorrect(false);
      setPhase('feedback');
      return;
    }

    if (newInput.length === sequence.length) {
      setIsCorrect(true);
      setScore(s => s + level * 10);
      setPhase('feedback');
    }
  };

  const handleNext = () => {
    if (isCorrect) {
      const nextLevel = level + 1;
      setLevel(nextLevel);
      const newSeq = [...sequence, Math.floor(Math.random() * GRID)];
      setSequence(newSeq);
      showSequence(newSeq);
    } else {
      addGameResult({ type: 'sequence-memory', score, level: level - 1 });
      setPhase('done');
    }
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🎵</span>
          <h1>시퀀스 기억</h1>
          <p>빛나는 순서를 기억하고<br />같은 순서대로 터치하세요!</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>👀</span><span>빛나는 순서 관찰</span></div>
            <div className="game-rule"><span>👆</span><span>같은 순서로 터치</span></div>
            <div className="game-rule"><span>⬆️</span><span>성공하면 1개씩 추가</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startGame}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">{score >= 80 ? '🌟' : score >= 40 ? '👏' : '💪'}</span>
          <h2>게임 종료!</h2>
          <div className="game-over-stats">
            <div className="game-over-stat">
              <span className="game-over-stat-value">{score}</span>
              <span className="game-over-stat-label">점수</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{level - 1}</span>
              <span className="game-over-stat-label">최대 레벨</span>
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
        <span className="game-level">레벨 {level}</span>
        <span className="game-score">
          {phase === 'show' && '순서를 기억하세요!'}
          {phase === 'input' && `${userInput.length}/${sequence.length}`}
          {phase === 'feedback' && (isCorrect ? '정답! ✅' : '아쉬워요 ❌')}
        </span>
      </header>

      <div className="seq-grid">
        {Array.from({ length: GRID }).map((_, i) => (
          <button
            key={i}
            className={`seq-cell ${activeCell === i ? 'seq-cell--active' : ''}`}
            style={activeCell === i ? { background: COLORS[i % COLORS.length] } : {}}
            onClick={() => handleTap(i)}
            disabled={phase !== 'input'}
          />
        ))}
      </div>

      {phase === 'feedback' && (
        <button className="btn btn--primary" onClick={handleNext} style={{ marginTop: 16 }}>
          {isCorrect ? '다음 레벨' : '결과 보기'}
        </button>
      )}
    </div>
  );
}
