import { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTestResults } from '../../store/useStore';

type Phase = 'ready' | 'playing' | 'done';

const LETTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const TARGET = 'X';
const TOTAL_STIMULI = 30;
const TARGET_RATIO = 0.3;
const DISPLAY_MS = 800;
const GAP_MS = 400;

export default function CPTTest() {
  const navigate = useNavigate();
  const { addResult } = useTestResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [currentLetter, setCurrentLetter] = useState('');
  const [stimulusIndex, setStimulusIndex] = useState(0);
  const [hits, setHits] = useState(0);
  const [misses, setMisses] = useState(0);
  const [falseAlarms, setFalseAlarms] = useState(0);
  const [reactionTimes, setReactionTimes] = useState<number[]>([]);
  const [showFeedback, setShowFeedback] = useState<'hit' | 'miss' | 'false' | null>(null);

  const stimuli = useRef<string[]>([]);
  const stimulusStart = useRef(0);
  const responded = useRef(false);
  const timerRef = useRef<ReturnType<typeof setTimeout>>(undefined);

  const generateStimuli = useCallback(() => {
    const arr: string[] = [];
    const targetCount = Math.round(TOTAL_STIMULI * TARGET_RATIO);
    for (let i = 0; i < targetCount; i++) arr.push(TARGET);
    for (let i = targetCount; i < TOTAL_STIMULI; i++) {
      let letter = LETTERS[Math.floor(Math.random() * LETTERS.length)];
      while (letter === TARGET) letter = LETTERS[Math.floor(Math.random() * LETTERS.length)];
      arr.push(letter);
    }
    return arr.sort(() => Math.random() - 0.5);
  }, []);

  const showNext = useCallback((index: number, stims: string[]) => {
    if (index >= stims.length) {
      setPhase('done');
      return;
    }

    const letter = stims[index];
    setCurrentLetter(letter);
    setStimulusIndex(index);
    stimulusStart.current = Date.now();
    responded.current = false;

    timerRef.current = setTimeout(() => {
      if (!responded.current && letter === TARGET) {
        setMisses(m => m + 1);
        setShowFeedback('miss');
      }
      setCurrentLetter('');
      setTimeout(() => {
        setShowFeedback(null);
        showNext(index + 1, stims);
      }, GAP_MS);
    }, DISPLAY_MS);
  }, []);

  const startGame = () => {
    const stims = generateStimuli();
    stimuli.current = stims;
    setPhase('playing');
    setStimulusIndex(0);
    setHits(0);
    setMisses(0);
    setFalseAlarms(0);
    setReactionTimes([]);
    setShowFeedback(null);
    showNext(0, stims);
  };

  useEffect(() => {
    return () => { clearTimeout(timerRef.current); };
  }, []);

  const handleTap = () => {
    if (phase !== 'playing' || responded.current || !currentLetter) return;
    responded.current = true;
    const rt = Date.now() - stimulusStart.current;

    if (currentLetter === TARGET) {
      setHits(h => h + 1);
      setReactionTimes(prev => [...prev, rt]);
      setShowFeedback('hit');
    } else {
      setFalseAlarms(f => f + 1);
      setShowFeedback('false');
    }
  };

  useEffect(() => {
    if (phase === 'done') {
      const totalTargets = stimuli.current.filter(s => s === TARGET).length;
      const hitRate = totalTargets > 0 ? hits / totalTargets : 0;
      const falseRate = (TOTAL_STIMULI - totalTargets) > 0
        ? falseAlarms / (TOTAL_STIMULI - totalTargets) : 0;
      const avgRt = reactionTimes.length > 0
        ? Math.round(reactionTimes.reduce((s, t) => s + t, 0) / reactionTimes.length) : 0;
      const score = Math.round(
        Math.max(0, hitRate * 60 + (1 - falseRate) * 25 + Math.max(0, (600 - avgRt) / 600) * 15) * 100 / 100
      );
      addResult({
        type: 'cpt',
        score: Math.min(score, 100),
        category: 'focus',
        metrics: { hits, misses, falseAlarms, avgReactionMs: avgRt, totalTargets },
      });
    }
  }, [phase]);

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🔤</span>
          <h1>지속 집중 테스트 (CPT)</h1>
          <p>알파벳이 하나씩 나타납니다.<br /><strong>X가 나오면</strong> 화면을 터치하세요!</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>🎯</span><span>X가 나오면 터치</span></div>
            <div className="game-rule"><span>🚫</span><span>다른 글자에는 터치 금지</span></div>
            <div className="game-rule"><span>⏱</span><span>총 {TOTAL_STIMULI}개 자극</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startGame}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    const totalTargets = stimuli.current.filter(s => s === TARGET).length;
    const hitRate = totalTargets > 0 ? Math.round((hits / totalTargets) * 100) : 0;
    const avgRt = reactionTimes.length > 0
      ? Math.round(reactionTimes.reduce((s, t) => s + t, 0) / reactionTimes.length) : 0;

    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">{hitRate >= 80 ? '🌟' : hitRate >= 60 ? '👏' : '💪'}</span>
          <h2>테스트 완료!</h2>
          <div className="game-over-stats">
            <div className="game-over-stat">
              <span className="game-over-stat-value">{hitRate}%</span>
              <span className="game-over-stat-label">탐지율</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{avgRt}ms</span>
              <span className="game-over-stat-label">평균 반응</span>
            </div>
            <div className="game-over-stat">
              <span className="game-over-stat-value">{falseAlarms}</span>
              <span className="game-over-stat-label">오경보</span>
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
    <div className="page page--reaction reaction--cpt" onClick={handleTap}>
      <div className="cpt-header">
        <span>{stimulusIndex + 1} / {TOTAL_STIMULI}</span>
        <span>✅ {hits} | ❌ {falseAlarms}</span>
      </div>
      <div className="cpt-center">
        <div className={`cpt-letter ${currentLetter === TARGET ? 'cpt-letter--target' : ''}`}>
          {currentLetter || '·'}
        </div>
        {showFeedback === 'hit' && <span className="cpt-feedback cpt-feedback--hit">정확! ✅</span>}
        {showFeedback === 'miss' && <span className="cpt-feedback cpt-feedback--miss">놓침 😕</span>}
        {showFeedback === 'false' && <span className="cpt-feedback cpt-feedback--false">오경보 ⚠️</span>}
      </div>
      <p className="cpt-instruction">X가 보이면 터치!</p>
    </div>
  );
}
