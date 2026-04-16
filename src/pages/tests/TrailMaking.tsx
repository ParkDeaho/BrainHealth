import { useState, useRef, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTestResults } from '../../store/useStore';

type Phase = 'ready' | 'playing' | 'done';

interface Node {
  id: number;
  label: string;
  x: number;
  y: number;
}

function generateNodes(count: number): Node[] {
  const nodes: Node[] = [];
  const margin = 15;
  for (let i = 0; i < count; i++) {
    let x: number, y: number, valid: boolean;
    let attempts = 0;
    do {
      x = margin + Math.random() * (100 - 2 * margin);
      y = margin + Math.random() * (100 - 2 * margin);
      valid = nodes.every(n => Math.hypot(n.x - x, n.y - y) > 14);
      attempts++;
    } while (!valid && attempts < 50);
    nodes.push({ id: i, label: String(i + 1), x, y });
  }
  return nodes;
}

export default function TrailMaking() {
  const navigate = useNavigate();
  const { addResult } = useTestResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [nodes, setNodes] = useState<Node[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [errors, setErrors] = useState(0);
  const [completed, setCompleted] = useState<Set<number>>(new Set());
  const [wrongId, setWrongId] = useState<number | null>(null);
  const startTime = useRef(0);
  const [elapsed, setElapsed] = useState(0);
  const [nodeCount] = useState(10);

  const startGame = useCallback(() => {
    setNodes(generateNodes(nodeCount));
    setCurrentIndex(0);
    setErrors(0);
    setCompleted(new Set());
    setWrongId(null);
    startTime.current = Date.now();
    setPhase('playing');
  }, [nodeCount]);

  const handleTap = (node: Node) => {
    if (phase !== 'playing') return;
    if (node.id === currentIndex) {
      setCompleted(prev => new Set([...prev, node.id]));
      setWrongId(null);

      if (currentIndex === nodes.length - 1) {
        const time = Date.now() - startTime.current;
        setElapsed(time);
        const timeSec = time / 1000;
        const errorPenalty = errors * 5;
        const score = Math.max(0, Math.min(100, Math.round(100 - timeSec * 2 - errorPenalty)));
        addResult({
          type: 'trail-making',
          score,
          category: 'focus',
          metrics: { timeSec: Math.round(timeSec * 10) / 10, errors, nodeCount },
        });
        setPhase('done');
      } else {
        setCurrentIndex(i => i + 1);
      }
    } else {
      setErrors(e => e + 1);
      setWrongId(node.id);
      setTimeout(() => setWrongId(null), 500);
    }
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🔢</span>
          <h1>순서 맞추기</h1>
          <p>1부터 {nodeCount}까지<br />순서대로 빠르게 터치하세요!</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>1️⃣</span><span>숫자 순서대로 터치</span></div>
            <div className="game-rule"><span>⏱</span><span>빠를수록 높은 점수</span></div>
            <div className="game-rule"><span>❌</span><span>틀리면 감점</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startGame}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    const timeSec = Math.round(elapsed / 100) / 10;
    const score = Math.max(0, Math.min(100, Math.round(100 - timeSec * 2 - errors * 5)));
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
              <span className="game-over-stat-value">{timeSec}초</span>
              <span className="game-over-stat-label">시간</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{errors}</span>
              <span className="game-over-stat-label">오류</span>
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
        <span className="game-level">다음: {currentIndex + 1}</span>
        <span className="game-score">오류: {errors}</span>
      </header>

      <div className="trail-area">
        {nodes.map(node => (
          <button
            key={node.id}
            className={`trail-node ${completed.has(node.id) ? 'trail-node--done' : ''} ${node.id === currentIndex ? 'trail-node--next' : ''} ${wrongId === node.id ? 'trail-node--wrong' : ''}`}
            style={{ left: `${node.x}%`, top: `${node.y}%` }}
            onClick={() => handleTap(node)}
          >
            {node.label}
          </button>
        ))}
      </div>
    </div>
  );
}
