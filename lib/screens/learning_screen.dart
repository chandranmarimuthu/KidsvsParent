import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/content.dart';
import '../widgets/app_widgets.dart';
import '../widgets/learning_visual.dart';
import '../widgets/quiz_runner.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key, required this.onQuizCompleted, required this.onAction, required this.importedQuestions});
  final void Function(int score, int total) onQuizCompleted; final VoidCallback onAction;
  final List<QuizQuestion> importedQuestions;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(18, 12, 18, 26), children: [
        Text('Learning garden', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 6),
        const Text('Pick a path. There is more than one way to learn.', style: TextStyle(color: AppColors.muted)), const SizedBox(height: 18),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: AppContent.learningTopics.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, mainAxisExtent: 151), itemBuilder: (context, index) {
          final topic = AppContent.learningTopics[index];
          return _LearningTile(topic: topic, onTap: () { onAction(); Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => LearningDetailScreen(topic: topic, onQuizCompleted: onQuizCompleted, importedQuestions: importedQuestions))); });
        }),
      ]);
}

class _LearningTile extends StatelessWidget {
  const _LearningTile({required this.topic, required this.onTap});
  final LearningTopic topic; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(color: Colors.white, borderRadius: BorderRadius.circular(12), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.line)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 43, height: 43, decoration: BoxDecoration(color: topic.color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: Icon(topic.icon, color: AppColors.ink)), const Spacer(),
        Text(topic.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)), const SizedBox(height: 3),
        Text(topic.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11.5, height: 1.2)),
      ]))));
}

class LearningDetailScreen extends StatelessWidget {
  const LearningDetailScreen({super.key, required this.topic, required this.onQuizCompleted, this.importedQuestions = const []});
  final LearningTopic topic; final void Function(int score, int total) onQuizCompleted;
  final List<QuizQuestion> importedQuestions;
  @override
  Widget build(BuildContext context) {
    final questions = AppContent.dailyQuizForPath(topic.id, DateTime.now(), importedQuestions: importedQuestions);
    return Scaffold(appBar: AppBar(title: Text(topic.title)), body: ListView(padding: const EdgeInsets.all(20), children: [
          Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: topic.color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(topic.icon, size: 35, color: AppColors.ink), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(topic.subtitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(topic.description, style: const TextStyle(color: AppColors.ink, height: 1.35))]))])),
          const SizedBox(height: 14),
          LearningPathIllustration(pathId: topic.id, accentColor: topic.color),
          const SizedBox(height: 18), _TopicActivity(topic: topic), const SizedBox(height: 22),
          Text('Today’s ${questions.length}-question quiz', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Questions rotate by date and use only this learning path’s question bank.', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 10),
          FilledButton.icon(onPressed: () => Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => QuizRunnerScreen(title: '${topic.title} · today', questions: questions, onFinished: onQuizCompleted))), icon: const Icon(Icons.quiz_rounded), label: Text('Start today’s ${questions.length}-question quiz')),
        ]));
  }
}

class _TopicActivity extends StatelessWidget {
  const _TopicActivity({required this.topic}); final LearningTopic topic;
  @override
  Widget build(BuildContext context) => switch (topic.kind) {
        LearningKind.dictionary => const _DictionaryActivity(),
        LearningKind.kural => const _KuralActivity(),
        LearningKind.tracing => _ActivityLaunch(title: 'Letter practice', subtitle: 'Trace the letter A, then try it without a guide.', icon: Icons.gesture_rounded, onTap: () => _openCanvas(context, 'Letter studio', 'A')),
        LearningKind.drawing => _ActivityLaunch(title: 'Open the sketchpad', subtitle: 'Choose a color and draw anything you imagine.', icon: Icons.draw_rounded, onTap: () => _openCanvas(context, 'Sketch garden', null)),
        LearningKind.story => const _StoryActivity(),
        LearningKind.regular when topic.title == 'Science around us' => const _ScienceActivity(),
        LearningKind.regular => _IdeaActivity(topic: topic),
      };
  void _openCanvas(BuildContext context, String title, String? guide) => Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => PracticeCanvasScreen(title: title, guide: guide)));
}

class _DictionaryActivity extends StatelessWidget {
  const _DictionaryActivity();
  @override
  Widget build(BuildContext context) {
    const words = [('Curious', 'ஆர்வம்', 'Wanting to learn or know more.'), ('Observe', 'கவனி', 'To notice something carefully.'), ('Kindness', 'அன்பு', 'Being thoughtful and caring.')];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Today’s words', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 9), ...words.map((word) => Card(margin: const EdgeInsets.only(bottom: 8), child: Padding(padding: const EdgeInsets.all(13), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(word.$1, style: const TextStyle(fontWeight: FontWeight.w800)), Text(word.$3, style: const TextStyle(color: AppColors.muted, fontSize: 12))])), Text(word.$2, style: const TextStyle(fontSize: 17, color: AppColors.deepTeal, fontWeight: FontWeight.w700))]))))]);
  }
}

class _KuralActivity extends StatelessWidget {
  const _KuralActivity();
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFFFF0C9), borderRadius: BorderRadius.circular(12)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LabelPill(label: 'KURAL 1', color: Colors.white), const SizedBox(height: 13),
        Text('அகர முதல எழுத்தெல்லாம் ஆதி\nபகவன் முதற்றே உலகு', style: TextStyle(fontSize: 21, height: 1.6, fontWeight: FontWeight.w700, color: AppColors.ink)), const SizedBox(height: 12),
        Text('A is the first of letters; a beginning gives shape to the world.', style: TextStyle(color: AppColors.ink, height: 1.4)), const SizedBox(height: 8),
        Text('A child-friendly paraphrase', style: TextStyle(color: AppColors.muted, fontSize: 12)),
      ]));
}

