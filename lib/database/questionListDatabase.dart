////
////class QuestionList {
////  int id;
////  String questionName;
////
////  QuestionList(
////    this.id,
////    this.questionName,
////  );
////
////  Map<String, dynamic> toMap() {
////    var map = <String, dynamic>{
////      'id': id,
////      'name': questionName,
////    };
////    return map;
////  }
////
////  QuestionList.fromMap(Map<String, dynamic> map) {
////    id = map['id'];
////    questionName = map['name'];
////  }
////}
////
////class DBHelper {
////  static Database _db;
////  static const String ID = 'id';
////  static const String questionName = 'name';
////  static const String questionTable = 'Question';
////  static const String DB_NAME = 'question2.db';
////
////  Future<Database> get db async {
////    if (_db != null) {
////      return _db;
////    }
////    _db = await initDb();
////    return _db;
////  }
////
////  initDb() async {
////    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
////    String path = join(documentsDirectory.path, DB_NAME);
////    var db = await openDatabase(path, version: 3, onCreate: _onCreate);
////    return db;
////  }
////
////  _onCreate(Database db, int version) async {
////    await db.execute(
////        "CREATE TABLE $questionTable ($ID INTEGER PRIMARY KEY, $questionName TEXT)");
////  }
////
////  Future<QuestionList> save(QuestionList question) async {
////    var dbClient = await db;
////    question.id = await dbClient.insert(questionTable, question.toMap());
////    return question;
////    /*
////    await dbClient.transaction((txn) async {
////      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
////      return await txn.rawInsert(query);
////    });
////    */
////  }
////
////  Future<List<QuestionList>> getQuestions() async {
////    var dbClient = await db;
////    List<Map> maps =
////        await dbClient.query(questionTable, columns: [ID, questionName]);
//
//import 'package:flutter/cupertinodart';
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//
//////    List<Map> maps = await dbClient.rawQuery("SELECT * FROM $questionTable");
////    List<QuestionList> question = [];
////    if (maps.length > 0) {
////      for (int i = 0; i < maps.length; i++) {
////        question.add(QuestionList.fromMap(maps[i]));
////      }
////    }
////    return question;
////  }
////
////  Future<int> delete(int id) async {
////    var dbClient = await db;
////    return await dbClient
////        .delete(questionTable, where: '$ID = ?', whereArgs: [id]);
////  }
////
////  Future<int> update(QuestionList question) async {
////    var dbClient = await db;
////    return await dbClient.update(questionTable, question.toMap(),
////        where: '$ID = ?', whereArgs: [question.id]);
////  }
////
////  Future close() async {
////    var dbClient = await db;
////    dbClient.close();
////  }
////}
//
//class QuestionList {
//  int id;
//  String questionName;
//  String questionFile;
//
//  QuestionList({@required this.questionName, @required this.questionFile, id});
//
//  Map<String, dynamic> toMap() {
//    return {'name': questionName, 'question_File': questionFile};
//  }
//
////  QuestionList.fromMapObject(Map<String, dynamic> map) {
////    this.id = map['id'];
////    this.questionName = map['questionTitle'];
////    this.questionFile = map['questionFile'];
////  }
//}
//
////class DBQuestionsHelper{
////  Database database;
////  static const String questionTable = 'Question';
////  static const String questionName = 'name';
////  static const String questionFile = 'question_File';
////  static const String ID = 'id';
////
////  Future openDb() async{
////    database = await openDatabase(
////      join(await getDatabasesPath(), 'QuestionDb_1.db'),
////      version: 1,
////      onCreate: (Database db, int version) async {
////        await db.execute('CREATE TABLE $questionTable($ID, )')
////    }
////    );
////  }
////}
