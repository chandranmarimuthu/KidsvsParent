import 'package:flutter/material.dart';
import '../app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.soundEnabled, required this.hapticsEnabled, required this.onSoundChanged, required this.onHapticsChanged, required this.onOpenContact});
  final bool soundEnabled; final bool hapticsEnabled; final ValueChanged<bool> onSoundChanged; final ValueChanged<bool> onHapticsChanged; final VoidCallback onOpenContact;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings')), body: ListView(padding: const EdgeInsets.fromLTRB(18, 10, 18, 24), children: [
        Text('Make it yours', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 6), const Text('Small comforts for your family.', style: TextStyle(color: AppColors.muted)), const SizedBox(height: 18),
        Card(child: SwitchListTile(secondary: const Icon(Icons.volume_up_rounded), title: const Text('Play action sounds'), subtitle: const Text('Short, gentle cues'), value: soundEnabled, onChanged: onSoundChanged)), const SizedBox(height: 8),
        Card(child: SwitchListTile(secondary: const Icon(Icons.vibration_rounded), title: const Text('Haptic feedback'), subtitle: const Text('A light touch on key actions'), value: hapticsEnabled, onChanged: onHapticsChanged)), const SizedBox(height: 8),
        const Card(child: ListTile(leading: Icon(Icons.translate_rounded), title: Text('Languages'), subtitle: Text('English learning with Tamil selections'))), const SizedBox(height: 8),
        const Card(child: ListTile(leading: Icon(Icons.accessibility_new_rounded), title: Text('Accessibility'), subtitle: Text('Large touch targets and readable text'))), const SizedBox(height: 8),
        const Card(child: ListTile(leading: Icon(Icons.shield_outlined), title: Text('Family privacy'), subtitle: Text('Parent controls and child-safe learning'))), const SizedBox(height: 18),
        OutlinedButton.icon(onPressed: onOpenContact, icon: const Icon(Icons.mail_outline_rounded), label: const Text('Contact and help')),
      ]));
}