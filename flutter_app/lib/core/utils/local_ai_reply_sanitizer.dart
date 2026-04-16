/// 로컬 AI 답변에서 마크다운·장식 기호를 제거해 한글 표시와 TTS가 깨지지 않게 합니다.
class LocalAiReplySanitizer {
  LocalAiReplySanitizer._();

  static String sanitize(String raw) {
    var s = raw.trim();
    if (s.isEmpty) {
      return s;
    }
    // 코드 블록
    s = s.replaceAll(RegExp(r'```[\s\S]*?```'), ' ');
    // 링크 [텍스트](url) → 텍스트
    s = s.replaceAllMapped(
      RegExp(r'\[([^\]]*)\]\([^)]*\)'),
      (m) => m.group(1) ?? '',
    );
    s = s.replaceAll('**', '').replaceAll('*', '');
    s = s.replaceAll('__', '');
    s = s.replaceAll('`', '');
    s = s.replaceAll('#', '');
    s = s.replaceAll('~', '');
    s = s.replaceAll('|', '');
    s = s.replaceAll('>', '');
    // 장식용 기호
    s = s.replaceAll(RegExp(r'[•·▪◆◇□■→—–]'), ' ');
    // 줄 시작 목록 표시
    s = s.replaceAll(RegExp(r'^\s*[\-\*\+]\s+', multiLine: true), '');
    s = s.replaceAll(RegExp(r'^\s*\d+\.\s+', multiLine: true), '');
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    return s.trim();
  }
}
