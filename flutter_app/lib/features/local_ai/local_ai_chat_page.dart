import 'dart:io';

import 'package:braintrain_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/services/local_ai_context_builder.dart';
import '../../core/services/local_tts_service.dart';
import '../../core/services/ollama_chat_service.dart';
import '../../core/storage/app_prefs.dart';
import '../../core/utils/local_ai_reply_sanitizer.dart';
import '../mind_check/mind_check_notifier.dart';

String _localizedOllamaUserMessage(
  AppLocalizations l10n,
  String? message, {
  required bool forPing,
}) {
  final m = message?.trim() ?? '';
  switch (m) {
    case 'connection_refused':
      return l10n.localAiErrConnectionRefused;
    case 'timeout':
      return l10n.localAiErrTimeout;
    case 'dns_failed':
      return l10n.localAiErrDnsFailed;
    case 'empty_base':
      return l10n.localAiErrEmptyBase;
    case 'unexpected_response':
      return l10n.localAiErrUnexpectedResponse;
    default:
      if (forPing) {
        return l10n.localAiPingFail(m.isEmpty ? '—' : m);
      }
      return l10n.localAiErrorGeneric(m.isEmpty ? '—' : m);
  }
}

/// 로컬 PC에서 실행 중인 Ollama와만 통신 (클라우드 미사용).
/// 마이크: 음성 인식(STT) · 답변 읽기(TTS).
/// 시스템 맥락: 앱 로컬 DB 요약을 매 요청마다 주입한다.
class LocalAiChatPage extends ConsumerStatefulWidget {
  const LocalAiChatPage({super.key});

  @override
  ConsumerState<LocalAiChatPage> createState() => _LocalAiChatPageState();
}

class _Bubble {
  _Bubble({required this.isUser, required this.text});

  final bool isUser;
  final String text;
}

