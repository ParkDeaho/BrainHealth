import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useQuestionnaires, useProfile } from '../store/useStore';
import type { QuestionCategory } from '../types';

interface QItem { id: string; text: string }

const seniorQuestions: QItem[] = [
  { id: 'sm1', text: '최근 약속이나 일정을 자주 잊는다' },
  { id: 'sm2', text: '같은 말을 반복한다는 말을 들은 적이 있다' },
  { id: 'sm3', text: '물건 둔 곳을 자주 찾는다' },
  { id: 'sm4', text: '익숙한 단어가 잘 떠오르지 않는다' },
  { id: 'sm5', text: '길이나 순서를 헷갈린다' },
  { id: 'sm6', text: '최근 집중이 예전보다 어렵다' },
  { id: 'sm7', text: '일상 업무 처리 속도가 느려졌다고 느낀다' },
];

const studentQuestions: QItem[] = [
  { id: 'sf1', text: '공부 중 쉽게 딴생각이 난다' },
  { id: 'sf2', text: '한 과목을 오래 집중하기 어렵다' },
  { id: 'sf3', text: '숙제를 미루는 편이다' },
  { id: 'sf4', text: '실수가 잦다' },
  { id: 'sf5', text: '설명을 듣다 놓치는 경우가 있다' },
  { id: 'sf6', text: '잠이 부족한 날 집중이 많이 떨어진다' },
  { id: 'sf7', text: '스마트폰 때문에 흐름이 자주 끊긴다' },
];

const scaleLabels = ['전혀 아니다', '가끔', '종종', '매우 자주'];

function getSeniorInterpretation(score: number) {
  if (score <= 5) return { label: '큰 불편 없음', emoji: '🌟', color: 'var(--color-success)', desc: '인지 기능이 안정적이에요.' };
  if (score <= 10) return { label: '가벼운 변화 체감', emoji: '👍', color: 'var(--color-primary)', desc: '약간의 변화가 있지만 정상 범위예요.' };
  if (score <= 15) return { label: '지속 관찰 필요', emoji: '⚠️', color: 'var(--color-warning)', desc: '인지 변화 체감이 있어요. 꾸준한 측정을 권장해요.' };
  return { label: '생활 관리 권장', emoji: '🔔', color: 'var(--color-danger)', desc: '집중/기억 관리가 필요해요. 생활 습관 점검을 추천해요.' };
}

function getStudentInterpretation(score: number) {
  if (score <= 5) return { label: '집중력 양호', emoji: '🌟', color: 'var(--color-success)', desc: '집중 상태가 좋은 편이에요!' };
  if (score <= 10) return { label: '보통', emoji: '👍', color: 'var(--color-primary)', desc: '가끔 집중이 흐트러지지만 괜찮아요.' };
  if (score <= 15) return { label: '관리 필요', emoji: '⚠️', color: 'var(--color-warning)', desc: '주의 지속력이 약한 편이에요. 루틴 점검을 해보세요.' };
  return { label: '적극 관리', emoji: '🔔', color: 'var(--color-danger)', desc: '충동성 경향과 루틴 불안정이 보여요. 수면과 스마트폰 습관을 확인하세요.' };
}

export default function Questionnaire() {
  const navigate = useNavigate();
  const { addResult, getTodayByCategory } = useQuestionnaires();
  const { profile } = useProfile();

  const isSenior = profile?.mode === 'senior';
  const category: QuestionCategory = isSenior ? 'memory' : 'focus';
  const questions = isSenior ? seniorQuestions : studentQuestions;
  const existing = getTodayByCategory(category);

  const [step, setStep] = useState(0);
  const [answers, setAnswers] = useState<Record<string, number>>(existing?.answers ?? {});
  const [done, setDone] = useState(false);
  const [totalScore, setTotalScore] = useState(0);

  const current = questions[step];
  const progress = ((step + 1) / questions.length) * 100;

  const handleSelect = (value: number) => {
    const updated = { ...answers, [current.id]: value };
    setAnswers(updated);

    if (step < questions.length - 1) {
      setTimeout(() => setStep(s => s + 1), 250);
    } else {
      const total = Object.values(updated).reduce((s, v) => s + v, 0);
      setTotalScore(total);
      addResult(category, updated, total, questions.length * 3);
      setDone(true);
    }
  };

  if (done) {
    const interp = isSenior ? getSeniorInterpretation(totalScore) : getStudentInterpretation(totalScore);
    return (
      <div className="page page--questionnaire questionnaire-done">
        <div className="questionnaire-done-content">
          <span className="questionnaire-done-emoji">{interp.emoji}</span>
          <h2>문진 완료</h2>
          <div className="questionnaire-score-card" style={{ borderColor: interp.color }}>
            <p className="questionnaire-score-label">
              {isSenior ? '기억력 자가 인식' : '집중력 자가 인식'}
            </p>
            <p className="questionnaire-score-value" style={{ color: interp.color }}>
              {totalScore}점 · {interp.label}
            </p>
            <p className="questionnaire-score-desc">{interp.desc}</p>
          </div>
          <p className="questionnaire-note">
            ※ 이 결과는 의학적 진단이 아닌, 자가 인식 기반 체크입니다.
          </p>
          <div className="questionnaire-done-actions">
            <button className="btn btn--primary btn--large" onClick={() => navigate('/questionnaire/lifestyle')}>
              생활습관 체크 →
            </button>
            <button className="btn btn--ghost" onClick={() => navigate('/tests')}>
              테스트 하러 가기
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
        <span className="questionnaire-count">{step + 1} / {questions.length}</span>
      </header>

      <div className="questionnaire-progress-bar">
        <div className="questionnaire-progress-fill" style={{ width: `${progress}%` }} />
      </div>

      <div className="questionnaire-body">
        <p className="questionnaire-category-badge">
          {isSenior ? '🧠 기억력 문진' : '🎯 집중력 문진'}
        </p>
        <h2 className="questionnaire-question">{current.text}</h2>
        <div className="questionnaire-options">
          {scaleLabels.map((label, i) => (
            <button
              key={i}
              className={`questionnaire-option ${answers[current.id] === i ? 'questionnaire-option--selected' : ''}`}
              onClick={() => handleSelect(i)}
            >
              <span className="questionnaire-option-dot">{answers[current.id] === i ? '●' : '○'}</span>
              <span className="questionnaire-option-label">{label}</span>
              <span className="questionnaire-option-num">{i}점</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
