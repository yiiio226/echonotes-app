import 'dart:async';

import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/components/app_text.dart';
// import 'package:echonotes/components/app_button.dart';
import 'package:echonotes/components/note_list_item.dart';
import 'package:echonotes/models/note.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:echonotes/pages/notes_page.dart';
import 'package:echonotes/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  late List<Note> _all;
  late List<Note> _filtered;

  @override
  void initState() {
    super.initState();
    _all = demoNotes();
    _filtered = _all;
    _searchCtrl.addListener(_onSearchChanged);
    _ensureAudioPermissions();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final String q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _all
          : _all
              .where((n) =>
                  n.title.toLowerCase().contains(q) ||
                  n.summary.toLowerCase().contains(q))
              .toList();
    });
  }

  void _openRecorderSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RecordingSheet(onSaved: _onNoteSaved),
    );
  }

  Future<void> _ensureAudioPermissions() async {
    try {
      final stt = SpeechToText();
      await stt.initialize();
    } catch (_) {
      // 忽略：初始化失败时不要打断首屏
    }
  }

  void _onNoteSaved(Note note) {
    final String q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _all = [note, ..._all];
      _filtered = q.isEmpty
          ? _all
          : _all
              .where((n) =>
                  n.title.toLowerCase().contains(q) ||
                  n.summary.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: ADSSpacing.spaceXl,
        title: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AppTextHeadline("Let's EchoNote"),
            SizedBox(height: 4),
            AppTextBody('anything you care'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: ADSSpacing.spaceXl),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                radius: 16,
                child: Icon(Icons.person, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: ADSSpacing.spaceXl),
        children: [
          const SizedBox(height: ADSSpacing.spaceLg),
          Row(
            children: const [
              AppTextSubtitle('All Notes'),
              Spacer(),
              AppTextCaption('3 notes'),
            ],
          ),
          const SizedBox(height: ADSSpacing.spaceSm),
          TextField(
            controller: _searchCtrl,
            decoration: InputDecoration(
              hintText: 'Search notes…',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: ADSRadius.radiusLg),
              filled: true,
            ),
          ),
          const SizedBox(height: ADSSpacing.spaceLg),
          ..._filtered
              .map((n) => Padding(
                    padding: const EdgeInsets.only(bottom: ADSSpacing.spaceLg),
                    child: NoteListItem(
                      note: n,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NotesPage(note: n),
                          ),
                        );
                      },
                    ),
                  ))
              .toList(),
          const SizedBox(height: 96),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: _openRecorderSheet,
          child: Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, color: Colors.white),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 72,
        child: Center(
          child: AppTextCaption('Tap to record'),
        ),
      ),
    );
  }
}

class _RecordingSheet extends StatefulWidget {
  const _RecordingSheet({required this.onSaved});

  final ValueChanged<Note> onSaved;

  @override
  State<_RecordingSheet> createState() => _RecordingSheetState();
}

class _RecordingSheetState extends State<_RecordingSheet> {
  static const Duration maxDuration = Duration(minutes: 1);
  late Timer _timer;
  Duration _elapsed = Duration.zero;
  bool _recording = true;
  final SpeechToText _stt = SpeechToText();
  bool _sttAvailable = false;
  bool _sttListening = false;
  String _transcript = '';
  String? _localeId;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _startSpeechToText();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_elapsed >= maxDuration) {
        _stop();
        return;
      }
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });
    });
  }

  void _stop() {
    if (!_recording) return;
    setState(() => _recording = false);
    _timer.cancel();
    // 结束语音监听
    if (_sttListening) {
      _stt.stop();
      _sttListening = false;
    }
    // 1) 保存笔记；2) 生成文字转写与简短摘要；3) 收回面板；4) 首页顶部新增新笔记
    final DateTime now = DateTime.now();
    // 仅使用真实识别结果；不再使用占位/演示文案
    final String transcript = _transcript.trim();
    final String title = transcript.isEmpty ? '语音笔记' : _deriveTitle(transcript);
    final String summary =
        transcript.isEmpty ? '（未识别到语音）' : _summarize(transcript);
    final note = Note(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      summary: summary,
      createdAt: now,
      duration: _elapsed,
      audioPath: null,
    );
    widget.onSaved(note);
    Navigator.of(context).maybePop();
  }

  Future<void> _startSpeechToText() async {
    try {
      _sttAvailable = await _stt.initialize(
        onError: (e) {},
        debugLogging: false,
      );
      if (!_sttAvailable) return;
      // 优先选择中文识别语言，其次使用系统语言
      try {
        final locales = await _stt.locales();
        String? zhLocaleId;
        for (final l in locales) {
          if (l.localeId.toLowerCase().startsWith('zh')) {
            zhLocaleId = l.localeId;
            break;
          }
        }
        final sys = await _stt.systemLocale();
        setState(() {
          _localeId = zhLocaleId ?? sys?.localeId;
        });
      } catch (_) {}
      await _stt.listen(
        onResult: (r) {
          setState(() {
            _transcript = r.recognizedWords;
          });
        },
        listenFor: maxDuration,
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
        localeId: _localeId,
      );
      _sttListening = true;
    } catch (_) {
      _sttAvailable = false;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final String mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppTextCaption('FREE PLAN · 1 MINUTE MAX'),
            const SizedBox(height: 8),
            Text(
              _format(_elapsed),
              style: ADSTypography.h1.copyWith(fontSize: 40),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.fiber_manual_record, color: Colors.red),
                SizedBox(width: 8),
                AppTextSubtitle('Recording'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: ADSRadius.radiusLg,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _RoundIconButton(
                  icon: Icons.delete_outline,
                  color: Colors.redAccent,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                _RoundIconButton(
                  icon: _recording ? Icons.stop : Icons.play_arrow,
                  color: Colors.black87,
                  fg: Colors.white,
                  onTap: _stop,
                  size: 88,
                ),
                const _RoundIconButton(icon: Icons.more_horiz),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final Color? fg;
  final VoidCallback? onTap;

  const _RoundIconButton({
    required this.icon,
    this.size = 64,
    this.color,
    this.fg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? Colors.black12,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: fg ?? Colors.black87),
      ),
    );
  }
}

String _deriveTitle(String transcript) {
  final String t = transcript.trim();
  final int cut = t.length > 18 ? 18 : t.length;
  return t.substring(0, cut);
}

String _summarize(String transcript) {
  final String t = transcript.trim();
  if (t.length <= 80) return t;
  return '${t.substring(0, 80)}…';
}


