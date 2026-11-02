import 'package:flutter/material.dart';
import '../app_theme.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title, this.action, this.onAction});
  final String title; final String? action; final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w800))), if (action != null && onAction != null) TextButton(onPressed: onAction, child: Text(action!))]);
}

class TopicTile extends StatelessWidget {
  const TopicTile({super.key, required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});
  final String title; final String subtitle; final IconData icon; final Color color; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(child: InkWell(borderRadius: BorderRadius.circular(12), onTap: onTap, child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.ink, size: 25)), const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 12.5))])),
        const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
      ]))));
}

class LabelPill extends StatelessWidget {
  const LabelPill({super.key, required this.label, this.color = AppColors.mint});
  final String label; final Color color;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)), child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink)));
}