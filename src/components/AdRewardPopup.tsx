import { useState } from 'react';
import { useAdRewards } from '../store/useStore';

interface AdRewardPopupProps {
  type: 'detail-report' | 'extra-game' | 'special-report' | 'badge';
  title: string;
  description: string;
  onComplete: () => void;
  onClose: () => void;
}

export default function AdRewardPopup({ type, title, description, onComplete, onClose }: AdRewardPopupProps) {
  const { addReward } = useAdRewards();
  const [watching, setWatching] = useState(false);
  const [done, setDone] = useState(false);

  const handleWatch = () => {
    setWatching(true);
    setTimeout(() => {
      addReward(type);
      setDone(true);
      setWatching(false);
    }, 2000);
  };

  return (
    <div className="ad-popup-overlay" onClick={e => { if (e.target === e.currentTarget) onClose(); }}>
      <div className="ad-popup">
        <button className="ad-popup-close" onClick={onClose}>✕</button>
        <span className="ad-popup-icon">🎬</span>
        <h3>{title}</h3>
        <p>{description}</p>

        {watching ? (
          <div className="ad-popup-loading">
            <div className="ad-popup-spinner" />
            <p>광고 시청 중...</p>
          </div>
        ) : done ? (
          <div className="ad-popup-done">
            <span className="ad-popup-check">✅</span>
            <p>보상이 적용되었습니다!</p>
            <button className="btn btn--primary" onClick={onComplete}>확인</button>
          </div>
        ) : (
          <button className="btn btn--accent btn--large" onClick={handleWatch}>
            광고 보고 보상 받기
          </button>
        )}
      </div>
    </div>
  );
}
