import type { WeatherData, WeatherInsight } from '../types';

interface Props {
  weather: WeatherData | null;
  insight: WeatherInsight;
}

function getPm25Label(pm25: number): { label: string; color: string } {
  if (pm25 <= 15) return { label: '좋음', color: '#00C9A7' };
  if (pm25 <= 35) return { label: '보통', color: '#6C63FF' };
  if (pm25 <= 75) return { label: '나쁨', color: '#FFB020' };
  return { label: '매우나쁨', color: '#FF6B6B' };
}

export default function WeatherCard({ weather, insight }: Props) {
  if (!weather) return null;

  const pm = getPm25Label(weather.pm25);

  return (
    <div className="weather-card card">
      <div className="weather-card-top">
        <div className="weather-main">
          <span className="weather-big-icon">{insight.icon}</span>
          <div>
            <span className="weather-temp">{weather.temperature}°C</span>
            <span className="weather-desc">체감 {weather.feelsLike ?? weather.temperature}°C</span>
          </div>
        </div>
        <div className="weather-meta">
          <span>💧 {weather.humidity}%</span>
          <span style={{ color: pm.color }}>🌫️ {pm.label} ({weather.pm25})</span>
        </div>
      </div>

      <div className={`weather-insight weather-insight--${insight.impact}`}>
        <p className="weather-insight-msg">{insight.message}</p>
        {insight.detail && <p className="weather-insight-detail">{insight.detail}</p>}
        <p className="weather-insight-rec">💡 {insight.recommendation}</p>
      </div>
    </div>
  );
}
