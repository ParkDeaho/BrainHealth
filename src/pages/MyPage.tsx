import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useProfile, useTestResults, useGameResults, useAdRewards } from '../store/useStore';
import { APP_VERSION } from '../services/versionCheck';
import type { UserMode, AgeGroup, Gender } from '../types';

const modeLabels: Record<UserMode, string> = { senior: '기억력/예방', student: '집중력/학습', general: '통합' };
const ageLabels: Record<AgeGroup, string> = { '10s': '10대', '20s': '20대', '30s': '30대', '40s': '40대', '50s': '50대', '60s+': '60대+' };
const genderLabels: Record<Gender, string> = { male: '남성', female: '여성', other: '기타' };
const modes: { value: UserMode; label: string }[] = [
  { value: 'senior', label: '기억력/예방' },
  { value: 'student', label: '집중력/학습' },
  { value: 'general', label: '통합' },
];
const goalOptions: { value: 'memory' | 'focus' | 'routine'; label: string }[] = [
  { value: 'memory', label: '기억력 관리' },
  { value: 'focus', label: '집중력 향상' },
  { value: 'routine', label: '생활습관 개선' },
];
const goalLabels: Record<string, string> = { memory: '기억력 관리', focus: '집중력 향상', routine: '생활습관 개선' };

export default function MyPage() {
  const navigate = useNavigate();
  const { profile, saveProfile } = useProfile();
  const { results } = useTestResults();
  const { gameResults } = useGameResults();
  const { todayRewardCount } = useAdRewards();

  const [editing, setEditing] = useState(!profile);
  const [nickname, setNickname] = useState(profile?.nickname ?? '');
  const [mode, setMode] = useState<UserMode>(profile?.mode ?? 'general');
  const [ageGroup, setAgeGroup] = useState<AgeGroup>(profile?.ageGroup ?? '30s');
  const [birthYear, setBirthYear] = useState<number | ''>(profile?.birthYear ?? '');
  const [gender, setGender] = useState<Gender>(profile?.gender ?? 'other');
  const [goal, setGoal] = useState<'memory' | 'focus' | 'routine'>(profile?.targetGoal ?? 'routine');

  const handleSave = () => {
    if (!nickname.trim()) return;
    saveProfile({
      nickname: nickname.trim(),
      birthYear: birthYear || undefined,
      gender,
      ageGroup,
      mode,
      targetGoal: goal,
    });
    setEditing(false);
  };

  const totalTests = results.length;
  const totalGames = gameResults.length;
  const bestScore = results.length > 0 ? Math.max(...results.map(r => r.score)) : 0;

  return (
    <div className="page page--mypage">
      <header className="page-header"><h1>마이페이지</h1></header>

      <section className="card mypage-profile-card">
        {editing ? (
          <div className="mypage-edit">
            <div className="mypage-avatar">🧠</div>
            <div className="mypage-field">
              <label>닉네임</label>
              <input type="text" value={nickname} onChange={e => setNickname(e.target.value)} placeholder="닉네임" maxLength={20} />
            </div>
            <div className="mypage-field">
              <label>출생년도</label>
              <input type="number" value={birthYear} onChange={e => setBirthYear(e.target.value ? parseInt(e.target.value) : '')} placeholder="예: 1985" />
            </div>
            <div className="mypage-field">
              <label>성별</label>
              <div className="mypage-age-group">
                {(['male', 'female', 'other'] as const).map(g => (
                  <button key={g} className={`mypage-age-btn ${gender === g ? 'mypage-age-btn--active' : ''}`} onClick={() => setGender(g)}>{genderLabels[g]}</button>
                ))}
              </div>
            </div>
            <div className="mypage-field">
              <label>서비스 모드</label>
              <div className="mypage-age-group">
                {modes.map(m => (
                  <button key={m.value} className={`mypage-age-btn ${mode === m.value ? 'mypage-age-btn--active' : ''}`} onClick={() => setMode(m.value)}>{m.label}</button>
                ))}
              </div>
            </div>
            <div className="mypage-field">
              <label>연령대</label>
              <div className="mypage-age-group">
                {Object.entries(ageLabels).map(([v, l]) => (
                  <button key={v} className={`mypage-age-btn ${ageGroup === v ? 'mypage-age-btn--active' : ''}`} onClick={() => setAgeGroup(v as AgeGroup)}>{l}</button>
                ))}
              </div>
            </div>
            <div className="mypage-field">
              <label>목표</label>
              <div className="mypage-age-group">
                {goalOptions.map(g => (
                  <button key={g.value} className={`mypage-age-btn ${goal === g.value ? 'mypage-age-btn--active' : ''}`} onClick={() => setGoal(g.value)}>{g.label}</button>
                ))}
              </div>
            </div>
            <button className="btn btn--primary" onClick={handleSave} disabled={!nickname.trim()}>저장</button>
          </div>
        ) : (
          <div className="mypage-info">
            <div className="mypage-avatar">🧠</div>
            <h2>{profile?.nickname}</h2>
            <p className="mypage-age">
              {ageLabels[profile?.ageGroup ?? '30s']} · {genderLabels[profile?.gender ?? 'other']} · {modeLabels[profile?.mode ?? 'general']} 모드
            </p>
            <p className="mypage-goal">🎯 {goalLabels[profile?.targetGoal ?? 'routine']}</p>
            {profile?.streakDays && profile.streakDays > 0 && (
              <p className="mypage-streak">🔥 {profile.streakDays}일 연속 사용</p>
            )}
            <button className="btn btn--ghost btn--small" onClick={() => setEditing(true)}>수정</button>
          </div>
        )}
      </section>

      <section className="card mypage-stats-card">
        <h3 className="card-title">활동 통계</h3>
        <div className="mypage-stats">
          <div className="mypage-stat"><span className="mypage-stat-value">{totalTests}</span><span className="mypage-stat-label">테스트</span></div>
          <div className="mypage-stat"><span className="mypage-stat-value">{totalGames}</span><span className="mypage-stat-label">훈련</span></div>
          <div className="mypage-stat"><span className="mypage-stat-value">{bestScore}</span><span className="mypage-stat-label">최고점수</span></div>
        </div>
      </section>

      <section className="card">
        <h3 className="card-title">설정</h3>
        <div className="mypage-settings">
          <div className="mypage-setting-row"><span>🔔 알림 설정</span><span className="mypage-setting-badge">준비중</span></div>
          <button className="mypage-setting-row" onClick={() => navigate('/guardian')}>
            <span>👨‍👩‍👧 보호자 연결</span><span>→</span>
          </button>
          <div className="mypage-setting-row">
            <span>🎬 광고 보상</span>
            <span className="mypage-setting-badge">오늘 {todayRewardCount}회</span>
          </div>
          <div className="mypage-setting-row"><span>📱 기기/센서 연동</span><span className="mypage-setting-badge">준비중</span></div>
          <div className="mypage-setting-row"><span>🏢 키오스크 연동</span><span className="mypage-setting-badge">준비중</span></div>
          <div className="mypage-setting-row"><span>📜 이용약관</span><span>→</span></div>
          <div className="mypage-setting-row"><span>💬 문의하기</span><span>→</span></div>
          <div className="mypage-setting-row">
            <span>앱 버전</span>
            <span className="mypage-setting-badge">{APP_VERSION}</span>
          </div>
          <button
            className="mypage-setting-row mypage-setting-row--danger"
            onClick={() => { if (confirm('모든 데이터를 초기화할까요?')) { localStorage.clear(); window.location.reload(); } }}
          >
            <span>🗑️ 데이터 초기화</span>
          </button>
        </div>
      </section>
    </div>
  );
}
