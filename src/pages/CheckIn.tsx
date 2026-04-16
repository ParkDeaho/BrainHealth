import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useCheckIns } from '../store/useStore';
import type { CheckInField } from '../types';

interface CheckInOption {
  field: CheckInField;
  label: string;
  icon: string;
  question: string;
  lowLabel: string;
  highLabel: string;
}

const questions: CheckInOption[] = [
  {
    field: 'sleep',
    label: '수면',
    icon: '😴',
    question: '어젯밤 수면은 어땠나요?',
    lowLabel: '나빴어요',
    highLabel: '아주 좋았어요',
  },
  {
    field: 'focus',
    label: '집중',
    icon: '🎯',
    question: '오늘 집중이 잘 되나요?',
    lowLabel: '전혀 안 돼요',
    highLabel: '완전 집중!',
  },
  {
    field: 'fatigue',
    label: '피로',
    icon: '⚡',
    question: '피로감이 있나요?',
    lowLabel: '거뜬해요',
    highLabel: '매우 피곤해요',
  },
  {
    field: 'mood',
    label: '기분',
    icon: '😊',
    question: '기분은 어떤가요?',
    lowLabel: '우울해요',
    highLabel: '아주 좋아요',
  },
];

const emojiScale: Record<CheckInField, string[]> = {
  sleep: ['😫', '😕', '😐', '🙂', '😴'],
  focus: ['🌫️', '😶', '😐', '🎯', '🔥'],
  fatigue: ['💪', '🙂', '😐', '😩', '🥵'],
  mood: ['😢', '😕', '😐', '🙂', '😄'],
};

export default function CheckIn() {
  const navigate = useNavigate();
  const { addCheckIn, getTodayCheckIn } = useCheckIns();
  const existing = getTodayCheckIn();

  const [step, setStep] = useState(0);
  const [values, setValues] = useState<Record<CheckInField, number>>({
    sleep: existing?.sleep ?? 3,
    focus: existing?.focus ?? 3,
    fatigue: existing?.fatigue ?? 3,
    mood: existing?.mood ?? 3,
  });
  const [done, setDone] = useState(false);

  const current = questions[step];

  const handleSelect = (value: number) => {
    setValues(prev => ({ ...prev, [current.field]: value }));
  };

  const handleNext = () => {
    if (step < questions.length - 1) {
      setStep(s => s + 1);
    } else {
      addCheckIn(values);
      setDone(true);
    }
  };

  const handleBack = () => {
    if (step > 0) setStep(s => s - 1);
  };

  if (done) {
    const score = Math.round(
      ((values.sleep + values.focus + (6 - values.fatigue) + values.mood) / 20) * 100
    );
    return (
      <div className="page page--checkin checkin-done">
        <div className="checkin-done-content">
          <span className="checkin-done-emoji">
            {score >= 70 ? '🌟' : score >= 40 ? '💪' : '🫂'}
          </span>
          <h2>체크인 완료!</h2>
          <p className="checkin-done-score">
            오늘의 뇌 컨디션: <strong>{score}점</strong>
          </p>
          <p className="checkin-done-msg">
            {score >= 70
              ? '컨디션이 좋아요! 두뇌 훈련 해볼까요?'
              : score >= 40
                ? '오늘도 꾸준히 관리하면 좋아져요!'
                : '쉬어가는 것도 뇌 건강이에요 🤗'}
          </p>
          <div className="checkin-done-actions">
            <button className="btn btn--primary" onClick={() => navigate('/training')}>
              두뇌 훈련 하기
            </button>
            <button className="btn btn--ghost" onClick={() => navigate('/')}>
              홈으로
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="page page--checkin">
      <header className="checkin-header">
        <div className="checkin-progress">
          {questions.map((_, i) => (
            <div
              key={i}
              className={`checkin-progress-dot ${i <= step ? 'checkin-progress-dot--active' : ''}`}
            />
          ))}
        </div>
        <p className="checkin-step">{step + 1} / {questions.length}</p>
      </header>

      <div className="checkin-body">
        <span className="checkin-question-icon">{current.icon}</span>
        <h2 className="checkin-question">{current.question}</h2>

        <div className="checkin-emojis">
          {emojiScale[current.field].map((emoji, i) => (
            <button
              key={i}
              className={`checkin-emoji-btn ${values[current.field] === i + 1 ? 'checkin-emoji-btn--selected' : ''}`}
              onClick={() => handleSelect(i + 1)}
            >
              <span className="checkin-emoji">{emoji}</span>
              <span className="checkin-emoji-num">{i + 1}</span>
            </button>
          ))}
        </div>

        <div className="checkin-labels">
          <span>{current.lowLabel}</span>
          <span>{current.highLabel}</span>
        </div>
      </div>

      <footer className="checkin-footer">
        {step > 0 && (
          <button className="btn btn--ghost" onClick={handleBack}>이전</button>
        )}
        <button className="btn btn--primary" onClick={handleNext}>
          {step < questions.length - 1 ? '다음' : '완료'}
        </button>
      </footer>
    </div>
  );
}
