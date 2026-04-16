import { useState, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTestResults } from '../../store/useStore';

type Phase = 'ready' | 'show' | 'select' | 'feedback' | 'done';

const GRID_SIZES = [3, 3, 4, 4, 4, 5, 5];
const TARGET_COUNTS = [3, 4, 4, 5, 6, 6, 7];

export default function VisualPattern() {
  const navigate = useNavigate();
  const { addResult } = useTestResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [round, setRound] = useState(0);
  const [gridSize, setGridSize] = useState(3);
  const [targets, setTargets] = useState<Set<number>>(new Set());
  const [selected, setSelected] = useState<Set<number>>(new Set());
  const [correct, setCorrect] = useState(0);
  const [totalRounds] = useState(GRID_SIZES.length);

  const startRound = useCallback((r: number) => {
    const size = GRID_SIZES[r];
    const count = TARGET_COUNTS[r];
    setGridSize(size);
    const total = size * size;
    const tgt = new Set<number>();
    while (tgt.size < count) {
      tgt.add(Math.floor(Math.random() * total));
    }
    setTargets(tgt);
    setSelected(new Set());
    setPhase('show');
    setTimeout(() => setPhase('select'), 1500 + r * 200);
  }, []);

  const handleSelect = (idx: number) => {
    if (phase !== 'select') return;
    setSelected(prev => {
      const next = new Set(prev);
      if (next.has(idx)) next.delete(idx);
      else if (next.size < targets.size) next.add(idx);
      return next;
    });
  };

  const handleConfirm = () => {
    const hit = [...selected].filter(s => targets.has(s)).length;
    setCorrect(prev => prev + hit);
    setPhase('feedback');
  };

  const handleNext = () => {
    const nextRound = round + 1;
    if (nextRound >= totalRounds) {
      const maxCorrect = TARGET_COUNTS.reduce((s, c) => s + c, 0);
      const score = Math.round((correct / maxCorrect) * 100);
      addResult({
        type: 'visual-pattern',
        score,
        category: 'memory',
        metrics: { correct, maxCorrect, rounds: totalRounds },
      });
      setPhase('done');
    } else {
      setRound(nextRound);
      startRound(nextRound);
    }
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🔲</span>
          <h1>시각 패턴 기억</h1>
          <p>격자에서 잠시 빛나는 칸을 기억한 뒤<br />같은 위치를 선택하세요!</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>✨</span><span>빛나는 칸 기억</span></div>
            <div className="game-rule"><span>👆</span><span>같은 위치 선택</span></div>
            <div className="game-rule"><span>⬆️</span><span>점점 격자가 커짐</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={() => { setRound(0); setCorrect(0); startRound(0); }}>
            시작하기
          </button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    const maxCorrect = TARGET_COUNTS.reduce((s, c) => s + c, 0);
    const score = Math.round((correct / maxCorrect) * 100);
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
              <span className="game-over-stat-value">{correct}/{maxCorrect}</span>
              <span className="game-over-stat-label">정답</span>
            </div>
          </div>
          <div className="game-over-actions">
            <button className="btn btn--primary" onClick={() => { setRound(0); setCorrect(0); startRound(0); }}>다시 하기</button>
            <button className="btn btn--ghost" onClick={() => navigate('/tests')}>돌아가기</button>
          </div>
        </div>
      </div>
    );
  }

  const showTargets = phase === 'show' || phase === 'feedback';
  const hitCount = [...selected].filter(s => targets.has(s)).length;

  return (
    <div className="page page--game">
      <header className="game-header">
        <span className="game-level">라운드 {round + 1}/{totalRounds}</span>
        <span className="game-score">
          {phase === 'show' && '위치를 기억하세요!'}
          {phase === 'select' && `${selected.size}/${targets.size}개 선택`}
          {phase === 'feedback' && `${hitCount}/${targets.size} 정답!`}
        </span>
      </header>

      <div className="vp-grid" style={{ gridTemplateColumns: `repeat(${gridSize}, 1fr)` }}>
        {Array.from({ length: gridSize * gridSize }).map((_, i) => (
          <button
            key={i}
            className={`vp-cell ${showTargets && targets.has(i) ? 'vp-cell--target' : ''} ${selected.has(i) ? 'vp-cell--selected' : ''} ${phase === 'feedback' && targets.has(i) ? 'vp-cell--reveal' : ''}`}
            onClick={() => handleSelect(i)}
            disabled={phase !== 'select'}
          />
        ))}
      </div>

      {phase === 'select' && (
        <button
          className="btn btn--primary btn--large"
          onClick={handleConfirm}
          disabled={selected.size !== targets.size}
          style={{ marginTop: 16 }}
        >
          확인
        </button>
      )}
      {phase === 'feedback' && (
        <button className="btn btn--primary" onClick={handleNext} style={{ marginTop: 16 }}>
          {round + 1 < totalRounds ? '다음' : '결과 보기'}
        </button>
      )}
    </div>
  );
}
