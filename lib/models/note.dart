
class Note {
  final String id;
  final String title;
  final String summary;
  final String transcription;
  final DateTime createdAt;
  final Duration duration;
  final String? audioPath;

  const Note({
    required this.id,
    required this.title,
    required this.summary,
    required this.transcription,
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
        transcription:
            'Today we discussed the project milestones and upcoming sprint planning. The team agreed on focusing on the user authentication module first, followed by the dashboard redesign. We need to complete the API integration by next Friday and have the testing phase ready by the end of the month.',
        createdAt: DateTime(2025, 9, 5, 10, 30),
        duration: const Duration(minutes: 2, seconds: 34),
        audioPath: null,
      ),
      Note(
        id: '2',
        title: 'Book Ideas',
        summary:
            'Productivity insights on deep work blocks and energy management...',
        transcription:
            'I was reading about deep work and how to manage energy throughout the day. The key insights are about creating focused blocks of time without distractions, taking regular breaks to maintain mental energy, and understanding your natural energy rhythms to schedule demanding tasks during peak hours.',
        createdAt: DateTime(2025, 9, 3, 9, 45),
        duration: const Duration(minutes: 3, seconds: 21),
        audioPath: null,
      ),
      Note(
        id: '3',
        title: 'Creative Ideas',
        summary:
            'User onboarding improvements and dashboard quick actions brainstorming...',
        transcription:
            'Brainstorming session for improving user onboarding flow. Ideas include adding interactive tutorials, simplifying the initial setup process, and creating quick action buttons on the dashboard for common tasks. We should also consider adding progress indicators to help users understand where they are in the setup process.',
        createdAt: DateTime(2025, 9, 4, 14, 15),
        duration: const Duration(minutes: 1, seconds: 52),
        audioPath: null,
      ),
    ];


