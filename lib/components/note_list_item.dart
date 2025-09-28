import 'package:flutter/material.dart';
import 'package:echonotes/design/app_design_system.dart';
import 'package:echonotes/components/app_card.dart';
import 'package:echonotes/components/app_text.dart';
import 'package:echonotes/models/note.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;

  const NoteListItem({super.key, required this.note, this.onTap});

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
    return AppCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextTitle(note.title),
                const SizedBox(height: ADSSpacing.spaceSm),
                AppTextBody(
                  note.summary,
                  color: ADSColors.lightTextSecondary,
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
}


