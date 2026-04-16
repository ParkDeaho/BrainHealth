import { useRoutines } from '../store/useStore';
import { formatDisplay, getToday } from '../utils/date';

export default function Routine() {
  const { getTodayRoutine, toggleRoutineItem } = useRoutines();
  const routine = getTodayRoutine();
  const completed = routine.items.filter(i => i.completed).length;
  const total = routine.items.length;
  const progress = total > 0 ? (completed / total) * 100 : 0;

  return (
    <div className="page page--routine">
      <header className="page-header">
        <h1>오늘의 루틴</h1>
        <p className="page-subtitle">{formatDisplay(getToday())}</p>
      </header>

      <section className="card routine-summary-card">
        <div className="routine-progress-ring">
          <svg width="80" height="80" viewBox="0 0 80 80">
            <circle cx="40" cy="40" r="34" fill="none" stroke="var(--color-border)" strokeWidth="6" />
            <circle
              cx="40"
              cy="40"
              r="34"
              fill="none"
              stroke="var(--color-success)"
              strokeWidth="6"
              strokeLinecap="round"
              strokeDasharray={2 * Math.PI * 34}
              strokeDashoffset={2 * Math.PI * 34 * (1 - progress / 100)}
              transform="rotate(-90 40 40)"
              style={{ transition: 'stroke-dashoffset 0.5s ease' }}
            />
          </svg>
          <span className="routine-progress-text">{completed}/{total}</span>
        </div>
        <div className="routine-summary-info">
          <h3>
            {progress === 100
              ? '오늘 루틴 완료! 🎉'
              : progress >= 50
                ? '잘하고 있어요! 💪'
                : '오늘도 하나씩 실천해봐요'}
          </h3>
          <p className="routine-summary-sub">
            뇌 건강은 매일의 작은 습관에서 시작돼요
          </p>
        </div>
      </section>

      <section className="routine-list">
        {routine.items.map(item => (
          <button
            key={item.id}
            className={`card routine-item ${item.completed ? 'routine-item--done' : ''}`}
            onClick={() => toggleRoutineItem(item.id)}
          >
            <span className="routine-item-icon">{item.icon}</span>
            <span className="routine-item-label">{item.label}</span>
            <span className={`routine-item-check ${item.completed ? 'routine-item-check--done' : ''}`}>
              {item.completed ? '✓' : ''}
            </span>
          </button>
        ))}
      </section>

      <p className="routine-tip">
        💡 탭하면 완료/취소할 수 있어요
      </p>
    </div>
  );
}
