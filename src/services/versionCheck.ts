import { isBelowMinimum } from '../utils/version';
import type { PlatformVersionConfig } from '../types/remoteConfig';

export const APP_VERSION: string =
  typeof __APP_VERSION__ !== 'undefined' ? __APP_VERSION__ : '0.0.0';

export interface VersionCheckOutcome {
  blocked: boolean;
  currentVersion: string;
  minRequiredVersion: string;
  latestVersion: string;
  message: string;
  updateUrl: string;
  /** 캐시 기준 강제인지 (오프라인 + 이전에 강제 플래그) */
  fromCacheOnly: boolean;
}

function resolveUpdateUrl(cfg: PlatformVersionConfig): string {
  return cfg.updateUrl ?? cfg.storeUrl ?? '#';
}

function resolveMessage(cfg: PlatformVersionConfig): string {
  return (
    cfg.message?.trim() ||
    '더 안정적인 사용을 위해 최신 버전으로 업데이트가 필요합니다.'
  );
}

/**
 * 현재 앱 버전이 최소 지원 미만이면 강제 업데이트
 * (forceUpdate가 false여도 min 미만이면 차단 — 보안/호환 정책)
 */
export function evaluateVersionGate(
  cfg: PlatformVersionConfig | null,
  options: { fromCacheOnly: boolean },
): VersionCheckOutcome | null {
  if (!cfg) return null;

  const min = cfg.minRequiredVersion;
  const latest = cfg.latestVersion;
  const blocked = isBelowMinimum(APP_VERSION, min);

  if (!blocked) return null;

  return {
    blocked: true,
    currentVersion: APP_VERSION,
    minRequiredVersion: min,
    latestVersion: latest,
    message: resolveMessage(cfg),
    updateUrl: resolveUpdateUrl(cfg),
    fromCacheOnly: options.fromCacheOnly,
  };
}
