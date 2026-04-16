import { useEffect, useState, type ReactNode } from 'react';
import { fetchRemoteAppConfig } from '../services/remoteConfig';
import { evaluateVersionGate, type VersionCheckOutcome } from '../services/versionCheck';
import ForceUpdate from '../pages/ForceUpdate';

interface Props {
  children: ReactNode;
}

export default function VersionBootstrap({ children }: Props) {
  const [ready, setReady] = useState(false);
  const [outcome, setOutcome] = useState<VersionCheckOutcome | null>(null);

  useEffect(() => {
    let cancelled = false;

    (async () => {
      const r = await fetchRemoteAppConfig();
      if (cancelled) return;

      let gate: VersionCheckOutcome | null = null;
      if (r.ok) {
        gate = evaluateVersionGate(r.config, { fromCacheOnly: false });
      } else if (r.cached) {
        gate = evaluateVersionGate(r.cached, { fromCacheOnly: r.reason === 'network' });
      }

      if (gate) {
        setOutcome(gate);
      }
      setReady(true);
    })();

    return () => {
      cancelled = true;
    };
  }, []);

  if (!ready) {
    return (
      <div className="splash-check" role="status" aria-live="polite">
        <div className="splash-check-inner">
          <div className="splash-check-spinner" />
          <p className="splash-check-text">버전 확인 중…</p>
        </div>
      </div>
    );
  }

  if (outcome) {
    return <ForceUpdate outcome={outcome} />;
  }

  return <>{children}</>;
}
