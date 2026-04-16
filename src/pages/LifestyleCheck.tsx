import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useDailyCondition } from '../store/useStore';

interface ConditionStep {
  key: string;
  label: string;
  icon: string;
  type: 'slider' | 'toggle' | 'number' | 'text';
  min?: number;
  max?: number;
  unit?: string;
  options?: string[];
  hint?: string;
}

const steps: ConditionStep[] = [
  { key: 'sleepHours', label: '어젯밤 수면 시간', icon: '🛏️', type: 'number', min: 0, max: 14, unit: '시간' },
  { key: 'sleepQuality', label: '수면 만족도', icon: '😴', type: 'slider', min: 1, max: 5 },
  { key: 'stressLevel', label: '스트레스 체감', icon: '😰', type: 'slider', min: 1, max: 5 },
  { key: 'moodLevel', label: '오늘 기분은 어떤가요?', icon: '😊', type: 'slider', min: 1, max: 5 },
  { key: 'anxietyLevel', label: '마음이 불안하거나 긴장되나요?', icon: '🫧', type: 'slider', min: 1, max: 5 },
  { key: 'motivationLevel', label: '오늘 의욕은 어떤가요?', icon: '✨', type: 'slider', min: 1, max: 5 },
  { key: 'fatigueLevel', label: '피로도', icon: '⚡', type: 'slider', min: 1, max: 5 },
  { key: 'exerciseYn', label: '오늘 운동 여부', icon: '🏃', type: 'toggle' },
  { key: 'screenTimeMin', label: '하루 스마트폰 사용', icon: '📱', type: 'number', min: 0, max: 600, unit: '분' },
  { key: 'emotionNote', label: '한 줄 메모 (선택)', icon: '📝', type: 'text', hint: '오늘 마음이나 상황을 짧게 남겨보세요' },
];

const sliderEmojis: Record<string, string[]> = {
  sleepQuality: ['😫', '😕', '😐', '🙂', '😴'],
  stressLevel: ['😌', '🙂', '😐', '😰', '🤯'],
  moodLevel: ['😢', '😕', '😐', '🙂', '😄'],
  anxietyLevel: ['😌', '🙂', '😐', '😟', '😣'],
  motivationLevel: ['😮‍💨', '😕', '😐', '💪', '🔥'],
  fatigueLevel: ['💪', '🙂', '😐', '😩', '🥵'],
};

