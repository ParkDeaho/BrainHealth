import { useNavigate } from 'react-router-dom';
import { useGameResults } from '../store/useStore';

const games = [
  { id: 'card-match', title: '카드 뒤집기', desc: '같은 그림의 카드 짝 찾기', icon: '🃏', time: '1분', path: '/training/card-match', category: '기억력' },
  { id: 'nback', title: 'N-back 훈련', desc: 'N번 전과 같은 모양 판단', icon: '🧩', time: '2분', path: '/training/nback', category: '작업 기억' },
  { id: 'sequence-memory', title: '시퀀스 기억', desc: '빛나는 순서를 기억하고 재현', icon: '🎵', time: '2분', path: '/training/sequence-memory', category: '순차 기억' },
  { id: 'selective-focus', title: '선택 집중', desc: '목표만 빠르게 선택하기', icon: '⭐', time: '1분', path: '/training/selective-focus', category: '집중력' },
  { id: 'number-memory-game', title: '숫자 기억하기', desc: '점점 길어지는 숫자를 기억', icon: '🔢', time: '1분', path: '/training/number-memory', category: '기억력' },
  { id: 'breathing', title: '호흡 · 집중 회복', desc: '1분 호흡으로 집중 리셋', icon: '🧘', time: '1분', path: '/training/breathing', category: '회복' },
];

export default function Training() {
  const navigate = useNavigate();
  const { getTodayGameResults } = useGameResults();
  const todayResults = getTodayGameResults();

  return (
    <div className="page page--training">
      <header className="page-header">
        <h1>두뇌 훈련</h1>
        <p className="page-subtitle">재미있게 반복하면 뇌가 활성화돼요!</p>
      </header>

      <div className="training-summary card">
        <span className="training-summary-icon">🏆</span>
        <div>
          <p className="training-summary-title">오늘의 훈련</p>
          <p className="training-summary-count">
            {todayResults.length > 0 ? `${todayResults.length}회 완료!` : '아직 시작 전'}
          </p>
        </div>
      </div>

      <div className="training-list">
        {games.map(game => {
          const played = todayResults.some(r => r.type === game.id);
          return (
            <button key={game.id} className="card training-card" onClick={() => navigate(game.path)}>
              <span className="training-card-icon">{game.icon}</span>
              <div className="training-card-info">
                <h3>{game.title}{played && <span className="training-done-badge">완료 ✓</span>}</h3>
                <p>{game.desc}</p>
                <div className="training-card-meta">
                  <span className="training-card-time">⏱ {game.time}</span>
                  <span className="training-card-category">{game.category}</span>
                </div>
              </div>
            </button>
          );
        })}
      </div>
    </div>
  );
}
