import 'dart:convert';

import 'package:http/http.dart' as http;

/// 로컬 [Ollama](https://ollama.com) HTTP API만 사용합니다. 클라우드·API 키 없음.
class OllamaChatService {
  OllamaChatService._();

  /// UI에서 [localizedOllamaError]로 번역할 짧은 코드, 또는 알 수 없을 때 원문.
  static String normalizeNetworkError(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('connection refused') ||
        s.contains('actively refused') ||
        s.contains('errno = 1225') ||
        s.contains('network is unreachable')) {
      return 'connection_refused';
    }
    if (s.contains('timed out') || s.contains('timeout')) {
      return 'timeout';
    }
    if (s.contains('failed host lookup') ||
        s.contains('name or service not known') ||
        s.contains('no address associated')) {
      return 'dns_failed';
    }
    return e.toString();
  }

  static String _normalizeBase(String baseUrl) =>
      baseUrl.trim().replaceAll(RegExp(r'/$'), '');

  /// [Response.body]는 Content-Type에 따라 latin1로 디코딩될 수 있어, UTF-8 JSON에 항상 [utf8.decode] 사용.
  static String _responseBodyUtf8(http.Response res) =>
      utf8.decode(res.bodyBytes);

  /// `GET /api/tags` — Ollama 실행 여부 확인
  static Future<OllamaPingResult> ping(String baseUrl) async {
    final base = _normalizeBase(baseUrl);
    if (base.isEmpty) {
      return const OllamaPingResult(ok: false, message: 'empty_base');
    }
    final uri = Uri.parse('$base/api/tags');
    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return const OllamaPingResult(ok: true, message: null);
      }
      return OllamaPingResult(ok: false, message: 'HTTP ${res.statusCode}');
    } catch (e) {
      return OllamaPingResult(ok: false, message: normalizeNetworkError(e));
    }
  }

  /// `POST /api/chat` (stream: false)
  static Future<OllamaChatResult> chat({
    required String baseUrl,
    required String model,
    required List<OllamaMessage> messages,
  }) async {
    final base = _normalizeBase(baseUrl);
    if (base.isEmpty) {
      return OllamaChatResult.error('empty_base');
    }
    final uri = Uri.parse('$base/api/chat');
    final body = jsonEncode(<String, dynamic>{
      'model': model.trim(),
      'messages': messages
          .map(
            (m) => <String, String>{'role': m.role, 'content': m.content},
          )
          .toList(),
      'stream': false,
    });
    try {
      final res = await http
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json; charset=utf-8',
            },
            body: body,
          )
          .timeout(const Duration(seconds: 120));
      final bodyStr = _responseBodyUtf8(res);
      if (res.statusCode < 200 || res.statusCode >= 300) {
        return OllamaChatResult.error('HTTP ${res.statusCode}: $bodyStr');
      }
      final map = jsonDecode(bodyStr) as Map<String, dynamic>;
      final msg = map['message'];
      if (msg is Map<String, dynamic>) {
        final content = msg['content'];
        if (content is String && content.isNotEmpty) {
          return OllamaChatResult.ok(content);
        }
      }
      return OllamaChatResult.error('unexpected_response');
    } catch (e) {
      return OllamaChatResult.error(normalizeNetworkError(e));
    }
  }
}

class OllamaMessage {
  const OllamaMessage({required this.role, required this.content});

  final String role;
  final String content;
}

class OllamaChatResult {
  OllamaChatResult._({this.text, this.errorKey});

  factory OllamaChatResult.ok(String text) =>
      OllamaChatResult._(text: text, errorKey: null);

  factory OllamaChatResult.error(String keyOrMessage) =>
      OllamaChatResult._(text: null, errorKey: keyOrMessage);

  final String? text;
  final String? errorKey;

  bool get isOk => text != null;
}

class OllamaPingResult {
  const OllamaPingResult({required this.ok, this.message});

  final bool ok;
  final String? message;
}
