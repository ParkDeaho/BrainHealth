import { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGameResults } from '../../store/useStore';

type Phase = 'ready' | 'breathing' | 'done';
type BreathStep = 'inhale' | 'hold' | 'exhale' | 'rest';

const CYCLE_STEPS: { step: BreathStep; duration: number; label: string }[] = [
  { step: 'inhale', duration: 4000, label: '들이쉬세요' },
  { step: 'hold', duration: 4000, label: '참으세요' },
  { step: 'exhale', duration: 6000, label: '내쉬세요' },
  { step: 'rest', duration: 2000, label: '편안하게' },
];

const TOTAL_CYCLES = 4;

export default function Breathing() {
  const navigate = useNavigate();
  const { addGameResult } = useGameResults();

  const [phase, setPhase] = useState<Phase>('ready');
  const [cycle, setCycle] = useState(0);
  const [stepIndex, setStepIndex] = useState(0);
  const [scale, setScale] = useState(1);
  const timerRef = useRef<ReturnType<typeof setTimeout>>(undefined);
  const animRef = useRef<number>(0);

  const currentStep = CYCLE_STEPS[stepIndex];

  const runStep = (cycleNum: number, sIdx: number) => {
    if (cycleNum >= TOTAL_CYCLES) {
      addGameResult({ type: 'breathing', score: 100, durationSec: TOTAL_CYCLES * 16 });
      setPhase('done');
      return;
    }

    setCycle(cycleNum);
    setStepIndex(sIdx);
    const step = CYCLE_STEPS[sIdx];

    const start = Date.now();
    const animate = () => {
      const elapsed = Date.now() - start;
      const progress = Math.min(elapsed / step.duration, 1);

      if (step.step === 'inhale') setScale(1 + progress * 0.5);
      else if (step.step === 'exhale') setScale(1.5 - progress * 0.5);
      else if (step.step === 'hold') setScale(1.5);
      else setScale(1);

      if (elapsed < step.duration) {
        animRef.current = requestAnimationFrame(animate);
      }
    };
    animRef.current = requestAnimationFrame(animate);

    timerRef.current = setTimeout(() => {
      cancelAnimationFrame(animRef.current);
      const nextStep = sIdx + 1;
      if (nextStep < CYCLE_STEPS.length) {
        runStep(cycleNum, nextStep);
      } else {
        runStep(cycleNum + 1, 0);
      }
    }, step.duration);
  };

  const startSession = () => {
    setPhase('breathing');
    runStep(0, 0);
  };

  useEffect(() => {
    return () => {
      clearTimeout(timerRef.current);
      cancelAnimationFrame(animRef.current);
    };
  }, []);

  if (phase === 'ready') {
    return (
      <div className="page page--game game-ready">
        <div className="game-ready-content">
          <span className="game-ready-icon">🧘</span>
          <h1>호흡 · 집중 회복</h1>
          <p>1분 호흡 가이드로<br />마음을 안정시키고 집중을 회복하세요</p>
          <div className="game-ready-rules">
            <div className="game-rule"><span>🫁</span><span>4초 들이쉬기</span></div>
            <div className="game-rule"><span>⏸️</span><span>4초 참기</span></div>
            <div className="game-rule"><span>💨</span><span>6초 내쉬기</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={startSession}>시작하기</button>
        </div>
      </div>
    );
  }

  if (phase === 'done') {
    return (
      <div className="page page--game game-over">
        <div className="game-over-content">
          <span className="game-over-emoji">🌿</span>
          <h2>호흡 완료!</h2>
          <p style={{ fontSize: 16, color: 'var(--color-text-secondary)', marginBottom: 24 }}>
            마음이 한결 편안해졌나요?<br />이제 집중할 준비가 됐어요.
          </p>
          <div className="game-over-actions">
            <button className="btn btn--primary" onClick={() => navigate('/training')}>
              훈련 하러 가기
            </button>
            <button className="btn btn--ghost" onClick={() => navigate('/')}>
              홈으로
            </button>
          </div>
        </div>
      </div>
    );
  }

  const stepColors: Record<BreathStep, string> = {
    inhale: '#6C63FF',
    hold: '#FFB020',
    exhale: '#00C9A7',
    rest: '#9CA3AF',
  };

  return (
    <div className="page page--game breathing-page">
      <div className="breathing-center">
        <p className="breathing-cycle">사이클 {cycle + 1}/{TOTAL_CYCLES}</p>
        <div className="breathing-circle-wrap">
          <div
            className="breathing-circle"
            style={{
              transform: `scale(${scale})`,
              background: stepColors[currentStep.step],
            }}
          />
        </div>
        <h2 className="breathing-label">{currentStep.label}</h2>
        <p className="breathing-step-name">
          {currentStep.step === 'inhale' && '들이쉬기 (4초)'}
          {currentStep.step === 'hold' && '참기 (4초)'}
          {currentStep.step === 'exhale' && '내쉬기 (6초)'}
          {currentStep.step === 'rest' && '쉬기 (2초)'}
        </p>
      </div>
    </div>
  );
}
