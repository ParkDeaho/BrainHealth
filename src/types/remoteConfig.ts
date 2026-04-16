/** 원격 설정 JSON (플랫폼별 또는 web 단일) */
export interface PlatformVersionConfig {
  latestVersion: string;
  minRequiredVersion: string;
  forceUpdate: boolean;
  storeUrl?: string;
  updateUrl?: string;
  message?: string;
}

export interface RemoteAppConfigRoot {
  web?: PlatformVersionConfig;
  android?: PlatformVersionConfig;
  /** 루트에 직접 두는 경우 (web 전용 정적 JSON) */
  latestVersion?: string;
  minRequiredVersion?: string;
  forceUpdate?: boolean;
  storeUrl?: string;
  updateUrl?: string;
  message?: string;
}

export interface CachedAppConfig {
  raw: RemoteAppConfigRoot;
  fetchedAt: number;
  sourceUrl: string;
}
