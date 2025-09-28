import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/components/app_card.dart';
import 'package:echonotes/components/app_text.dart';
import 'package:echonotes/models/note.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  // 搜索关键词高亮
  final String? highlight;

  const NoteListItem(
      {super.key, required this.note, this.onTap, this.highlight});

  String _formatDate(DateTime dt) {
    final String ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final int hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final String minute = dt.minute.toString().padLeft(2, '0');
    final String mon = _monthName(dt.month);
    return '$hour12:$minute $ampm, $mon ${dt.day}';
  }

  String _monthName(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m - 1];
  }

  String _formatDuration(Duration d) {
    final String mm = d.inMinutes.remainder(60).toString();
    final String ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final brightness = theme.brightness;
    final Color titleColor = brightness == Brightness.dark
        ? ADSColors.darkTextPrimary
        : ADSColors.lightTextPrimary;
    final Color bodyColor = brightness == Brightness.dark
        ? ADSColors.darkTextSecondary
        : ADSColors.lightTextSecondary;

    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题（支持关键词高亮）
                _buildHighlightedText(
                  context,
                  note.title,
                  highlight,
                  ADSTypography.h3.copyWith(color: titleColor),
                  ADSTypography.h3.copyWith(
                      color: ADSColors.lightSuccess,
                      fontWeight: FontWeight.w700),
                  maxLines: 1,
                ),
                const SizedBox(height: ADSSpacing.spaceSm),
                _buildHighlightedText(
                  context,
                  note.summary,
                  highlight,
                  ADSTypography.body.copyWith(color: bodyColor),
                  ADSTypography.body.copyWith(
                      color: ADSColors.lightSuccess,
                      fontWeight: FontWeight.w700),
                  maxLines: 2,
                ),
                const SizedBox(height: ADSSpacing.spaceSm),
                Row(
                  children: [
                    AppTextCaption(_formatDate(note.createdAt)),
                   
                    
                    const Spacer(),
                    AppTextCaption(_formatDuration(note.duration)),
                    const SizedBox(width: ADSSpacing.spaceLg),
                    const Icon(Icons.play_arrow, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建支持高亮的文本
  Widget _buildHighlightedText(
    BuildContext context,
    String text,
    String? query,
    TextStyle baseStyle,
    TextStyle highlightStyle, {
    int? maxLines,
  }) {
    if (query == null || query.trim().isEmpty) {
      return Text(
        text,
        style: baseStyle,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }
    final String q = query.trim();
    final RegExp reg = RegExp(RegExp.escape(q), caseSensitive: false);
    final List<TextSpan> spans = [];
    int start = 0;
    for (final m in reg.allMatches(text)) {
      if (m.start > start) {
        spans.add(
            TextSpan(text: text.substring(start, m.start), style: baseStyle));
      }
      spans.add(TextSpan(
          text: text.substring(m.start, m.end), style: highlightStyle));
      start = m.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: baseStyle));
    }
    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: spans),
    );
  }
}


