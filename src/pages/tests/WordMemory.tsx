import { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTestResults } from '../../store/useStore';

type Phase = 'ready' | 'show' | 'distract' | 'recall' | 'result';

const WORD_POOL = [
  '사과', '바다', '연필', '구름', '의자', '시계', '거울', '나무',
  '책상', '별', '우산', '기차', '꽃', '산', '열쇠', '모자',
  '강', '새', '창문', '돌', '바람', '달', '손', '빵',
];

function pickRandom(arr: string[], n: number): string[] {
  const shuffled = [...arr].sort(() => Math.random() - 0.5);
  return shuffled.slice(0, n);
}

export default function WordMemory() {
  const navigate = useNavigate();
  const { addResult } = useTestResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [words, setWords] = useState<string[]>([]);
  const [userInput, setUserInput] = useState('');
  const [recalled, setRecalled] = useState<string[]>([]);
  const [countdown, setCountdown] = useState(60);
  const [score, setScore] = useState(0);

  const startGame = useCallback(() => {
    setWords(pickRandom(WORD_POOL, 5));
    setPhase('show');
    setRecalled([]);
    setUserInput('');
  }, []);

  useEffect(() => {
    if (phase === 'show') {
      const timer = setTimeout(() => setPhase('distract'), 5000);
      return () => clearTimeout(timer);
    }
  }, [phase]);

  useEffect(() => {
    if (phase === 'distract') {
      setCountdown(60);
      const interval = setInterval(() => {
        setCountdown(prev => {
          if (prev <= 1) {
            clearInterval(interval);
            setPhase('recall');
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
      return () => clearInterval(interval);
    }
  }, [phase]);

  const handleAddWord = () => {
    const word = userInput.trim();
    if (word && !recalled.includes(word)) {
      setRecalled(prev => [...prev, word]);
    }
    setUserInput('');
  };

  const handleFinish = () => {
    const correct = recalled.filter(w => words.includes(w));
    const s = Math.round((correct.length / words.length) * 100);
    setScore(s);
    addResult({
      type: 'word-memory',
      score: s,
      category: 'memory',
      metrics: {
        total: words.length,
        recalled: recalled.length,
        correct: correct.length,
      },
    });
    setPhase('result');
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">📝</span>
          <h1>단어 기억 테스트</h1>
          <p>5개 단어를 보여드려요.<br />1분 후 기억나는 단어를 모두 입력하세요.</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>👀</span><span>5초간 단어 보기</span></div>
            <div className="game-rule"><span>⏳</span><span>1분 대기</span></div>
            <div className="game-rule"><span>✍️</span><span>기억나는 단어 입력</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startGame}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'show') {
    return (
      <div className="page page--game">
        <div className="test-center">
          <p className="test-hint">이 단어들을 기억하세요!</p>
          <div className="word-memory-words">
            {words.map((w, i) => (
              <span key={i} className="word-memory-word">{w}</span>
            ))}
          </div>
          <div className="game-show-timer">
            <div className="game-show-timer-bar" style={{ animationDuration: '5000ms' }} />
          </div>
        </div>
      </div>
    );
  }

  if (phase === 'distract') {
    return (
      <div className="page page--game">
        <div className="test-center">
          <span style={{ fontSize: 48 }}>⏳</span>
          <h2>잠시 기다려주세요</h2>
          <p className="test-hint">단어를 떠올리지 마세요</p>
          <div className="distract-countdown">{countdown}초</div>
          <button className="btn btn--ghost" onClick={() => setPhase('recall')}>
            바로 입력하기
          </button>
        </div>
      </div>
    );
  }

  if (phase === 'recall') {
    return (
      <div className="page page--game">
        <div className="test-recall">
          <h2>기억나는 단어를 입력하세요</h2>
          <div className="recall-input-row">
            <input
              type="text"
              value={userInput}
              onChange={e => setUserInput(e.target.value)}
              onKeyDown={e => { if (e.key === 'Enter') handleAddWord(); }}
              placeholder="단어 입력"
              className="recall-input"
              autoFocus
            />
            <button className="btn btn--primary" onClick={handleAddWord}>추가</button>
          </div>
          <div className="recall-tags">
            {recalled.map((w, i) => (
              <span key={i} className="recall-tag">
                {w}
                <button onClick={() => setRecalled(prev => prev.filter((_, j) => j !== i))}>×</button>
              </span>
            ))}
          </div>
          <p className="recall-count">{recalled.length}개 입력됨</p>
          <button className="btn btn--primary btn--large" onClick={handleFinish}>완료</button>
        </div>
      </div>
    );
  }

  const correct = recalled.filter(w => words.includes(w));
  const missed = words.filter(w => !recalled.includes(w));

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
            <span className="game-over-stat-value">{correct.length}/{words.length}</span>
            <span className="game-over-stat-label">정답</span>
          </div>
        </div>
        <div className="word-result-detail">
          <p>✅ 맞힌 단어: {correct.length > 0 ? correct.join(', ') : '없음'}</p>
          <p>❌ 놓친 단어: {missed.length > 0 ? missed.join(', ') : '없음'}</p>
        </div>
        <div className="game-over-actions">
          <button className="btn btn--primary" onClick={() => { setPhase('ready'); setScore(0); }}>다시 하기</button>
          <button className="btn btn--ghost" onClick={() => navigate('/tests')}>돌아가기</button>
        </div>
      </div>
    </div>
  );
}