class _StoryActivity extends StatelessWidget {
  const _StoryActivity();
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: const Color(0xFFE6F0DF), borderRadius: BorderRadius.circular(12)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('The seed that kept trying', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)), SizedBox(height: 9), Text('A tiny seed rested under the soil. Each day it reached a little higher. The rain came, the sun returned, and one morning a green shoot waved hello. It had not hurried. It had simply kept growing.', style: TextStyle(height: 1.5, color: AppColors.ink))]));
}

class _IdeaActivity extends StatelessWidget {
  const _IdeaActivity({required this.topic}); final LearningTopic topic;
  @override
  Widget build(BuildContext context) {
    final suggestions = switch (topic.title) {
      'Code patterns' => const ['Give a pretend robot three steps to reach a book.', 'Swap one step and see what changes.'],
      'Puzzle path' => const ['Find something nearby with a repeated pattern.', 'Guess what might come next, then check.'],
      'Science around us' => const ['Notice a plant or patch of sunlight.', 'Ask what changed and what stayed the same.'],
      _ => const ['Look closely at one thing around you.', 'Ask a question and try one small idea.'],
    };
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Try this', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 10), ...suggestions.asMap().entries.map((entry) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 27, height: 27, decoration: const BoxDecoration(color: AppColors.mint, shape: BoxShape.circle), child: Center(child: Text('${entry.key + 1}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.deepTeal)))), const SizedBox(width: 10), Expanded(child: Padding(padding: const EdgeInsets.only(top: 3), child: Text(entry.value, style: const TextStyle(height: 1.35))))])))]);
  }
}

class _ActivityLaunch extends StatelessWidget {
  const _ActivityLaunch({required this.title, required this.subtitle, required this.icon, required this.onTap});
  final String title; final String subtitle; final IconData icon; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7), leading: Icon(icon, color: AppColors.teal, size: 27), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(subtitle), trailing: const Icon(Icons.arrow_forward_rounded), onTap: onTap));
}

class PracticeCanvasScreen extends StatefulWidget {
  const PracticeCanvasScreen({super.key, required this.title, this.guide});
  final String title; final String? guide;
  @override
  State<PracticeCanvasScreen> createState() => _PracticeCanvasScreenState();
}

class _PracticeCanvasScreenState extends State<PracticeCanvasScreen> {
  final List<Offset?> _strokes = []; Color _ink = AppColors.teal;
  @override
  Widget build(BuildContext context) {
    const palette = [AppColors.teal, AppColors.coral, Color(0xFFE4AD36), AppColors.lilac, AppColors.ink];
    return Scaffold(appBar: AppBar(title: Text(widget.title), actions: [IconButton(tooltip: 'Clear drawing', onPressed: () => setState(_strokes.clear), icon: const Icon(Icons.delete_outline_rounded))]), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      Row(
        children: [
          for (final color in palette)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () => setState(() => _ink = color),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _ink == color ? AppColors.ink : Colors.white,
                      width: _ink == color ? 2 : 1,
                    ),
                  ),
                ),
              ),
            ),
          const Spacer(),
          const Text('Use your finger', style: TextStyle(color: AppColors.muted, fontSize: 12)),
        ],
      ),
      const SizedBox(height: 14),
      Expanded(
        child: Semantics(
          label: widget.guide == null ? 'Drawing area' : 'Letter tracing area',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Colors.white),
              child: GestureDetector(
                onPanStart: (details) => setState(() => _strokes.add(details.localPosition)),
                onPanUpdate: (details) => setState(() => _strokes.add(details.localPosition)),
                onPanEnd: (_) => setState(() => _strokes.add(null)),
                child: CustomPaint(
                  painter: _PracticePainter(_strokes, _ink, widget.guide),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 14), SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.check_rounded), label: const Text('Done for now'))),
    ])));
  }
}

class _PracticePainter extends CustomPainter {
  const _PracticePainter(this.points, this.color, this.guide);
  final List<Offset?> points; final Color color; final String? guide;
  @override
  void paint(Canvas canvas, Size size) {
    if (guide != null) {
      final textPainter = TextPainter(text: TextSpan(text: guide, style: const TextStyle(fontSize: 200, fontWeight: FontWeight.w700, color: Color(0xFFE8ECE8))), textDirection: TextDirection.ltr)..layout();
      textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2));
    }
    final paint = Paint()..color = color..strokeWidth = 8..strokeCap = StrokeCap.round;
    for (var index = 0; index < points.length - 1; index++) { final start = points[index]; final end = points[index + 1]; if (start != null && end != null) canvas.drawLine(start, end, paint); }
  }
  @override
  bool shouldRepaint(covariant _PracticePainter oldDelegate) => oldDelegate.points != points || oldDelegate.color != color || oldDelegate.guide != guide;
}

class _ScienceActivity extends StatelessWidget {
  const _ScienceActivity();
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Science notebook', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        const Text('Read an idea, then look for evidence around you.', style: TextStyle(color: AppColors.muted)),
        const SizedBox(height: 10),
        ...AppContent.scienceLessons.asMap().entries.map((entry) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 15),
                title: Text(entry.value.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                children: [
                  ScienceConceptIllustration(index: entry.key),
                  const SizedBox(height: 12),
                  Align(alignment: Alignment.centerLeft, child: Text(entry.value.explanation, style: const TextStyle(height: 1.4))),
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: Text('Try noticing: ${entry.value.observation}', style: const TextStyle(color: AppColors.deepTeal, height: 1.4, fontWeight: FontWeight.w600))),
                ],
              ),
            )),
      ]);
}