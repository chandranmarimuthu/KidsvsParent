import 'package:flutter/material.dart';
import '../app_theme.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>(); final _messageController = TextEditingController();
  String _topic = 'App feedback'; bool _submitted = false;
  @override
  void dispose() { _messageController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Contact and help')), body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(20), children: [
        Text('We’re listening', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 6),
        const Text('For a child’s safety, a parent or guardian should send this message.', style: TextStyle(color: AppColors.muted, height: 1.4)), const SizedBox(height: 20),
        DropdownButtonFormField<String>(initialValue: _topic, decoration: const InputDecoration(labelText: 'What is this about?'), items: const ['App feedback', 'Learning content', 'Privacy question', 'Other'].map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (value) => setState(() => _topic = value ?? _topic)),
        const SizedBox(height: 12),
        TextFormField(controller: _messageController, minLines: 5, maxLines: 8, maxLength: 1000, decoration: const InputDecoration(labelText: 'Message', alignLabelWithHint: true, hintText: 'Share your question or feedback'), validator: (value) => value == null || value.trim().length < 8 ? 'Please add a little more detail.' : null),
        const SizedBox(height: 10),
        FilledButton.icon(onPressed: () { if (_formKey.currentState?.validate() ?? false) setState(() => _submitted = true); }, icon: const Icon(Icons.send_rounded), label: const Text('Prepare message')),
        if (_submitted) ...[const SizedBox(height: 14), const Text('Your message is ready. A support delivery channel must be connected before release.', style: TextStyle(color: AppColors.deepTeal, height: 1.4))],
      ])));
}