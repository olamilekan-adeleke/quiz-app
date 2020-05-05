import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuestionFile {
  int id;
  String questionFile;

  QuestionFile(this.id, this.questionFile);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': questionFile,
    };
    return map;
  }

  QuestionFile.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    questionFile = map['name'];
  }
}

class DBFileHelper {
  static Database _db;
  static const String ID = 'id';
  static const String questionFile = 'file';
  static const String questionTable = 'Question';
  static const String DB_NAME = 'questionFile.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 3, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $questionTable ($ID INTEGER PRIMARY KEY, $questionFile TEXT)");
  }

  Future<QuestionFile> save(QuestionFile question) async {
    var dbClient = await db;
    question.id = await dbClient.insert(questionTable, question.toMap());
    return question;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  Future<List<QuestionFile>> getQuestions() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(questionTable, columns: [
      ID,
      questionFile,
    ]);
//    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $questionTable");
    List<QuestionFile> question = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        question.add(QuestionFile.fromMap(maps[i]));
      }
    }
    return question;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(questionTable, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(QuestionFile question) async {
    var dbClient = await db;
    return await dbClient.update(questionTable, question.toMap(),
        where: '$ID = ?', whereArgs: [question.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
