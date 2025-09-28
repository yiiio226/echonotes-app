import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/components/app_text.dart';
import 'package:echonotes/components/app_card.dart';
import 'package:echonotes/models/note.dart';
import 'package:echonotes/components/note_list_item.dart';

/// NotesPage（TSX -> Flutter 静态映射）
///
/// - Header: NoteHeader -> AppBar（返回/编辑/删除 图标按钮）
/// - AudioPlayer: 进度条与播放控制 -> AppCard 容器中的静态控件（仅样式，交互留 TODO）
/// - NoteSummary: 摘要 -> AppCard + AppText 组件
/// - NoteTranscription: 转写正文 -> AppCard + AppText 组件
/// - RelatedNotes: 相关笔记 -> 使用现有 NoteListItem 列表（仅展示，点击留 TODO）
/// - 全部样式使用设计系统令牌（Typography / Spacing / Radius / Colors）以适配明暗主题
class NotesPage extends StatelessWidget {
  final Note note;

  const NotesPage({super.key, required this.note});

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
            onPressed: () {
              // TODO: 删除确认（底部抽屉）
            },
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
                          const AppTextSubtitle('0:13'), // TODO: 绑定当前进度
                          AppTextSubtitle(_formatDuration(note.duration)),
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
                            widthFactor: 0.25, // TODO: 绑定播放进度
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
                            icon: Icons.play_arrow_rounded,
                        size: 48,
                           
                            filled: true,
                            onTap: () {
                              // TODO: 播放/暂停
                            },
                          ),
                          const SizedBox(width: ADSSpacing.spaceXl),
                          Expanded(
                            child: Wrap(
                              spacing: ADSSpacing.spaceLg,
                              runSpacing: ADSSpacing.spaceSm,
                              children: const <Widget>[
                            _SpeedChip(
                              label: '1x',
                              selected: true,
                            ),
                                _SpeedChip(label: '1.25x'),
                                _SpeedChip(label: '1.5x'),
                                _SpeedChip(label: '2x'),
                              ],
                            ),
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
                          '${note.summary} ${note.summary}',
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


