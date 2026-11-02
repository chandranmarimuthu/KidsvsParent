import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/content.dart';
import 'app_widgets.dart';

class QuizRunnerScreen extends StatefulWidget {
  const QuizRunnerScreen({super.key, required this.title, required this.questions, this.onFinished});
  final String title; final List<QuizQuestion> questions; final void Function(int score, int total)? onFinished;
  @override
  State<QuizRunnerScreen> createState() => _QuizRunnerScreenState();
}

class _QuizRunnerScreenState extends State<QuizRunnerScreen> {
  int _questionIndex = 0; int _selectedIndex = -1; int _score = 0; bool _answered = false; bool _finished = false;
  void _continue() {
    if (_selectedIndex < 0) return;
    final question = widget.questions[_questionIndex];
    if (!_answered) {
      setState(() {
        _answered = true;
        if (_selectedIndex == question.answerIndex) _score++;
      });
      return;
    }
    if (_questionIndex == widget.questions.length - 1) {
      setState(() => _finished = true);
      widget.onFinished?.call(_score, widget.questions.length);
      return;
    }
    setState(() { _questionIndex++; _selectedIndex = -1; _answered = false; });
  }
  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_questionIndex];
    return Scaffold(appBar: AppBar(title: Text(widget.title)), body: SafeArea(child: _finished ? _buildResult(context) : _buildQuestion(context, question)));
  }
  Widget _buildQuestion(BuildContext context, QuizQuestion question) => ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 28), children: [
        Row(children: [Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (_questionIndex + 1) / widget.questions.length, minHeight: 8, backgroundColor: AppColors.line, color: AppColors.teal))), const SizedBox(width: 12), Text('${_questionIndex + 1} of ${widget.questions.length}', style: const TextStyle(color: AppColors.muted))]),
        const SizedBox(height: 28), const LabelPill(label: 'A little check-in'), const SizedBox(height: 14),
        Text(question.prompt, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, height: 1.2)), const SizedBox(height: 24),
        ...List.generate(question.options.length, (index) {
          final isSelected = _selectedIndex == index;
          return Padding(padding: const EdgeInsets.only(bottom: 10), child: Material(color: isSelected ? AppColors.mint : Colors.white, borderRadius: BorderRadius.circular(12), child: InkWell(borderRadius: BorderRadius.circular(12), onTap: _answered ? null : () => setState(() => _selectedIndex = index), child: Container(
            constraints: const BoxConstraints(minHeight: 58), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? AppColors.teal : AppColors.line, width: isSelected ? 1.5 : 1)),
            child: Row(children: [Icon(isSelected ? Icons.check_circle_rounded : Icons.circle_outlined, color: isSelected ? AppColors.teal : AppColors.muted, size: 21), const SizedBox(width: 12), Expanded(child: Text(question.options[index], style: const TextStyle(fontWeight: FontWeight.w600)))]),
          ))));
        }),
        if (_answered) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(12)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(_selectedIndex == question.answerIndex ? Icons.check_circle_rounded : Icons.lightbulb_outline_rounded, color: AppColors.deepTeal),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_selectedIndex == question.answerIndex ? 'That’s right!' : 'Here’s a useful thought', style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(question.explanation, style: const TextStyle(height: 1.35)),
              ])),
            ]),
          ),
        ],
        const SizedBox(height: 18),
        FilledButton.icon(
          onPressed: _selectedIndex < 0 ? null : _continue,
          icon: Icon(_answered && _questionIndex == widget.questions.length - 1 ? Icons.check_rounded : Icons.arrow_forward_rounded),
          label: Text(!_answered ? 'Check answer' : (_questionIndex == widget.questions.length - 1 ? 'See my score' : 'Next')),
        ),
      ]);
  Widget _buildResult(BuildContext context) {
    final percent = widget.questions.isEmpty ? 0 : (_score * 100 ~/ widget.questions.length);
    return Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 100, height: 100, decoration: const BoxDecoration(color: AppColors.mint, shape: BoxShape.circle), child: const Icon(Icons.stars_rounded, size: 54, color: AppColors.teal)), const SizedBox(height: 22),
      Text('Nice work!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 8),
      Text('$_score of ${widget.questions.length} correct', style: const TextStyle(fontSize: 18, color: AppColors.ink)), const SizedBox(height: 4), Text('$percent% this round', style: const TextStyle(color: AppColors.muted)),
      const SizedBox(height: 16), const Text('A score is a snapshot of this practice, not a measure of a child.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)), const SizedBox(height: 28),
      FilledButton.icon(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.done_rounded), label: const Text('Back to activities')),
    ])));
  }
}