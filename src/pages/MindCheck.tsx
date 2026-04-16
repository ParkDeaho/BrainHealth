import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useDailyCondition } from '../store/useStore';

/** 의욕 3단계 → DB 1·3·5 */
const MOTIVATION_TIERS = [
  { emoji: '😴', label: '거의 없음', value: 1 as const },
  { emoji: '🙂', label: '보통', value: 3 as const },
  { emoji: '🔥', label: '매우 높음', value: 5 as const },
];

const MOOD_OPTIONS = [
  { score: 5, emoji: '😄', label: '매우 좋음' },
  { score: 4, emoji: '🙂', label: '좋음' },
  { score: 3, emoji: '😐', label: '보통' },
  { score: 2, emoji: '😟', label: '나쁨' },
  { score: 1, emoji: '😣', label: '매우 나쁨' },
];

function motivationFromStored(m: number): number {
  if (m <= 2) return 1;
  if (m >= 4) return 5;
  return 3;
}

function deriveAnxiety(mood: number, stress: number): number {
  return Math.min(5, Math.max(1, Math.round((stress + (6 - mood)) / 2)));
}

export default function MindCheck() {
  const navigate = useNavigate();
  const { upsertTodayCondition, getTodayCondition } = useDailyCondition();
  const existing = getTodayCondition();

  const [step, setStep] = useState(0);
  const [moodLevel, setMoodLevel] = useState(existing?.moodLevel ?? 3);
  const [stressLevel, setStressLevel] = useState(existing?.stressLevel ?? 3);
  const [motivationLevel, setMotivationLevel] = useState(motivationFromStored(existing?.motivationLevel ?? 3));
  const [note, setNote] = useState(existing?.emotionNote ?? '');
  const [done, setDone] = useState(false);

  const totalSteps = 4;
  const progress = ((step + 1) / totalSteps) * 100;

  const finish = () => {
    upsertTodayCondition({
      moodLevel,
      stressLevel,
      anxietyLevel: deriveAnxiety(moodLevel, stressLevel),
      motivationLevel,
      emotionNote: note.trim().slice(0, 200),
      mindCheckCompleted: true,
    });
    setDone(true);
  };

  if (done) {
    return (
      <div className="page page--mind mind-done">
        <div className="mind-done-content">
          <span className="mind-done-emoji">💚</span>
          <h2>기록 완료!</h2>
          <p className="mind-done-desc">
            오늘의 마음 컨디션은 리포트와 추천에 반영돼요.<br />
            <small>(이 기록은 진단이 아니라 참고용 패턴 분석에 쓰입니다)</small>
          </p>
          <div className="mind-done-actions">
            <button type="button" className="btn btn--primary btn--large" onClick={() => navigate('/report')}>
              리포트 보기
            </button>
            <button type="button" className="btn btn--ghost" onClick={() => navigate('/')}>
              홈으로
            </button>
          </div>
        </div>
      </div>
    );
  }

  const goBack = () => {
    if (step > 0) setStep(s => s - 1);
    else navigate(-1);
  };

  return (
    <div className="page page--mind">
      <header className="mind-header">
        <button type="button" className="mind-back" onClick={goBack}>
          ← {step > 0 ? '이전' : '닫기'}
        </button>
        <span className="mind-count">{step + 1} / {totalSteps}</span>
      </header>
      <div className="mind-progress-bar">
        <div className="mind-progress-fill" style={{ width: `${progress}%` }} />
      </div>

      {step === 0 && (
        <div className="mind-body">
          <p className="mind-step-tag">Step 1. 기분</p>
          <span className="mind-icon">😊</span>
          <h2 className="mind-question">오늘 기분은 어떤가요?</h2>
          <div className="mind-mood-list">
            {MOOD_OPTIONS.map(opt => (
              <button
                key={opt.score}
                type="button"
                className={`mind-mood-row ${moodLevel === opt.score ? 'mind-mood-row--on' : ''}`}
                onClick={() => setMoodLevel(opt.score)}
              >
                <span className="mind-mood-emoji">{opt.emoji}</span>
                <span className="mind-mood-label">{opt.label}</span>
              </button>
            ))}
          </div>
        </div>
      )}

      {step === 1 && (
        <div className="mind-body">
          <p className="mind-step-tag">Step 2. 스트레스</p>
          <span className="mind-icon">😰</span>
          <h2 className="mind-question">오늘 스트레스 정도는?</h2>
          <p className="mind-hint">1 · · · · 5 (낮음 ~ 매우 높음)</p>
          <div className="mind-slider-wrap">
            <input
              type="range"
              className="mind-slider"
              min={1}
              max={5}
              step={1}
              value={stressLevel}
              onChange={e => setStressLevel(Number(e.target.value))}
            />
            <div className="mind-slider-ticks">
              {[1, 2, 3, 4, 5].map(n => (
                <span key={n} className={stressLevel === n ? 'mind-tick--on' : ''}>{n}</span>
              ))}
            </div>
            <div className="mind-slider-labels">
              <span>낮음</span>
              <span>매우 높음</span>
            </div>
          </div>
        </div>
      )}

      {step === 2 && (
        <div className="mind-body">
          <p className="mind-step-tag">Step 3. 의욕</p>
          <span className="mind-icon">✨</span>
          <h2 className="mind-question">오늘 의욕은 어떤가요?</h2>
          <div className="mind-motivation-3">
            {MOTIVATION_TIERS.map(t => (
              <button
                key={t.value}
                type="button"
                className={`mind-mot-btn ${motivationLevel === t.value ? 'mind-mot-btn--on' : ''}`}
                onClick={() => setMotivationLevel(t.value)}
              >
                <span className="mind-mot-emoji">{t.emoji}</span>
                <span className="mind-mot-label">{t.label}</span>
              </button>
            ))}
          </div>
        </div>
      )}

      {step === 3 && (
        <div className="mind-body">
          <p className="mind-step-tag">Step 4. 한 줄 기록</p>
          <span className="mind-icon">📝</span>
          <h2 className="mind-question">오늘 하루를 한 줄로 남겨보세요</h2>
          <p className="mind-hint">선택 사항이에요. 적지 않아도 저장할 수 있어요.</p>
          <textarea
            className="mind-note-input mind-note-input--large"
            rows={4}
            maxLength={200}
            placeholder="예: 일이 많아서 정신이 없었음"
            value={note}
            onChange={e => setNote(e.target.value)}
          />
        </div>
      )}

      <footer className="mind-footer mind-footer--split">
        {step === 3 ? (
          <>
            <button type="button" className="btn btn--ghost" onClick={finish}>
              건너뛰기
            </button>
            <button type="button" className="btn btn--primary" onClick={finish}>
              저장하기
            </button>
          </>
        ) : (
          <button
            type="button"
            className="btn btn--primary btn--large mind-footer-full"
            onClick={() => setStep(s => s + 1)}
          >
            다음
          </button>
        )}
      </footer>
    </div>
  );
}
