// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kids_vs_parents/app/kids_app.dart';
import 'package:kids_vs_parents/models/content.dart';
import 'package:kids_vs_parents/services/local_question_store.dart';
import 'package:kids_vs_parents/widgets/learning_visual.dart';

void main() {
  test('CSV parser supports quoted values and rejects invalid answers', () {
    final questions = LocalQuestionStore.parseCsv(
      'question_id,path_id,question,option1,option2,answer,explanation\r\n'
      'science_water_01,science,"What does ""evaporate"" mean?","Liquid water, becoming gas",Ice,1,"Water vapor is a gas, formed from liquid water."',
    );

    expect(questions, hasLength(1));
    expect(questions.single.prompt, 'What does "evaporate" mean?');
    expect(questions.single.options.first, 'Liquid water, becoming gas');
    expect(questions.single.answerIndex, 0);
    expect(questions.single.id, 'science_water_01');
    expect(questions.single.learningPathId, 'science');
    expect(
      () => LocalQuestionStore.parseCsv('question_id,path_id,question,option1,option2,answer\nq1,science,Q,A,B,4'),
      throwsFormatException,
    );
    expect(
      () => LocalQuestionStore.parseCsv('question_id,path_id,question,option1,option2,answer\nq1,unknown,Q,A,B,1'),
      throwsFormatException,
    );
    expect(
      () => LocalQuestionStore.parseCsv('question_id,path_id,question,option1,option2,answer\nq1,science,Q,A,B,1\nq1,science,Q2,A,B,1'),
      throwsFormatException,
    );
  });

  test('example CSV assigns unique questions to every learning path', () async {
    final csv = await File('examples/learning_questions.csv').readAsString();
    final questions = LocalQuestionStore.parseCsv(csv);
    final pathIds = AppContent.learningTopics.map((topic) => topic.id).toSet();

    expect(questions, hasLength(18));
    expect(questions.map((question) => question.id).toSet(), hasLength(18));
    expect(questions.map((question) => question.learningPathId).toSet(), pathIds);
  });

  testWidgets('parent imports path-tagged questions from Parent space only', (WidgetTester tester) async {
    const channel = MethodChannel('kids_vs_parents/local_questions');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async => switch (call.method) {
          'loadCsv' => null,
          'pickCsv' => {
              'fileName': 'family_science.csv',
              'csv': 'question_id,path_id,question,option1,option2,answer,explanation\nfamily_science_01,science,What do roots take in?,Water,Light,1,Roots absorb water from soil.\nfamily_science_02,science,What helps a leaf make food?,Sunlight,Plastic,1,Sunlight gives a plant energy.',
            },
          'saveCsv' => true,
          _ => null,
        });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, null));
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const KidsApp());

    await tester.tap(find.text('Parents'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Import learning CSV'));
    await tester.pumpAndSettle();

    expect(find.text('family_science.csv · 2 questions'), findsOneWidget);
    expect(find.text('science · 2'), findsOneWidget);
    await tester.tap(find.text('Learn'));
    await tester.pumpAndSettle();
    expect(find.text('Import learning CSV'), findsNothing);
    expect(find.text('Choose CSV'), findsNothing);
  });

  test('science quiz selects five questions and rotates by date', () {
    final firstDay = AppContent.dailyScienceQuiz(DateTime(2026, 1, 1));
    final nextDay = AppContent.dailyScienceQuiz(DateTime(2026, 1, 2));
    const importedQuestion = QuizQuestion(prompt: 'Imported plant question', options: ['A', 'B'], answerIndex: 0, explanation: 'A fact.', id: 'science_q_001', learningPathId: 'science');
    const secondImportedQuestion = QuizQuestion(prompt: 'Imported shadow question', options: ['A', 'B'], answerIndex: 1, explanation: 'Another fact.', id: 'science_q_002', learningPathId: 'science');
    final quizWithImportedQuestion = AppContent.dailyScienceQuiz(
      DateTime(2026, 10, 31),
      additionalQuestions: const [importedQuestion, secondImportedQuestion],
    );
    const dictionaryQuestion = QuizQuestion(prompt: 'Imported word question', options: ['A', 'B'], answerIndex: 0, explanation: 'A word fact.', id: 'dictionary_q_001', learningPathId: 'dictionary');
    final pathQuiz = AppContent.dailyQuizForPath('science', DateTime(2026, 10, 31), importedQuestions: const [importedQuestion, dictionaryQuestion]);

    expect(firstDay, hasLength(5));
    expect(firstDay.map((question) => question.prompt).toSet(), hasLength(5));
    expect(firstDay.first.prompt, isNot(nextDay.first.prompt));
    expect(quizWithImportedQuestion, contains(importedQuestion));
    expect(AppContent.learningTopics.map((topic) => topic.id).toSet(), hasLength(AppContent.learningTopics.length));
    expect(pathQuiz, isNot(contains(dictionaryQuestion)));
  });

  testWidgets('learning and science illustrations render for every module', (WidgetTester tester) async {
    for (final topic in AppContent.learningTopics) {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: LearningPathIllustration(pathId: topic.id, accentColor: topic.color))));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull, reason: 'Failed to render ${topic.id} illustration');
      expect(find.byType(LearningPathIllustration), findsOneWidget);
    }
    for (var index = 0; index < AppContent.scienceLessons.length; index++) {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: ScienceConceptIllustration(index: index))));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull, reason: 'Failed to render science concept $index');
    }
  });

  testWidgets('science learning shows lesson content and a daily quiz', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const KidsApp());

    await tester.tap(find.text('Learn'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Science around us'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Science notebook'), findsOneWidget);
    expect(find.text('How plants make food'), findsOneWidget);
    expect(find.text('Start today’s 5-question quiz'), findsOneWidget);

    await tester.ensureVisible(find.text('Start today’s 5-question quiz'));
    await tester.tap(find.text('Start today’s 5-question quiz'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('1 of 5'), findsOneWidget);
  });

  testWidgets('assistant can switch tabs while its question field is focused', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 600);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(const KidsApp());

    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(
      tester.getCenter(find.text('Parents')).dy,
      lessThan(tester.view.physicalSize.height - tester.view.viewInsets.bottom),
    );
    await tester.tap(find.text('Parents'));
    await tester.pumpAndSettle();

    expect(find.text('Parenting'), findsOneWidget);
  });

  testWidgets('home opens the parenting topic section', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(900, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const KidsApp());
    expect(find.text('A little room to grow'), findsOneWidget);
    await tester.tap(find.text('Parents'));
    await tester.pumpAndSettle();
    expect(find.text('Parenting'), findsOneWidget);
    expect(find.text('Child’s emotions'), findsOneWidget);
    await tester.tap(find.text('Child’s emotions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Try a short quiz'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Listen and name what you notice'));
    await tester.pump();
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    expect(find.text('That’s right!'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    final secondAnswer = find.text('Would you like to tell me what felt hard?');
    await tester.tap(secondAnswer);
    await tester.pump();
    await tester.tap(find.text('Check answer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('See my score'));
    await tester.pumpAndSettle();
    expect(find.text('2 of 2 correct'), findsOneWidget);
  });
}