export default function LifestyleCheck() {
  const navigate = useNavigate();
  const { addCondition, getTodayCondition } = useDailyCondition();
  const existing = getTodayCondition();

  const [step, setStep] = useState(0);
  const [values, setValues] = useState<Record<string, number | boolean | string>>({
    sleepHours: existing?.sleepHours ?? 7,
    sleepQuality: existing?.sleepQuality ?? 3,
    stressLevel: existing?.stressLevel ?? 3,
    moodLevel: existing?.moodLevel ?? 3,
    anxietyLevel: existing?.anxietyLevel ?? 3,
    motivationLevel: existing?.motivationLevel ?? 3,
    fatigueLevel: existing?.fatigueLevel ?? 3,
    exerciseYn: existing?.exerciseYn ?? false,
    screenTimeMin: existing?.screenTimeMin ?? 120,
    emotionNote: existing?.emotionNote ?? '',
  });
  const [done, setDone] = useState(false);

  const current = steps[step];
  const progress = ((step + 1) / steps.length) * 100;

  const handleNext = () => {
    if (step < steps.length - 1) {
      setStep(s => s + 1);
    } else {
      addCondition({
        sleepHours: values.sleepHours as number,
        sleepQuality: values.sleepQuality as number,
        stressLevel: values.stressLevel as number,
        moodLevel: values.moodLevel as number,
        anxietyLevel: values.anxietyLevel as number,
        motivationLevel: values.motivationLevel as number,
        fatigueLevel: values.fatigueLevel as number,
        exerciseYn: values.exerciseYn as boolean,
        screenTimeMin: values.screenTimeMin as number,
        focusTimeMin: 0,
        emotionNote: String(values.emotionNote ?? '').slice(0, 200),
        mindCheckCompleted: true,
      });
      setDone(true);
    }
  };

  if (done) {
    return (
      <div className="page page--questionnaire questionnaire-done">
        <div className="questionnaire-done-content">
          <span className="questionnaire-done-emoji">✅</span>
          <h2>생활습관 체크 완료!</h2>
          <p className="questionnaire-score-desc">
            마음·생활 기록은 리포트에서<br />인지 점수 해석에 활용돼요. (건강 진단이 아닌 참고용 기록입니다)
          </p>
          <div className="questionnaire-done-actions">
            <button className="btn btn--primary btn--large" onClick={() => navigate('/tests')}>
              인지 테스트 하기 →
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
    <div className="page page--questionnaire">
      <header className="questionnaire-header">
        <button className="questionnaire-back" onClick={() => step > 0 ? setStep(s => s - 1) : navigate(-1)}>
          ← {step > 0 ? '이전' : '돌아가기'}
        </button>
        <span className="questionnaire-count">{step + 1} / {steps.length}</span>
      </header>

      <div className="questionnaire-progress-bar">
        <div className="questionnaire-progress-fill" style={{ width: `${progress}%` }} />
      </div>

      <div className="questionnaire-body">
        <span className="checkin-question-icon">{current.icon}</span>
        <h2 className="questionnaire-question">{current.label}</h2>
        {current.hint && <p className="questionnaire-hint">{current.hint}</p>}

        {current.type === 'text' && (
          <textarea
            className="mind-note-input"
            rows={3}
            maxLength={200}
            placeholder="선택 사항입니다"
            value={String(values.emotionNote ?? '')}
            onChange={e => setValues(prev => ({ ...prev, emotionNote: e.target.value }))}
          />
        )}

        {current.type === 'slider' && (
          <>
            <div className="lifestyle-emojis">
              {(sliderEmojis[current.key] || ['1', '2', '3', '4', '5']).map((emoji, i) => (
                <button
                  key={i}
                  className={`checkin-emoji-btn ${values[current.key] === i + 1 ? 'checkin-emoji-btn--selected' : ''}`}
                  onClick={() => setValues(prev => ({ ...prev, [current.key]: i + 1 }))}
                >
                  <span className="checkin-emoji">{emoji}</span>
                  <span className="checkin-emoji-num">{i + 1}</span>
                </button>
              ))}
            </div>
            <div className="checkin-labels">
              <span>낮음</span><span>높음</span>
            </div>
          </>
        )}

        {current.type === 'number' && (
          <div className="lifestyle-number">
            <button
              className="lifestyle-number-btn"
              onClick={() => setValues(prev => ({ ...prev, [current.key]: Math.max(current.min ?? 0, (prev[current.key] as number) - (current.key === 'screenTimeMin' ? 30 : 0.5)) }))}
            >
              −
            </button>
            <div className="lifestyle-number-display">
              <span className="lifestyle-number-value">{values[current.key] as number}</span>
              <span className="lifestyle-number-unit">{current.unit}</span>
            </div>
            <button
              className="lifestyle-number-btn"
              onClick={() => setValues(prev => ({ ...prev, [current.key]: Math.min(current.max ?? 999, (prev[current.key] as number) + (current.key === 'screenTimeMin' ? 30 : 0.5)) }))}
            >
              +
            </button>
          </div>
        )}

        {current.type === 'toggle' && (
          <div className="lifestyle-toggle">
            <button
              className={`lifestyle-toggle-btn ${values[current.key] === true ? 'lifestyle-toggle-btn--active' : ''}`}
              onClick={() => setValues(prev => ({ ...prev, [current.key]: true }))}
            >
              ✅ 했어요
            </button>
            <button
              className={`lifestyle-toggle-btn ${values[current.key] === false ? 'lifestyle-toggle-btn--active' : ''}`}
              onClick={() => setValues(prev => ({ ...prev, [current.key]: false }))}
            >
              ❌ 안 했어요
            </button>
          </div>
        )}
      </div>

      <footer className="checkin-footer">
        <button className="btn btn--primary" style={{ flex: 1 }} onClick={handleNext}>
          {step < steps.length - 1 ? '다음' : '완료'}
        </button>
      </footer>
    </div>
  );
}
