import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/app_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.isParentMode, required this.latestScore, required this.onOpenParenting, required this.onOpenLearning, required this.onOpenAssistant, required this.onAction});
  final bool isParentMode; final int latestScore; final VoidCallback onOpenParenting; final VoidCallback onOpenLearning; final VoidCallback onOpenAssistant; final VoidCallback onAction;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(18, 12, 18, 26), children: [
        Text(isParentMode ? 'A little room to grow' : 'Hello, curious mind!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)), const SizedBox(height: 6),
        Text(isParentMode ? 'Small moments make strong connections.' : 'What would you like to explore today?', style: const TextStyle(color: AppColors.muted, fontSize: 15)), const SizedBox(height: 20),
        _TodayFeature(onTap: () { onAction(); onOpenLearning(); }), const SizedBox(height: 18),
        Row(children: [Expanded(child: _MetricTile(icon: Icons.local_fire_department_rounded, value: '3 days', label: 'learning streak', color: AppColors.coral)), const SizedBox(width: 10), Expanded(child: _MetricTile(icon: Icons.stars_rounded, value: '$latestScore%', label: 'latest quiz', color: AppColors.teal))]),
        const SizedBox(height: 25), const SectionHeading(title: 'Choose your path'), const SizedBox(height: 10),
        _PathTile(title: 'Understand your child', subtitle: 'Parenting reflections and gentle quizzes', icon: Icons.favorite_rounded, color: const Color(0xFFF4E4D6), onTap: () { onAction(); onOpenParenting(); }), const SizedBox(height: 10),
        _PathTile(title: 'Learn through play', subtitle: 'Stories, science, words, drawing and more', icon: Icons.auto_awesome_rounded, color: const Color(0xFFDCEFE4), onTap: () { onAction(); onOpenLearning(); }), const SizedBox(height: 10),
        _PathTile(title: 'Ask a guide', subtitle: 'Explore a question together', icon: Icons.chat_rounded, color: const Color(0xFFE8E8F4), onTap: () { onAction(); onOpenAssistant(); }), const SizedBox(height: 24),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFFFF0C9), borderRadius: BorderRadius.circular(12)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.lightbulb_outline_rounded, color: AppColors.ink), SizedBox(width: 12), Expanded(child: Text('Try asking: “What was one good moment in your day?”', style: TextStyle(color: AppColors.ink, height: 1.35, fontWeight: FontWeight.w600)))])),
      ]);
}

class _TodayFeature extends StatelessWidget {
  const _TodayFeature({required this.onTap}); final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(color: AppColors.deepTeal, borderRadius: BorderRadius.circular(16), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Stack(children: [
        Positioned(right: 15, top: 13, child: Icon(Icons.auto_awesome_rounded, color: AppColors.marigold.withValues(alpha: 0.9), size: 28)),
        Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const LabelPill(label: 'TODAY’S LITTLE ADVENTURE', color: AppColors.marigold), const SizedBox(height: 13),
          const Text('Make something\nwith your imagination', style: TextStyle(color: Colors.white, fontSize: 22, height: 1.15, fontWeight: FontWeight.w800)), const SizedBox(height: 8),
          const Text('A few minutes. Your own idea.', style: TextStyle(color: Color(0xFFD7E9E2))), const SizedBox(height: 17),
          FilledButton.tonalIcon(onPressed: onTap, icon: const Icon(Icons.draw_rounded, size: 18), label: const Text('Open sketch garden'), style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.deepTeal)),
        ])),
      ])));
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.icon, required this.value, required this.label, required this.color});
  final IconData icon; final String value; final String label; final Color color;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.line)), child: Row(children: [Icon(icon, color: color, size: 23), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)), Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 11.5))]))]));
}

class _PathTile extends StatelessWidget {
  const _PathTile({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  final String title; final String subtitle; final IconData icon; final Color color; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
        Container(width: 46, height: 46, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.ink)), const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 12.5, color: AppColors.muted))])), const Icon(Icons.arrow_forward_rounded, color: AppColors.teal, size: 20),
      ]))));
}