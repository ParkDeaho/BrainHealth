import type { CachedAppConfig, PlatformVersionConfig, RemoteAppConfigRoot } from '../types/remoteConfig';

const CACHE_KEY = 'bt_app_config_cache';

function loadCache(): CachedAppConfig | null {
  try {
    const raw = localStorage.getItem(CACHE_KEY);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

function saveCache(data: CachedAppConfig) {
  localStorage.setItem(CACHE_KEY, JSON.stringify(data));
}

function getConfigUrl(): string | undefined {
  const u = import.meta.env.VITE_REMOTE_CONFIG_URL;
  return typeof u === 'string' && u.trim() ? u.trim() : undefined;
}

/** 루트 JSON에서 web용 설정 추출 */
export function pickWebConfig(root: RemoteAppConfigRoot): PlatformVersionConfig | null {
  if (root.web) {
    return root.web;
  }
  if (root.latestVersion != null && root.minRequiredVersion != null) {
    return {
      latestVersion: root.latestVersion,
      minRequiredVersion: root.minRequiredVersion,
      forceUpdate: root.forceUpdate ?? true,
      storeUrl: root.storeUrl,
      updateUrl: root.updateUrl,
      message: root.message,
    };
  }
  return null;
}

export type FetchRemoteConfigResult =
  | { ok: true; config: PlatformVersionConfig; fromCache: boolean }
  | { ok: false; reason: 'no_url' | 'network' | 'invalid'; cached: PlatformVersionConfig | null };

/**
 * 원격 설정 fetch + 로컬 캐시 (app_config_cache 대응)
 * URL 미설정 시 ok:false no_url — 호출 측에서 진행 허용
 */
export async function fetchRemoteAppConfig(): Promise<FetchRemoteConfigResult> {
  const url = getConfigUrl();
  const prev = loadCache();

  if (!url) {
    const cached = prev ? pickWebConfig(prev.raw) : null;
    return { ok: false, reason: 'no_url', cached };
  }

  try {
    const res = await fetch(url, { cache: 'no-store' });
    if (!res.ok) throw new Error(String(res.status));
    const json = (await res.json()) as RemoteAppConfigRoot;
    const picked = pickWebConfig(json);
    if (!picked) {
      return { ok: false, reason: 'invalid', cached: prev ? pickWebConfig(prev.raw) : null };
    }
    saveCache({ raw: json, fetchedAt: Date.now(), sourceUrl: url });
    return { ok: true, config: picked, fromCache: false };
  } catch {
    const cached = prev ? pickWebConfig(prev.raw) : null;
    return { ok: false, reason: 'network', cached };
  }
}

export function getLastCachedWebConfig(): PlatformVersionConfig | null {
  const prev = loadCache();
  return prev ? pickWebConfig(prev.raw) : null;
}
