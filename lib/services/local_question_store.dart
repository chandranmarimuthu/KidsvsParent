import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/content.dart';

class ImportedQuestionSet {
  const ImportedQuestionSet({required this.fileName, required this.questions});

  final String fileName;
  final List<QuizQuestion> questions;
}

class LocalQuestionStore {
  const LocalQuestionStore();

  static const _channel = MethodChannel('kids_vs_parents/local_questions');
  static const _maximumCsvBytes = 1024 * 1024;

  Future<ImportedQuestionSet?> load() async {
    final stored = await _channel.invokeMapMethod<String, dynamic>('loadCsv');
    if (stored == null) return null;
    return _decode(stored);
  }

  Future<ImportedQuestionSet?> pickAndSave() async {
    final selected = await _channel.invokeMapMethod<String, dynamic>('pickCsv');
    if (selected == null) return null;
    final questionSet = _decode(selected);
    await _channel.invokeMethod<void>('saveCsv', {
      'csv': selected['csv'],
      'fileName': questionSet.fileName,
    });
    return questionSet;
  }

  Future<void> clear() => _channel.invokeMethod<void>('clearCsv');

  static ImportedQuestionSet _decode(Map<String, dynamic> data) {
    final csv = data['csv'];
    final fileName = data['fileName'];
    if (csv is! String || fileName is! String) {
      throw const FormatException('The selected file could not be read as CSV text.');
    }
    return ImportedQuestionSet(fileName: fileName, questions: parseCsv(csv));
  }

  static List<QuizQuestion> parseCsv(String csv) {
    if (utf8.encode(csv).length > _maximumCsvBytes) {
      throw const FormatException('CSV files must be 1 MB or smaller.');
    }
    final rows = _parseRows(csv);
    if (rows.isEmpty) throw const FormatException('The CSV file is empty.');

    final headers = rows.first.map((value) => value.replaceFirst('\uFEFF', '').trim().toLowerCase()).toList();
    final headerIndexes = <String, int>{};
    for (var index = 0; index < headers.length; index++) {
      final header = headers[index];
      if (header.isEmpty) continue;
      if (headerIndexes.containsKey(header)) throw FormatException('The CSV contains a repeated "$header" column.');
      headerIndexes[header] = index;
    }
    for (final required in const ['question_id', 'path_id', 'question', 'option1', 'option2', 'answer']) {
      if (!headerIndexes.containsKey(required)) {
        throw FormatException('Add a "$required" column to the CSV header.');
      }
    }

    String cell(List<String> row, String name) {
      final index = headerIndexes[name];
      return index == null || index >= row.length ? '' : row[index].trim();
    }

    final questions = <QuizQuestion>[];
    final questionIds = <String>{};
    for (var rowIndex = 1; rowIndex < rows.length; rowIndex++) {
      final row = rows[rowIndex];
      if (row.every((value) => value.trim().isEmpty)) continue;
      final rowNumber = rowIndex + 1;
      if (row.length > headers.length) throw FormatException('Row $rowNumber has more values than the header.');

      final questionId = cell(row, 'question_id');
      final learningPathId = cell(row, 'path_id');
      if (questionId.isEmpty) throw FormatException('Row $rowNumber needs a question_id.');
      if (!questionIds.add(questionId)) throw FormatException('Row $rowNumber repeats question_id "$questionId".');
      if (!AppContent.learningTopics.any((topic) => topic.id == learningPathId)) {
        throw FormatException('Row $rowNumber uses unknown path_id "$learningPathId". Check the learning path IDs in the example CSV.');
      }

      final prompt = cell(row, 'question');
      final options = [for (final name in const ['option1', 'option2', 'option3', 'option4']) if (cell(row, name).isNotEmpty) cell(row, name)];
      if (prompt.isEmpty || options.length < 2) throw FormatException('Row $rowNumber needs a question and at least two options.');

      final answer = cell(row, 'answer');
      final answerNumber = int.tryParse(answer);
      final answerIndex = answerNumber == null
          ? options.indexWhere((option) => option.toLowerCase() == answer.toLowerCase())
          : answerNumber - 1;
      if (answerIndex < 0 || answerIndex >= options.length) {
        throw FormatException('Row $rowNumber answer must match an option or use its 1-based number.');
      }

      final explanation = cell(row, 'explanation');
      questions.add(QuizQuestion(
        prompt: prompt,
        options: options,
        answerIndex: answerIndex,
        explanation: explanation.isEmpty ? 'The correct answer is ${options[answerIndex]}.' : explanation,
        id: questionId,
        learningPathId: learningPathId,
      ));
    }
    if (questions.isEmpty) throw const FormatException('Add at least one complete question row.');
    return questions;
  }

  static List<List<String>> _parseRows(String input) {
    final rows = <List<String>>[];
    var row = <String>[];
    final field = StringBuffer();
    var inQuotes = false;

    void finishField() {
      row.add(field.toString());
      field.clear();
    }

    void finishRow() {
      finishField();
      rows.add(row);
      row = <String>[];
    }

    for (var index = 0; index < input.length; index++) {
      final character = input[index];
      if (inQuotes) {
        if (character == '"') {
          if (index + 1 < input.length && input[index + 1] == '"') {
            field.write('"');
            index++;
          } else {
            inQuotes = false;
          }
        } else {
          field.write(character);
        }
      } else if (character == '"' && field.isEmpty) {
        inQuotes = true;
      } else if (character == ',') {
        finishField();
      } else if (character == '\n' || character == '\r') {
        if (character == '\r' && index + 1 < input.length && input[index + 1] == '\n') index++;
        finishRow();
      } else {
        field.write(character);
      }
    }
    if (inQuotes) throw const FormatException('A quoted CSV value was not closed.');
    if (field.isNotEmpty || row.isNotEmpty) finishRow();
    return rows;
  }
}