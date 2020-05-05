//import 'package:moor_flutter/moor_flutter.dart';
//
//part 'moor_question_database.g.dart';
//
////@DataClassName('QuestionDatabase')
//class Questions extends Table {
//  IntColumn get id => integer().autoIncrement()();
//
//  TextColumn get questionName => text().withLength(min: 1, max: 150)();
//
//  TextColumn get questionFile => text()();
//}
//
//@UseMoor(tables: [Questions])
//class QuestionAppDatabase extends _$QuestionAppDatabase {
//  QuestionAppDatabase()
//      : super(FlutterQueryExecutor.inDatabaseFolder(
//            path: 'question_db.sqlite', logStatements: true));
//
//  @override
//  int get schemaVersion => 1;
//}
