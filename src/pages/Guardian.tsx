import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useGuardians } from '../store/useStore';

export default function Guardian() {
  const navigate = useNavigate();
  const { guardians, addGuardian, removeGuardian } = useGuardians();
  const [adding, setAdding] = useState(false);
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [email, setEmail] = useState('');
  const [shareSummary, setShareSummary] = useState(true);
  const [shareAlert, setShareAlert] = useState(true);

  const handleAdd = () => {
    if (!name.trim()) return;
    addGuardian({
      name: name.trim(),
      phone: phone.trim() || undefined,
      email: email.trim() || undefined,
      shareSummary,
      shareAlert,
    });
    setName('');
    setPhone('');
    setEmail('');
    setAdding(false);
  };

  return (
    <div className="page page--guardian">
      <header className="guardian-header">
        <button className="guardian-back" onClick={() => navigate(-1)}>← 뒤로</button>
        <h1 className="page-title">보호자 연결</h1>
      </header>

      <section className="card guardian-info-card">
        <h3>👨‍👩‍👧‍👦 보호자와 함께 관리하세요</h3>
        <p>가족이나 보호자에게 주간 요약 리포트를 공유할 수 있어요. 큰 변화가 있을 때 알림을 보낼 수도 있습니다.</p>
      </section>

      {guardians.map(g => (
        <section key={g.id} className="card guardian-card">
          <div className="guardian-card-header">
            <span className="guardian-avatar">👤</span>
            <div>
              <h4>{g.name}</h4>
              {g.phone && <p className="guardian-contact">{g.phone}</p>}
              {g.email && <p className="guardian-contact">{g.email}</p>}
            </div>
            <span className={`guardian-status guardian-status--${g.status}`}>
              {g.status === 'active' ? '연결됨' : '대기'}
            </span>
          </div>
          <div className="guardian-options">
            <label className="guardian-toggle">
              <span>주간 요약 공유</span>
              <span>{g.shareSummary ? '✅' : '⬜'}</span>
            </label>
            <label className="guardian-toggle">
              <span>변화 알림</span>
              <span>{g.shareAlert ? '✅' : '⬜'}</span>
            </label>
          </div>
          <div className="guardian-shared-items">
            <h5>공유 항목</h5>
            <ul>
              <li>최근 점수 변화</li>
              <li>테스트 수행 여부</li>
              <li>생활 습관 요약</li>
            </ul>
          </div>
          <button className="btn btn--outline btn--small guardian-remove" onClick={() => removeGuardian(g.id)}>연결 해제</button>
        </section>
      ))}

      {adding ? (
        <section className="card guardian-add-form">
          <h3>보호자 추가</h3>
          <div className="guardian-field">
            <label>이름 *</label>
            <input type="text" value={name} onChange={e => setName(e.target.value)} placeholder="보호자 이름" autoFocus />
          </div>
          <div className="guardian-field">
            <label>연락처</label>
            <input type="tel" value={phone} onChange={e => setPhone(e.target.value)} placeholder="010-0000-0000" />
          </div>
          <div className="guardian-field">
            <label>이메일</label>
            <input type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="guardian@email.com" />
          </div>
          <div className="guardian-toggles">
            <label className="guardian-toggle" onClick={() => setShareSummary(!shareSummary)}>
              <span>주간 요약 공유</span>
              <span>{shareSummary ? '✅' : '⬜'}</span>
            </label>
            <label className="guardian-toggle" onClick={() => setShareAlert(!shareAlert)}>
              <span>변화 시 알림</span>
              <span>{shareAlert ? '✅' : '⬜'}</span>
            </label>
          </div>
          <div className="guardian-actions">
            <button className="btn btn--primary" onClick={handleAdd}>추가</button>
            <button className="btn btn--outline" onClick={() => setAdding(false)}>취소</button>
          </div>
        </section>
      ) : (
        <button className="btn btn--primary btn--large guardian-add-btn" onClick={() => setAdding(true)}>
          + 보호자 추가
        </button>
      )}

      <section className="card guardian-notice">
        <p>⚠️ 민감 정보 보호: 보호자에게 공유되는 정보는 사용자가 직접 설정한 범위 내에서만 전달됩니다. 상세 검사 결과나 개인 메모는 공유되지 않습니다.</p>
      </section>
    </div>
  );
}
