import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/components/app_text.dart';
import 'package:echonotes/components/app_card.dart';
import 'package:echonotes/components/app_button.dart';
import 'package:echonotes/components/app_bottom_sheet.dart';
import 'package:echonotes/models/note.dart';
import 'package:echonotes/components/note_list_item.dart';
import 'package:audioplayers/audioplayers.dart';

/// NotesPage（TSX -> Flutter 静态映射）
///
/// - Header: NoteHeader -> AppBar（返回/编辑/删除 图标按钮）
/// - AudioPlayer: 进度条与播放控制 -> AppCard 容器中的静态控件（仅样式，交互留 TODO）
/// - NoteSummary: 摘要 -> AppCard + AppText 组件
/// - NoteTranscription: 转写正文 -> AppCard + AppText 组件
/// - RelatedNotes: 相关笔记 -> 使用现有 NoteListItem 列表（仅展示，点击留 TODO）
/// - 全部样式使用设计系统令牌（Typography / Spacing / Radius / Colors）以适配明暗主题
class NotesPage extends StatefulWidget {
  final Note note;
  final VoidCallback? onNoteDeleted;

  const NotesPage({super.key, required this.note, this.onNoteDeleted});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  Note get note => widget.note;
  final AudioPlayer _player = AudioPlayer();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // 绑定播放器事件
    _player.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });
    _player.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });
    _player.onPlayerStateChanged.listen((s) {
      if (!mounted) return;
      setState(() => _isPlaying = s == PlayerState.playing);
    });
    // 预加载音频（若有）
    if (note.audioPath != null) {
      _player.setSource(DeviceFileSource(note.audioPath!));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final String mm = d.inMinutes.remainder(60).toString();
    final String ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  String _formatDate(DateTime dt) {
    final String ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final int hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final String minute = dt.minute.toString().padLeft(2, '0');
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final String mon = months[dt.month - 1];
    return '$hour12:$minute $ampm, $mon ${dt.day}';
  }

  // 显示删除确认对话框
  void _showDeleteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AppBottomSheet(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: ADSSpacing.spaceSm),
            const AppTextSubtitle('Delete Note'),
            const SizedBox(height: ADSSpacing.spaceSm),
            const AppTextBody(
              'Are you sure you want to delete this note? This action cannot be undone.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ADSSpacing.spaceXl),
            AppButton(
              label: 'Delete',
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
                _deleteNote(context);
              },
              expanded: true,
            ),
            const SizedBox(height: ADSSpacing.spaceSm),
            AppButton(
              label: 'Cancel',
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pop(),
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }

  // 删除笔记并返回首页
  void _deleteNote(BuildContext context) {
    // TODO: 实际删除逻辑（从数据库/存储中删除）
    // 这里只是演示，实际应该调用删除服务

    // 调用删除回调，通知首页更新列表
    widget.onNoteDeleted?.call();

    // 显示删除成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // 返回首页
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // 相关笔记（演示用，取前 2 项）
    final relatedNotes = demoNotes()
        .where((n) => n.id != note.id)
        .take(2)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: ADSSpacing.spaceXl,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: theme.iconTheme.color,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: theme.iconTheme.color,
            onPressed: () {
              // TODO: 进入编辑模式
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: theme.iconTheme.color,
            onPressed: () => _showDeleteConfirmation(context),
          ),
          const SizedBox(width: ADSSpacing.spaceXl),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          ADSSpacing.spaceXl,
          ADSSpacing.spaceLg,
          ADSSpacing.spaceXl,
          ADSSpacing.spaceXl,
        ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                // ============ 顶部标题与时间（大标题） ============
            //const SizedBox(height: ADSSpacing.spaceXl),
                AppTextHeadline(note.title),
                const SizedBox(height: ADSSpacing.spaceSm),
                AppTextBody(_formatDate(note.createdAt)),
                const SizedBox(height: ADSSpacing.spaceXl),
                // ============ 音频播放器区域（静态） ============
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                      AppTextSubtitle(_formatDuration(_position)),
                      AppTextSubtitle(_formatDuration(_duration == Duration.zero
                          ? note.duration
                          : _duration)),
                        ],
                      ),
                      const SizedBox(height: ADSSpacing.spaceMd),
                      // 进度条（静态）
                      Container(
                        height: ADSSpacing.spaceSm,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withOpacity(0.12),
                          borderRadius: ADSRadius.radiusLg,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                        widthFactor: _duration.inMilliseconds == 0
                            ? 0
                            : (_position.inMilliseconds /
                                    _duration.inMilliseconds)
                                .clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: cs.primary,
                                borderRadius: ADSRadius.radiusLg,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: ADSSpacing.spaceLg),
                      // 播放控制（静态）+ 倍速
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _RoundIcon(
                        icon: _isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 48,
                            filled: true,
                        onTap: () async {
                          if (note.audioPath == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('No audio available for this note'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          if (_isPlaying) {
                            await _player.pause();
                          } else {
                            // 若尚未设置时长，先设置资源
                            await _player
                                .setSource(DeviceFileSource(note.audioPath!));
                            await _player.resume();
                          }
                            },
                          ),
                      const Spacer(),
                        
                      Row(
                             
                             
                              children: const <Widget>[
                            _SpeedChip(
                              label: '1x',
                              selected: true,
                            ),
                          const SizedBox(width: ADSSpacing.spaceSm),
                    
                                _SpeedChip(label: '1.5x'),
                          const SizedBox(width: ADSSpacing.spaceSm),
                                _SpeedChip(label: '2x'),
                           
                              ],
                            ),
                        
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: ADSSpacing.spaceXl),

                // ============ 摘要（AI Summary） ============
                SizedBox(
                  width: double.infinity,
                  child: AppCard(
                backgroundColor: ADSColors.secondary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const AppTextSubtitle('Summary'),
                        const SizedBox(height: ADSSpacing.spaceSm),
                        AppTextBody(note.summary),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: ADSSpacing.spaceXl),

                // ============ 转写文本（Transcription） ============
                const AppTextSubtitle('Full Transcription'),
                const SizedBox(height: ADSSpacing.spaceSm),
                SizedBox(
                  width: double.infinity,
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AppTextBody(
                          // 仅示意：使用 summary 充当段落文本
                      '${note.summary}',
                          softWrap: true,
                        ),
                        const SizedBox(height: ADSSpacing.spaceSm),
                        // TODO: 可折叠展开长文
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: ADSSpacing.spaceXl),

                // ============ 相关笔记（Related Notes） ============
                const AppTextSubtitle('Related Notes'),
                const SizedBox(height: ADSSpacing.spaceSm),
                ...relatedNotes.map(
                  (n) => Padding(
                    padding: const EdgeInsets.only(bottom: ADSSpacing.spaceLg),
                    child: NoteListItem(
                      note: n,
                      onTap: () {
                        // TODO: 跳转到对应相关笔记详情
                      },
                    ),
                  ),
                ),
              ],
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool filled;
  final VoidCallback? onTap;

  const _RoundIcon({
    required this.icon,
    this.size = 48,
    this.filled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: filled ? cs.primary : cs.onSurface.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: filled ? ADSColors.lightButtonPrimary : theme.iconTheme.color,
          size: size * 0.5,
        ),
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _SpeedChip({
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ADSSpacing.spaceLg,
        vertical: ADSSpacing.spaceSm,
      ),
      decoration: BoxDecoration(
        color: selected
            ? cs.primary.withOpacity(0.15)
            : cs.error.withOpacity(0.10),
        borderRadius: ADSRadius.radiusMd,
      ),
      child: Text(
        label,
        style: ADSTypography.body.copyWith(
          color: ADSColors.lightTextPrimary
             
   
        ),
      ),
    );
  }
}


