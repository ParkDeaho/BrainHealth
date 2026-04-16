import { useState, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTestResults } from '../../store/useStore';

type Phase = 'ready' | 'show' | 'input' | 'feedback' | 'gameover';

function generateDigits(length: number): number[] {
  return Array.from({ length }, () => Math.floor(Math.random() * 10));
}

export default function DigitSpan() {
  const navigate = useNavigate();
  const { addResult } = useTestResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [level, setLevel] = useState(1);
  const [spanLength, setSpanLength] = useState(3);
  const [digits, setDigits] = useState<number[]>([]);
  const [showIndex, setShowIndex] = useState(-1);
  const [userInput, setUserInput] = useState('');
  const [isCorrect, setIsCorrect] = useState(false);
  const [score, setScore] = useState(0);
  const [maxSpan, setMaxSpan] = useState(0);

  const startRound = useCallback(() => {
    const newDigits = generateDigits(spanLength);
    setDigits(newDigits);
    setUserInput('');
    setPhase('show');
    setShowIndex(0);

    let idx = 0;
    const interval = setInterval(() => {
      idx++;
      if (idx >= newDigits.length) {
        clearInterval(interval);
        setTimeout(() => {
          setShowIndex(-1);
          setPhase('input');
        }, 800);
      } else {
        setShowIndex(idx);
      }
    }, 800);
  }, [spanLength]);

  const handleSubmit = () => {
    const reversed = [...digits].reverse();
    const expected = reversed.join('');
    const correct = userInput === expected;
    setIsCorrect(correct);

    if (correct) {
      setScore(s => s + spanLength * 15);
      setMaxSpan(Math.max(maxSpan, spanLength));
      setLevel(l => l + 1);
      setSpanLength(s => s + 1);
    }
    setPhase('feedback');
  };

  const handleNext = () => {
    if (isCorrect) {
      startRound();
    } else {
      addResult({
        type: 'digit-span',
        score: Math.min(score, 100),
        category: 'memory',
        level,
        metrics: { maxSpan: Math.max(maxSpan, spanLength - 1), totalScore: score },
      });
      setPhase('gameover');
    }
  };

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🔄</span>
          <h1>숫자 역순 테스트</h1>
          <p>숫자를 하나씩 보여드립니다.<br /><strong>역순(거꾸로)</strong>으로 입력하세요!</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>👀</span><span>숫자가 하나씩 표시</span></div>
            <div className="game-rule"><span>🔄</span><span>거꾸로 입력 (3→5→7 → 753)</span></div>
            <div className="game-rule"><span>⬆️</span><span>맞히면 자릿수 증가</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startRound}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'gameover') {
    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">{score >= 60 ? '🌟' : '💪'}</span>
          <h2>테스트 완료!</h2>
          <div className="game-over-stats">
            <div className="game-over-stat">
              <span className="game-over-stat-value">{score}</span>
              <span className="game-over-stat-label">점수</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{Math.max(maxSpan, spanLength - 1)}</span>
              <span className="game-over-stat-label">최대 자릿수</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{level - 1}</span>
              <span className="game-over-stat-label">레벨</span>
            </div>
          </div>
          <div className="game-over-actions">
            <button className="btn btn--primary" onClick={() => {
              setPhase('ready'); setLevel(1); setSpanLength(3); setScore(0); setMaxSpan(0);
            }}>다시 하기</button>
            <button className="btn btn--ghost" onClick={() => navigate('/tests')}>돌아가기</button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="page page--game">
      <header className="game-header">
        <span className="game-level">레벨 {level}</span>
        <span className="game-score">{spanLength}자리</span>
      </header>

      {phase === 'show' && (
        <div className="test-center">
          <p className="test-hint">숫자를 기억하세요 (역순 입력!)</p>
          <div className="digit-span-display">
            {showIndex >= 0 && (
              <span className="digit-span-digit">{digits[showIndex]}</span>
            )}
          </div>
          <div className="digit-span-dots">
            {digits.map((_, i) => (
              <span key={i} className={`digit-dot ${i <= showIndex ? 'digit-dot--active' : ''}`} />
            ))}
          </div>
        </div>
      )}

      {phase === 'input' && (
        <div className="test-center">
          <p className="test-hint">거꾸로 입력하세요!</p>
          <p className="digit-span-original">원래 순서: {digits.join(' → ')}</p>
          <input
            type="tel"
            className="game-input-field"
            value={userInput}
            onChange={e => setUserInput(e.target.value.replace(/[^0-9]/g, ''))}
            onKeyDown={e => { if (e.key === 'Enter' && userInput.length > 0) handleSubmit(); }}
            placeholder={`${spanLength}자리 역순`}
            maxLength={spanLength + 2}
            autoFocus
          />
          <button className="btn btn--primary btn--large" onClick={handleSubmit} disabled={!userInput}>확인</button>
        </div>
      )}

      {phase === 'feedback' && (
        <div className="test-center">
          <span className="game-result-emoji">{isCorrect ? '✅' : '❌'}</span>
          <h2>{isCorrect ? '정답!' : '아쉬워요'}</h2>
          {!isCorrect && (
            <div className="game-result-compare">
              <p>원래: {digits.join(' ')}</p>
              <p>정답: {[...digits].reverse().join('')}</p>
              <p>입력: {userInput}</p>
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
