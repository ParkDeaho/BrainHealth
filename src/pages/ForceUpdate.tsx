import { useEffect } from 'react';
import type { VersionCheckOutcome } from '../services/versionCheck';

interface Props {
  outcome: VersionCheckOutcome;
}

export default function ForceUpdate({ outcome }: Props) {
  useEffect(() => {
    const onPopState = () => {
      window.history.pushState(null, '', window.location.href);
    };
    window.history.replaceState(null, '', window.location.href);
    window.addEventListener('popstate', onPopState);
    const prevOverflow = document.body.style.overflow;
    document.body.style.overflow = 'hidden';
    return () => {
      window.removeEventListener('popstate', onPopState);
      document.body.style.overflow = prevOverflow;
    };
  }, []);

  const openStore = () => {
    const u = outcome.updateUrl;
    if (u && u !== '#') {
      window.location.href = u;
    }
  };

  return (
    <div className="force-update-page">
      <div className="force-update-card">
        <span className="force-update-icon">📲</span>
        <h1 className="force-update-title">새 버전이 필요합니다</h1>
        <p className="force-update-desc">{outcome.message}</p>
        <dl className="force-update-versions">
          <div><dt>현재 버전</dt><dd>{outcome.currentVersion}</dd></div>
          <div><dt>최소 지원 버전</dt><dd>{outcome.minRequiredVersion}</dd></div>
          <div><dt>최신 버전</dt><dd>{outcome.latestVersion}</dd></div>
        </dl>
        {outcome.fromCacheOnly && (
          <p className="force-update-hint">네트워크에 연결할 수 없어 이전에 받은 설정으로 판단했습니다.</p>
        )}
        <button type="button" className="btn btn--primary btn--large force-update-btn" onClick={openStore}>
          업데이트 하기
        </button>
      </div>
    </div>
  );
}
