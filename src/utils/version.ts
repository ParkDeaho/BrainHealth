/**
 * 시맨틱 버전 비교 (1.0.9 < 1.0.10, 1.2.0 < 2.0.0)
 * 문자열 직접 비교가 아닌 숫자 세그먼트 단위 비교
 */
export function parseVersion(version: string): number[] {
  const cleaned = version.trim().replace(/^v/i, '');
  const parts = cleaned.split('.').map(s => parseInt(s, 10));
  return parts.map(n => (Number.isFinite(n) ? n : 0));
}

/** a < b → -1, a === b → 0, a > b → 1 */
export function compareVersions(a: string, b: string): number {
  const pa = parseVersion(a);
  const pb = parseVersion(b);
  const len = Math.max(pa.length, pb.length);
  for (let i = 0; i < len; i += 1) {
    const x = pa[i] ?? 0;
    const y = pb[i] ?? 0;
    if (x < y) return -1;
    if (x > y) return 1;
  }
  return 0;
}

export function isBelowMinimum(current: string, minRequired: string): boolean {
  return compareVersions(current, minRequired) < 0;
}
