import 'package:flutter/foundation.dart';

class Note {
  final String id;
  final String title;
  final String summary;
  final DateTime createdAt;
  final Duration duration;
  final String? audioPath;

  const Note({
    required this.id,
    required this.title,
    required this.summary,
    required this.createdAt,
    required this.duration,
    this.audioPath,
  });
}

List<Note> demoNotes() => [
      Note(
        id: '1',
        title: 'Meeting Notes',
        summary:
            'Project milestones discussion with team – next sprint focus and deadlines...',
        createdAt: DateTime(2025, 9, 5, 10, 30),
        duration: const Duration(minutes: 2, seconds: 34),
      ),
      Note(
        id: '2',
        title: 'Book Ideas',
        summary:
            'Productivity insights on deep work blocks and energy management...',
        createdAt: DateTime(2025, 9, 3, 9, 45),
        duration: const Duration(minutes: 3, seconds: 21),
      ),
      Note(
        id: '3',
        title: 'Creative Ideas',
        summary:
            'User onboarding improvements and dashboard quick actions brainstorming...',
        createdAt: DateTime(2025, 9, 4, 14, 15),
        duration: const Duration(minutes: 1, seconds: 52),
      ),
    ];


