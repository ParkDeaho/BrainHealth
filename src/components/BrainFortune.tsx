import type { BrainFortune as BrainFortuneType } from '../types';

interface Props {
  fortune: BrainFortuneType;
}

export default function BrainFortune({ fortune }: Props) {
  return (
    <div className="fortune-card card">
      <div className="fortune-header">
        <span className="fortune-icon">{fortune.icon}</span>
        <h3>오늘의 뇌 컨디션 예보</h3>
      </div>

      <p className="fortune-weather-factor">{fortune.weatherFactor}</p>

      <div className="fortune-overall">
        <p>{fortune.overallMessage}</p>
      </div>

      <div className="fortune-details">
        <div className="fortune-detail">
          <span className="fortune-detail-icon">🧠</span>
          <div>
            <h4>기억력 흐름</h4>
            <p>{fortune.memoryForecast}</p>
          </div>
        </div>
        <div className="fortune-detail">
          <span className="fortune-detail-icon">🎯</span>
          <div>
            <h4>집중력 흐름</h4>
            <p>{fortune.focusForecast}</p>
          </div>
        </div>
      </div>
    </div>
  );
}