class _LocalAiChatPageState extends ConsumerState<LocalAiChatPage> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _bubbles = <_Bubble>[];

  final _speech = SpeechToText();

  String _baseUrl = AppPrefs.defaultOllamaBaseUrl;
  String _model = AppPrefs.defaultOllamaModel;
  bool _loadingPrefs = true;
  bool _sending = false;
  String? _pingNote;

  bool _speechReady = false;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    await _loadPrefs();
    if (Platform.isAndroid || Platform.isIOS) {
      await Permission.microphone.request();
    }
    await _initSpeechAndTts();
  }

  Future<void> _initSpeechAndTts() async {
    final ok = await _speech.initialize(
      onError: (_) {
        if (mounted) {
          setState(() => _listening = false);
        }
      },
      onStatus: (status) {
        if (!mounted) {
          return;
        }
        if (status == 'notListening' || status == 'done') {
          setState(() => _listening = false);
        }
      },
    );
    if (mounted) {
      setState(() => _speechReady = ok);
    }
  }

  @override
  void dispose() {
    _speech.stop();
    LocalTtsService.stop();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final b = await AppPrefs.getOllamaBaseUrl();
    final m = await AppPrefs.getOllamaModel();
    if (!mounted) {
      return;
    }
    setState(() {
      _baseUrl = b;
      _model = m;
      _loadingPrefs = false;
    });
  }

  String _sttLocaleId(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'ko') {
      return 'ko_KR';
    }
    return 'en_US';
  }

  Future<void> _speakBubble(String text) async {
    await LocalTtsService.stop();
    if (!mounted) {
      return;
    }
    await LocalTtsService.speak(text);
  }

  Future<void> _openOllamaDownload(AppLocalizations l10n) async {
    final uri = Uri.parse('https://ollama.com/download');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.localAiCouldNotOpenLink)),
      );
    }
  }

  Future<void> _toggleMic(AppLocalizations l10n) async {
    if (_sending) {
      return;
    }
    if (!_speechReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.localAiSpeechUnavailable)),
      );
      return;
    }
    if (_listening) {
      await _speech.stop();
      if (mounted) {
        setState(() => _listening = false);
      }
      return;
    }

    setState(() => _listening = true);
    final localeId = _sttLocaleId(context);

    await _speech.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
        if (result.finalResult) {
          if (mounted) {
            setState(() => _listening = false);
          }
          final t = _controller.text.trim();
          if (t.isNotEmpty) {
            _send(l10n);
          }
        }
      },
      listenFor: const Duration(seconds: 45),
      pauseFor: const Duration(seconds: 3),
      localeId: localeId,
      listenOptions: SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  Future<void> _openSettings(AppLocalizations l10n) async {
    final urlCtrl = TextEditingController(text: _baseUrl);
    final modelCtrl = TextEditingController(text: _model);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.localAiSettingsTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.localAiBaseUrlLabel),
              const SizedBox(height: 6),
              TextField(
                controller: urlCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: AppPrefs.defaultOllamaBaseUrl,
                ),
                keyboardType: TextInputType.url,
                autocorrect: false,
              ),
              const SizedBox(height: 12),
              Text(l10n.localAiModelLabel),
              const SizedBox(height: 6),
              TextField(
                controller: modelCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                autocorrect: false,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.localAiHintEmulator,
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.localAiSave),
          ),
        ],
      ),
    );
    if (ok == true) {
      await AppPrefs.setOllamaBaseUrl(urlCtrl.text);
      await AppPrefs.setOllamaModel(modelCtrl.text);
      urlCtrl.dispose();
      modelCtrl.dispose();
      if (!mounted) {
        return;
      }
      await _loadPrefs();
    } else {
      urlCtrl.dispose();
      modelCtrl.dispose();
    }
  }

  Future<void> _testConnection(AppLocalizations l10n) async {
    setState(() => _pingNote = l10n.localAiTesting);
    final r = await OllamaChatService.ping(_baseUrl);
    if (!mounted) {
      return;
    }
    setState(() {
      _pingNote = r.ok
          ? l10n.localAiPingOk
          : _localizedOllamaUserMessage(l10n, r.message, forPing: true);
    });
  }

  List<OllamaMessage> _buildApiMessages(String systemContent) {
    final list = <OllamaMessage>[
      OllamaMessage(role: 'system', content: systemContent),
    ];
    for (final b in _bubbles) {
      list.add(
        OllamaMessage(
          role: b.isUser ? 'user' : 'assistant',
          content: b.text,
        ),
      );
    }
    return list;
  }

  Future<void> _send(AppLocalizations l10n) async {
    final t = _controller.text.trim();
    if (t.isEmpty || _sending) {
      return;
    }
    final lang = Localizations.localeOf(context).languageCode;
    final db = ref.read(appDatabaseProvider);
    await _speech.stop();
    if (mounted) {
      setState(() => _listening = false);
    }

    setState(() {
      _bubbles.add(_Bubble(isUser: true, text: t));
      _controller.clear();
      _sending = true;
    });
    _scrollToEnd();

    final systemPrompt =
        await LocalAiContextBuilder.buildSystemPrompt(db, languageCode: lang);

    final result = await OllamaChatService.chat(
      baseUrl: _baseUrl,
      model: _model,
      messages: _buildApiMessages(systemPrompt),
    );

    if (!mounted) {
      return;
    }
    setState(() {
      _sending = false;
      if (result.isOk) {
        final cleaned = LocalAiReplySanitizer.sanitize(result.text!);
        _bubbles.add(_Bubble(isUser: false, text: cleaned));
      } else {
        _bubbles.add(
          _Bubble(
            isUser: false,
            text: _localizedOllamaUserMessage(
              l10n,
              result.errorKey,
              forPing: false,
            ),
          ),
        );
      }
    });
    _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) {
        return;
      }
      _scroll.animateTo(
        _scroll.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.localAiTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi_tethering),
            tooltip: l10n.localAiTestConnection,
            onPressed: _loadingPrefs ? null : () => _testConnection(l10n),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _loadingPrefs ? null : () => _openSettings(l10n),
          ),
        ],
      ),
      body: _loadingPrefs
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text(
                    l10n.localAiDisclaimer,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.35,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    l10n.localAiOllamaSetupHint,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.35,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _openOllamaDownload(l10n),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(l10n.localAiOpenOllamaDownload),
                    ),
                  ),
                ),
                if (_listening)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mic,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.localAiListening,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_pingNote != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      _pingNote!,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(16),
                    itemCount: _bubbles.length + (_sending ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (_sending && i == _bubbles.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                l10n.localAiThinking,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                      }
                      final b = _bubbles[i];
                      return Align(
                        alignment: b.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                          ),
                          decoration: BoxDecoration(
                            color: b.isUser
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: b.isUser
                              ? SelectableText(
                                  b.text,
                                  style: const TextStyle(height: 1.4),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: SelectableText(
                                        b.text,
                                        style: const TextStyle(height: 1.4),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.volume_up_outlined),
                                      iconSize: 20,
                                      tooltip: l10n.localAiSpeakReply,
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 36,
                                      ),
                                      onPressed: () => _speakBubble(b.text),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 12, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          tooltip: _listening
                              ? l10n.localAiMicStop
                              : l10n.localAiMicListen,
                          onPressed: (_sending || !_speechReady)
                              ? null
                              : () => _toggleMic(l10n),
                          icon: Icon(
                            _listening ? Icons.stop_circle : Icons.mic,
                            color: _listening
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: l10n.localAiMessageHint,
                              border: const OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(l10n),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton.filled(
                          onPressed: _sending ? null : () => _send(l10n),
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
