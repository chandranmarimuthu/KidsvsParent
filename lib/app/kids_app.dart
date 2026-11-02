import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_theme.dart';
import '../screens/assistant_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/home_screen.dart';
import '../screens/learning_screen.dart';
import '../screens/parenting_screen.dart';
import '../screens/settings_screen.dart';
import '../models/content.dart';
import '../services/local_question_store.dart';

class KidsApp extends StatelessWidget {
  const KidsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(title: 'Grow Together', debugShowCheckedModeBanner: false, theme: AppTheme.light, home: const AppShell());
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final LocalQuestionStore _questionStore = const LocalQuestionStore();
  int _selectedIndex = 0;
  bool _isParentMode = true;
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;
  int _lastScore = 0;
  List<QuizQuestion> _importedQuestions = const [];
  String? _questionFileName;
  String? _questionImportMessage;
  bool _isImportingQuestions = false;

  @override
  void initState() {
    super.initState();
    _loadQuestionSet();
  }

  Future<void> _loadQuestionSet() async {
    try {
      final saved = await _questionStore.load();
      if (!mounted || saved == null) return;
      setState(() {
        _importedQuestions = saved.questions;
        _questionFileName = saved.fileName;
      });
    } on FormatException catch (error) {
      if (mounted) setState(() => _questionImportMessage = error.message);
    } catch (_) {
      // Local question storage is only available on supported platforms.
    }
  }

  Future<void> _importQuestionSet() async {
    setState(() {
      _isImportingQuestions = true;
      _questionImportMessage = null;
    });
    try {
      final imported = await _questionStore.pickAndSave();
      if (!mounted || imported == null) return;
      setState(() {
        _importedQuestions = imported.questions;
        _questionFileName = imported.fileName;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported ${imported.questions.length} questions across ${imported.questions.map((question) => question.learningPathId).toSet().length} learning paths.')));
    } on FormatException catch (error) {
      if (mounted) setState(() => _questionImportMessage = error.message);
    } catch (error) {
      if (mounted) setState(() => _questionImportMessage = 'Could not import this file: $error');
    } finally {
      if (mounted) setState(() => _isImportingQuestions = false);
    }
  }

  Future<void> _removeQuestionSet() async {
    try {
      await _questionStore.clear();
      if (mounted) {
        setState(() {
          _importedQuestions = const [];
          _questionFileName = null;
          _questionImportMessage = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _questionImportMessage = 'Could not remove the saved file: $error');
    }
  }

  Future<void> _playAction() async {
    if (_soundEnabled) await SystemSound.play(SystemSoundType.click);
    if (_hapticsEnabled) await HapticFeedback.selectionClick();
  }

  void _recordQuiz(int score, int total) => setState(() => _lastScore = total == 0 ? 0 : (score * 100 ~/ total));

  Future<void> _openSettings() async {
    await Navigator.of(context).push<void>(MaterialPageRoute(
      builder: (_) => SettingsScreen(
        soundEnabled: _soundEnabled,
        hapticsEnabled: _hapticsEnabled,
        onSoundChanged: (value) => setState(() => _soundEnabled = value),
        onHapticsChanged: (value) => setState(() => _hapticsEnabled = value),
        onOpenContact: () => Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const ContactScreen())),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          titleSpacing: 18,
          title: const Row(children: [Icon(Icons.eco_rounded, color: AppColors.teal, size: 25), SizedBox(width: 8), Text('Grow Together')]),
          actions: [
            PopupMenuButton<bool>(
              tooltip: 'Choose your space',
              initialValue: _isParentMode,
              onSelected: (value) => setState(() => _isParentMode = value),
              itemBuilder: (context) => const [PopupMenuItem(value: true, child: Text('Parent space')), PopupMenuItem(value: false, child: Text('Kids space'))],
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Icon(_isParentMode ? Icons.family_restroom_rounded : Icons.child_care_rounded, color: AppColors.ink)),
            ),
            IconButton(tooltip: 'Settings', onPressed: _openSettings, icon: const Icon(Icons.tune_rounded)),
            const SizedBox(width: 4),
          ],
        ),
        body: IndexedStack(index: _selectedIndex, children: [
          HomeScreen(isParentMode: _isParentMode, latestScore: _lastScore, onOpenParenting: () => setState(() => _selectedIndex = 1), onOpenLearning: () => setState(() => _selectedIndex = 2), onOpenAssistant: () => setState(() => _selectedIndex = 3), onAction: _playAction),
          ParentingScreen(isParentMode: _isParentMode, onSwitchToParent: () => setState(() => _isParentMode = true), onQuizCompleted: _recordQuiz, onAction: _playAction, questionFileName: _questionFileName, importedQuestions: _importedQuestions, importMessage: _questionImportMessage, isImportingQuestions: _isImportingQuestions, onImportQuestions: _importQuestionSet, onRemoveQuestions: _questionFileName == null ? null : _removeQuestionSet),
          LearningScreen(onQuizCompleted: _recordQuiz, onAction: _playAction, importedQuestions: _importedQuestions),
          const AssistantScreen(),
        ]),
        bottomNavigationBar: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) { _playAction(); setState(() => _selectedIndex = index); },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.diversity_3_rounded), label: 'Parents'),
              NavigationDestination(icon: Icon(Icons.auto_stories_rounded), label: 'Learn'),
              NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Ask'),
            ],
          ),
        ),
      );
}