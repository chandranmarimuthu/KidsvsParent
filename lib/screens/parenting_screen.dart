import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/content.dart';
import '../widgets/app_widgets.dart';
import '../widgets/quiz_runner.dart';

class ParentingScreen extends StatelessWidget {
  const ParentingScreen({super.key, required this.isParentMode, required this.onSwitchToParent, required this.onQuizCompleted, required this.onAction, required this.questionFileName, required this.importedQuestions, required this.importMessage, required this.isImportingQuestions, required this.onImportQuestions, required this.onRemoveQuestions});
  final bool isParentMode; final VoidCallback onSwitchToParent; final void Function(int score, int total) onQuizCompleted; final VoidCallback onAction;
  final String? questionFileName;
  final List<QuizQuestion> importedQuestions;
  final String? importMessage;
  final bool isImportingQuestions;
  final VoidCallback onImportQuestions;
  final VoidCallback? onRemoveQuestions;
  @override
  Widget build(BuildContext context) {
    if (!isParentMode) return Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.lock_outline_rounded, size: 48, color: AppColors.teal), const SizedBox(height: 14),
      Text('Grown-up space', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8),
      const Text('Ask a parent to switch to their space.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)), const SizedBox(height: 18),
      FilledButton.icon(onPressed: onSwitchToParent, icon: const Icon(Icons.family_restroom_rounded), label: const Text('Parent space')),
    ])));
    return ListView(padding: const EdgeInsets.fromLTRB(18, 12, 18, 26), children: [
      Text('Parenting', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 6),
      const Text('A few thoughtful ideas for the everyday moments.', style: TextStyle(color: AppColors.muted)), const SizedBox(height: 15),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF4E4D6), borderRadius: BorderRadius.circular(12)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.favorite_border_rounded, color: AppColors.ink), SizedBox(width: 11), Expanded(child: Text('These reflections help adults learn. They do not diagnose or rank a child.', style: TextStyle(color: AppColors.ink, height: 1.35)))])),
      const SizedBox(height: 14),
      _LearningLibraryAdmin(fileName: questionFileName, questions: importedQuestions, message: importMessage, isImporting: isImportingQuestions, onImport: onImportQuestions, onRemove: onRemoveQuestions),
      const SizedBox(height: 20), const SectionHeading(title: 'Explore a topic'), const SizedBox(height: 8),
      ...AppContent.parentTopics.map((topic) => Padding(padding: const EdgeInsets.only(bottom: 9), child: TopicTile(title: topic.title, subtitle: topic.subtitle, icon: topic.icon, color: topic.color, onTap: () {
        onAction(); Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => ParentTopicScreen(topic: topic, onQuizCompleted: onQuizCompleted)));
      }))),
    ]);
  }
}

class _LearningLibraryAdmin extends StatelessWidget {
  const _LearningLibraryAdmin({required this.fileName, required this.questions, required this.message, required this.isImporting, required this.onImport, required this.onRemove});
  final String? fileName;
  final List<QuizQuestion> questions;
  final String? message;
  final bool isImporting;
  final VoidCallback onImport;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final question in questions) {
      final pathId = question.learningPathId;
      if (pathId != null) counts.update(pathId, (count) => count + 1, ifAbsent: () => 1);
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [Icon(Icons.admin_panel_settings_outlined, color: AppColors.deepTeal), SizedBox(width: 9), Expanded(child: Text('Kids learning library', style: TextStyle(fontWeight: FontWeight.w800)))]),
          const SizedBox(height: 6),
          const Text('Manage daily quiz questions for each learning path. Files are stored on this device.', style: TextStyle(color: AppColors.muted, height: 1.35)),
          const SizedBox(height: 8),
          const Text('Required: question_id, path_id, question, option1, option2, answer. Options 3 and 4 and explanation are optional.', style: TextStyle(fontSize: 12, height: 1.35)),
          const SizedBox(height: 5),
          const Text('Allowed path IDs:', style: TextStyle(color: AppColors.muted, fontSize: 12)),
          Wrap(spacing: 5, runSpacing: 0, children: [
            for (final topic in AppContent.learningTopics) Chip(visualDensity: VisualDensity.compact, label: Text(topic.id)),
          ]),
          if (fileName != null) ...[
            const SizedBox(height: 8),
            Text('$fileName · ${questions.length} questions', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 5),
            Wrap(spacing: 6, runSpacing: 0, children: [
              for (final topic in AppContent.learningTopics)
                if (counts.containsKey(topic.id)) Chip(visualDensity: VisualDensity.compact, label: Text('${topic.id} · ${counts[topic.id]}')),
            ]),
          ],
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(message!, style: const TextStyle(color: AppColors.coral, height: 1.35)),
          ],
          const SizedBox(height: 8),
          Wrap(spacing: 10, runSpacing: 8, children: [
            OutlinedButton.icon(
              onPressed: isImporting ? null : onImport,
              icon: isImporting ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.file_upload_outlined),
              label: Text(isImporting ? 'Reading CSV…' : 'Import learning CSV'),
            ),
            if (onRemove != null) TextButton.icon(onPressed: onRemove, icon: const Icon(Icons.delete_outline_rounded), label: const Text('Remove saved file')),
          ]),
        ]),
      ),
    );
  }
}

class ParentTopicScreen extends StatelessWidget {
  const ParentTopicScreen({super.key, required this.topic, required this.onQuizCompleted});
  final ParentTopic topic; final void Function(int score, int total) onQuizCompleted;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(topic.title)), body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: topic.color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(topic.icon, size: 34, color: AppColors.ink), const SizedBox(height: 12), Text(topic.subtitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))])),
        const SizedBox(height: 20), Text('A thought to try', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 7),
        Text(topic.guidance, style: const TextStyle(color: AppColors.muted, height: 1.5, fontSize: 15)), const SizedBox(height: 24),
        FilledButton.icon(onPressed: () => Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => QuizRunnerScreen(title: '${topic.title} check-in', questions: topic.questions, onFinished: onQuizCompleted))), icon: const Icon(Icons.quiz_rounded), label: const Text('Try a short quiz')),
        const SizedBox(height: 12), const Text('Your score reflects this practice round only.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, fontSize: 12)),
      ]));
}