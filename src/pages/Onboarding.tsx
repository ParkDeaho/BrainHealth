import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useProfile } from '../store/useStore';
import type { UserMode, AgeGroup, Gender } from '../types';

const modes: { value: UserMode; icon: string; title: string; desc: string }[] = [
  { value: 'senior', icon: '🧠', title: '기억력 / 예방 모드', desc: '중장년층 · 기억력 관리 · 인지 예방' },
  { value: 'student', icon: '🎯', title: '집중력 / 학습 모드', desc: '학생 · 집중력 강화 · 공부 루틴' },
  { value: 'general', icon: '💡', title: '통합 모드', desc: '일반 · 전반적 뇌 컨디션 관리' },
];

const goals: { value: 'memory' | 'focus' | 'routine'; label: string; icon: string }[] = [
  { value: 'memory', label: '기억력 관리', icon: '🧠' },
  { value: 'focus', label: '집중력 향상', icon: '🎯' },
  { value: 'routine', label: '생활습관 개선', icon: '🌿' },
];

export default function Onboarding() {
  const navigate = useNavigate();
  const { saveProfile } = useProfile();

  const [step, setStep] = useState(0);
  const [mode, setMode] = useState<UserMode>('general');
  const [nickname, setNickname] = useState('');
  const [birthYear, setBirthYear] = useState<number | ''>('');
  const [gender, setGender] = useState<Gender>('other');
  const [goal, setGoal] = useState<'memory' | 'focus' | 'routine'>('routine');

  const handleComplete = () => {
    let ag: AgeGroup = '30s';
    if (birthYear) {
      const age = new Date().getFullYear() - birthYear;
      if (age < 20) ag = '10s';
      else if (age < 30) ag = '20s';
      else if (age < 40) ag = '30s';
      else if (age < 50) ag = '40s';
      else if (age < 60) ag = '50s';
      else ag = '60s+';
    }
    saveProfile({ nickname: nickname.trim() || '사용자', birthYear: birthYear || undefined, gender, ageGroup: ag, mode, targetGoal: goal });
    navigate('/');
  };

  // Step 0: Welcome
  if (step === 0) {
    return (
      <div className="page onboarding">
        <div className="onboarding-content">
          <span className="onboarding-logo">🧠</span>
          <h1>나의 뇌 건강</h1>
          <p className="onboarding-tagline">뇌 건강은 매일의 습관에서 시작됩니다</p>
          <p className="onboarding-sub">기억력, 집중력, 반응 속도를 가볍게<br />확인하고 관리하세요</p>
          <div className="onboarding-features">
            <div className="onboarding-feature"><span>📋</span><span>가볍게 측정</span></div>
            <div className="onboarding-feature"><span>🎮</span><span>재미있게 훈련</span></div>
            <div className="onboarding-feature"><span>📊</span><span>변화를 추적</span></div>
          </div>
          <button className="btn btn--primary btn--large" onClick={() => setStep(1)}>시작하기</button>
        </div>
      </div>
    );
  }

  // Step 1: Mode select
  if (step === 1) {
    return (
      <div className="page onboarding">
        <div className="onboarding-content">
          <h2>원하는 모드를 선택하세요</h2>
          <p className="onboarding-sub">나중에 변경할 수 있어요</p>
          <div className="onboarding-modes">
            {modes.map(m => (
              <button key={m.value} className={`onboarding-mode-card ${mode === m.value ? 'onboarding-mode-card--active' : ''}`} onClick={() => setMode(m.value)}>
                <span className="onboarding-mode-icon">{m.icon}</span>
                <div><h3>{m.title}</h3><p>{m.desc}</p></div>
              </button>
            ))}
          </div>
          <button className="btn btn--primary btn--large" onClick={() => setStep(2)}>다음</button>
        </div>
      </div>
    );
  }

  // Step 2: Profile
  if (step === 2) {
    return (
      <div className="page onboarding">
        <div className="onboarding-content">
          <h2>프로필을 입력해주세요</h2>
          <div className="onboarding-field">
            <label>닉네임</label>
            <input type="text" value={nickname} onChange={e => setNickname(e.target.value)} placeholder="닉네임" maxLength={20} autoFocus />
          </div>
          <div className="onboarding-field">
            <label>출생년도 (선택)</label>
            <input type="number" value={birthYear} onChange={e => setBirthYear(e.target.value ? parseInt(e.target.value) : '')} placeholder="예: 1985" min={1930} max={2020} />
          </div>
          <div className="onboarding-field">
            <label>성별</label>
            <div className="onboarding-age-grid">
              {([['male', '남성'], ['female', '여성'], ['other', '기타']] as const).map(([v, l]) => (
                <button key={v} className={`onboarding-age-btn ${gender === v ? 'onboarding-age-btn--active' : ''}`} onClick={() => setGender(v)}>{l}</button>
              ))}
            </div>
          </div>
          <button className="btn btn--primary btn--large" onClick={() => setStep(3)}>다음</button>
        </div>
      </div>
    );
  }

  // Step 3: Goal
  return (
    <div className="page onboarding">
      <div className="onboarding-content">
        <h2>목표를 선택하세요</h2>
        <p className="onboarding-sub">가장 관심 있는 영역을 하나 골라주세요</p>
        <div className="onboarding-modes">
          {goals.map(g => (
            <button key={g.value} className={`onboarding-mode-card ${goal === g.value ? 'onboarding-mode-card--active' : ''}`} onClick={() => setGoal(g.value)}>
              <span className="onboarding-mode-icon">{g.icon}</span>
              <div><h3>{g.label}</h3></div>
            </button>
          ))}
        </div>
        <button className="btn btn--primary btn--large" onClick={handleComplete}>완료! 시작하기 🚀</button>
      </div>
    </div>
  );
}
