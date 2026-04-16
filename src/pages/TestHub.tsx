import { useNavigate } from 'react-router-dom';
import { useTestResults, useQuestionnaires, useProfile } from '../store/useStore';

interface TestItem { id: string; title: string; desc: string; icon: string; path: string; time: string }

const memoryTests: TestItem[] = [
  { id: 'word-memory', title: '단어 기억', desc: '5개 단어를 기억하고 떠올리기', icon: '📝', path: '/tests/word-memory', time: '2분' },
  { id: 'digit-span', title: '숫자 역순', desc: '숫자를 거꾸로 기억하기', icon: '🔄', path: '/tests/digit-span', time: '1분' },
  { id: 'visual-pattern', title: '시각 패턴', desc: '격자에서 빛난 위치 기억', icon: '🔲', path: '/tests/visual-pattern', time: '2분' },
  { id: 'number-memory', title: '숫자 기억', desc: '점점 길어지는 숫자 기억', icon: '🔢', path: '/tests/number-memory', time: '1분' },
];

const focusTests: TestItem[] = [
  { id: 'stroop', title: '스트룹', desc: '글자의 색깔을 빠르게 선택', icon: '🎨', path: '/tests/stroop', time: '45초' },
  { id: 'cpt', title: '지속 집중 (CPT)', desc: 'X가 나오면 터치', icon: '🔤', path: '/tests/cpt', time: '1분' },
  { id: 'trail-making', title: '순서 맞추기', desc: '숫자를 순서대로 빠르게 터치', icon: '🔢', path: '/tests/trail-making', time: '1분' },
  { id: 'visual-tracking', title: '시각 추적', desc: '움직이는 공을 눈으로 추적', icon: '👁️', path: '/tests/visual-tracking', time: '2분' },
];

const speedTests: TestItem[] = [
  { id: 'reaction-speed', title: '반응 속도', desc: '화면이 바뀌면 최대한 빠르게!', icon: '⚡', path: '/tests/reaction-speed', time: '30초' },
];

export default function TestHub() {
  const navigate = useNavigate();
  const { getTodayResults } = useTestResults();
  const { getTodayByCategory } = useQuestionnaires();
  const { profile } = useProfile();
  const todayResults = getTodayResults();

  const mainCategory = profile?.mode === 'senior' ? 'memory' : 'focus';
  const hasQ = !!getTodayByCategory(mainCategory);

  const renderGroup = (title: string, emoji: string, tests: TestItem[]) => (
    <section className="test-group" key={title}>
      <h3 className="test-group-title">{emoji} {title}</h3>
      <div className="test-group-list">
        {tests.map(test => {
          const played = todayResults.some(r => r.type === test.id);
          return (
            <button key={test.id} className="card test-card" onClick={() => navigate(test.path)}>
              <span className="test-card-icon">{test.icon}</span>
              <div className="test-card-info">
                <h4>{test.title}{played && <span className="training-done-badge">완료 ✓</span>}</h4>
                <p>{test.desc}</p>
                <span className="training-card-time">⏱ {test.time}</span>
              </div>
            </button>
          );
        })}
      </div>
    </section>
  );

  return (
    <div className="page page--testhub">
      <header className="page-header">
        <h1>인지 기능 측정</h1>
        <p className="page-subtitle">객관적으로 측정하고 변화를 추적하세요</p>
      </header>

      {!hasQ && (
        <button className="card questionnaire-cta" onClick={() => navigate('/questionnaire')}>
          <span className="questionnaire-cta-icon">📋</span>
          <div>
            <h3>문진을 먼저 해보세요</h3>
            <p>자가 인식 체크 후 테스트가 더 의미 있어요</p>
          </div>
          <span className="questionnaire-cta-arrow">→</span>
        </button>
      )}

      <div className="test-summary card">
        <span style={{ fontSize: 28 }}>📊</span>
        <div>
          <p className="test-summary-title">오늘의 테스트</p>
          <p className="test-summary-count">{todayResults.length > 0 ? `${todayResults.length}개 완료!` : '아직 시작 전'}</p>
        </div>
      </div>

      {renderGroup('기억력', '🧠', memoryTests)}
      {renderGroup('집중력', '🎯', focusTests)}
      {renderGroup('반응 속도', '⚡', speedTests)}
    </div>
  );
}
