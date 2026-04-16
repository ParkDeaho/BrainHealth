import { useState, useEffect, useCallback, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTestResults } from '../store/useStore';

type Phase = 'ready' | 'show' | 'input' | 'result' | 'gameover';

function generateNumber(digits: number): string {
  let num = '';
  for (let i = 0; i < digits; i++) {
    num += Math.floor(Math.random() * 10).toString();
  }
  return num;
}

export default function NumberMemory() {
  const navigate = useNavigate();
  const { addResult } = useTestResults();
  const inputRef = useRef<HTMLInputElement>(null);

  const [phase, setPhase] = useState<Phase>('ready');
  const [level, setLevel] = useState(1);
  const [digits, setDigits] = useState(3);
  const [target, setTarget] = useState('');
  const [userInput, setUserInput] = useState('');
  const [isCorrect, setIsCorrect] = useState(false);
  const [score, setScore] = useState(0);
  const [showTime, setShowTime] = useState(2000);

  const startRound = useCallback(() => {
    const num = generateNumber(digits);
    setTarget(num);
    setUserInput('');
    setPhase('show');
  }, [digits]);

  useEffect(() => {
    if (phase === 'show') {
      const timer = setTimeout(() => {
        setPhase('input');
        setTimeout(() => inputRef.current?.focus(), 100);
      }, showTime);
      return () => clearTimeout(timer);
    }
  }, [phase, showTime]);

  const handleSubmit = () => {
    const correct = userInput === target;
    setIsCorrect(correct);
    if (correct) {
      setScore(s => s + digits * 10);
      setLevel(l => l + 1);
      setDigits(d => d + 1);
      setShowTime(t => Math.min(t + 300, 5000));
    }
    setPhase('result');
  };

  const handleNext = () => {
    if (isCorrect) {
      startRound();
    } else {
      const finalScore = score;
      addResult({ type: 'number-memory', score: finalScore, level: level - 1, category: 'memory' });
      setPhase('gameover');
    }
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🔢</span>
          <h1>숫자 기억하기</h1>
          <p>화면에 나타나는 숫자를 기억한 뒤<br />정확히 입력하세요!</p>
          <div className="game-ready-rules">
            <div className="game-rule">
              <span>📏</span>
              <span>3자리부터 시작</span>
            </div>
            <div className="game-rule">
              <span>⬆️</span>
              <span>맞히면 한 자리씩 증가</span>
            </div>
            <div className="game-rule">
              <span>❌</span>
              <span>틀리면 게임 종료</span>
            </div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startRound}>
            시작하기
          </button>
        </div>
      </div>
    );
  }

  if (phase === 'gameover') {
    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">
            {score >= 100 ? '🌟' : score >= 50 ? '👏' : '💪'}
          </span>
          <h2>게임 종료!</h2>
          <div className="game-over-stats">
            <div className="game-over-stat">
              <span className="game-over-stat-value">{score}</span>
              <span className="game-over-stat-label">점수</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{level - 1}</span>
              <span className="game-over-stat-label">레벨</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{digits - 1}</span>
              <span className="game-over-stat-label">최대 자릿수</span>
            </div>
          </div>
          <div className="game-over-actions">
            <button className="btn btn--primary" onClick={() => {
              setPhase('ready');
              setLevel(1);
              setDigits(3);
              setScore(0);
              setShowTime(2000);
            }}>
              다시 하기
            </button>
            <button className="btn btn--ghost" onClick={() => navigate('/training')}>
              돌아가기
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="page page--game">
      <header className="game-header">
        <span className="game-level">레벨 {level}</span>
        <span className="game-score">점수: {score}</span>
      </header>

      {phase === 'show' && (
        <div className="game-show">
          <p className="game-show-hint">이 숫자를 기억하세요!</p>
          <div className="game-show-number">{target}</div>
          <div className="game-show-timer">
            <div
              className="game-show-timer-bar"
              style={{ animationDuration: `${showTime}ms` }}
            />
          </div>
        </div>
      )}

      {phase === 'input' && (
        <div className="game-input">
          <p className="game-input-hint">기억한 숫자를 입력하세요</p>
          <input
            ref={inputRef}
            type="tel"
            className="game-input-field"
            value={userInput}
            onChange={e => setUserInput(e.target.value.replace(/[^0-9]/g, ''))}
            onKeyDown={e => {
              if (e.key === 'Enter' && userInput.length > 0) handleSubmit();
            }}
            placeholder={`${digits}자리 숫자`}
            maxLength={digits + 2}
            autoFocus
          />
          <button
            className="btn btn--primary btn--large"
            onClick={handleSubmit}
            disabled={userInput.length === 0}
          >
            확인
          </button>
        </div>
      )}

      {phase === 'result' && (
        <div className="game-result">
          <span className="game-result-emoji">{isCorrect ? '✅' : '❌'}</span>
          <h2>{isCorrect ? '정답!' : '아쉬워요!'}</h2>
          {!isCorrect && (
            <div className="game-result-compare">
              <p>정답: <strong>{target}</strong></p>
              <p>입력: <strong>{userInput}</strong></p>
            </div>
          )}
          <button className="btn btn--primary" onClick={handleNext}>
            {isCorrect ? '다음 레벨' : '결과 보기'}
          </button>
        </div>
      )}
    </div>
  );
}
