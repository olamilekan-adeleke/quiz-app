import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbQuestionManager {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "questionBoo.db"),
          version: 2, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE questions(id INTEGER PRIMARY KEY autoincrement, questionName TEXT, questionFile TEXT)",
        );
      });
    }
  }

  Future<int> insertQuestion(Question question) async {
    await openDb();
    return await _database.insert('questions', question.toMap());
  }

  Future<List<Question>> getQuestionList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('questions');
    return List.generate(maps.length, (i) {
      return Question(
          id: maps[i]['id'],
          questionName: maps[i]['questionName'],
          questionFile: maps[i]['questionFile']);
    });
  }

  Future<int> updateQuestion(Question question) async {
    await openDb();
    return await _database.update('questions', question.toMap(),
        where: "id = ?", whereArgs: [question.id]);
  }

  Future<void> deleteQuestion(int id) async {
    await openDb();
    await _database.delete('questions', where: "id = ?", whereArgs: [id]);
  }
}

class Question {
  int id;
  String questionName;
  String questionFile;
  Question({@required this.questionName, @required this.questionFile, this.id});
  Map<String, dynamic> toMap() {
    return {'questionName': questionName, 'questionFile': questionFile};
  }
}
