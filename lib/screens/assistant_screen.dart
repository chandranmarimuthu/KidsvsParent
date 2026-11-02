import 'package:flutter/material.dart';
import '../app_theme.dart';

class _ChatMessage {
  const _ChatMessage(this.text, {required this.fromGuide});
  final String text; final bool fromGuide;
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});
  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _controller = TextEditingController(); final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [const _ChatMessage('Hi! What are you wondering about today?', fromGuide: true)];
  @override
  void dispose() { _controller.dispose(); _scrollController.dispose(); super.dispose(); }
  void _send() {
    final text = _controller.text.trim(); if (text.isEmpty) return;
    setState(() { _messages.add(_ChatMessage(text, fromGuide: false)); _messages.add(_ChatMessage(_localReply(text), fromGuide: true)); _controller.clear(); });
    WidgetsBinding.instance.addPostFrameCallback((_) { if (_scrollController.hasClients) _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 220), curve: Curves.easeOut); });
  }
  String _localReply(String prompt) {
    final value = prompt.toLowerCase();
    if (value.contains('plant') || value.contains('sun') || value.contains('science')) return 'Plants use sunlight, water, and air to make food. What do you notice about a plant near you?';
    if (value.contains('feel') || value.contains('friend') || value.contains('sad')) return 'Feelings can give us clues about what we need. You could tell a trusted grown-up what happened and how it felt.';
    if (value.contains('stress') || value.contains('worry') || value.contains('hard')) return 'Try one slow breath, then choose one small next step. A parent or trusted adult can help you think it through.';
    return 'That is a thoughtful question. Start by noticing what you already know, then explore it with a parent or trusted grown-up.';
  }
  @override
  Widget build(BuildContext context) => Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(18, 14, 18, 12), child: Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFE8E8F4), borderRadius: BorderRadius.circular(12)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.forum_rounded, color: AppColors.ink), SizedBox(width: 11), Expanded(child: Text('Preview answers use built-in examples. Live AI and voice need a secure parent-approved connection.', style: TextStyle(height: 1.35, color: AppColors.ink)))]))),
        Expanded(child: ListView.builder(controller: _scrollController, padding: const EdgeInsets.fromLTRB(18, 4, 18, 16), itemCount: _messages.length, itemBuilder: (context, index) => _MessageBubble(message: _messages[index]))),
        Padding(padding: EdgeInsets.fromLTRB(14, 8, 14, MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 14), child: SafeArea(top: false, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          IconButton.filledTonal(tooltip: 'Voice questions', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice questions need a secure parent-approved connection.'))), icon: const Icon(Icons.mic_rounded)), const SizedBox(width: 8),
          Expanded(child: TextField(controller: _controller, minLines: 1, maxLines: 4, textInputAction: TextInputAction.send, onSubmitted: (_) => _send(), decoration: const InputDecoration(hintText: 'Ask a question…', contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12)))),
          const SizedBox(width: 8), IconButton.filled(tooltip: 'Send question', onPressed: _send, icon: const Icon(Icons.arrow_upward_rounded)),
        ]))),
      ]);
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message}); final _ChatMessage message;
  @override
  Widget build(BuildContext context) => Align(alignment: message.fromGuide ? Alignment.centerLeft : Alignment.centerRight, child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.82), margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(color: message.fromGuide ? Colors.white : AppColors.mint, borderRadius: BorderRadius.only(topLeft: const Radius.circular(14), topRight: const Radius.circular(14), bottomLeft: Radius.circular(message.fromGuide ? 4 : 14), bottomRight: Radius.circular(message.fromGuide ? 14 : 4)), border: message.fromGuide ? Border.all(color: AppColors.line) : null),
        child: Text(message.text, style: const TextStyle(height: 1.4, color: AppColors.ink)),
      ));
}