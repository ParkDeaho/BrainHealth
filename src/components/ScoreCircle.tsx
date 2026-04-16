interface ScoreCircleProps {
  score: number;
  maxScore?: number;
  size?: number;
  label?: string;
  color?: string;
}

export default function ScoreCircle({
  score,
  maxScore = 100,
  size = 120,
  label,
  color = 'var(--color-primary)',
}: ScoreCircleProps) {
  const radius = (size - 12) / 2;
  const circumference = 2 * Math.PI * radius;
  const progress = Math.min(score / maxScore, 1);
  const offset = circumference * (1 - progress);

  return (
    <div className="score-circle" style={{ width: size, height: size }}>
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke="var(--color-border)"
          strokeWidth="8"
        />
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke={color}
          strokeWidth="8"
          strokeLinecap="round"
          strokeDasharray={circumference}
          strokeDashoffset={offset}
          transform={`rotate(-90 ${size / 2} ${size / 2})`}
          style={{ transition: 'stroke-dashoffset 0.8s ease' }}
        />
      </svg>
      <div className="score-circle__inner">
        <span className="score-circle__value">{Math.round(score)}</span>
        {label && <span className="score-circle__label">{label}</span>}
      </div>
    </div>
  );
}
