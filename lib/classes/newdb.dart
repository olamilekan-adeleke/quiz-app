import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbStudentManager {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), "ss.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE student(id INTEGER PRIMARY KEY autoincrement, name TEXT, course TEXT)",
        );
      });
    }
  }

  Future<int> insertStudent(Student student) async {
    await openDb();
    return await _database.insert('student', student.toMap());
  }

  Future<List<Student>> getStudentList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('student');
    return List.generate(maps.length, (i) {
      return Student(
          id: maps[i]['id'], name: maps[i]['name'], course: maps[i]['course']);
    });
  }

  Future<int> updateStudent(Student student) async {
    await openDb();
    return await _database.update('student', student.toMap(),
        where: "id = ?", whereArgs: [student.id]);
  }

  Future<void> deleteStudent(int id) async {
    await openDb();
    await _database.delete('student', where: "id = ?", whereArgs: [id]);
  }
}

class Student {
  int id;
  String name;
  String course;
  Student({@required this.name, @required this.course, this.id});
  Map<String, dynamic> toMap() {
    return {'name': name, 'course': course};
  }
}

// main.dart

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DbStudentManager dbmanager = new DbStudentManager(); //

  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  Student student; //
  List<Student> studlist; //
  int updateIndex;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqlite Demo'),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: new InputDecoration(labelText: 'Name'),
                    controller: _nameController,
                    validator: (val) =>
                        val.isNotEmpty ? null : 'Name Should Not Be empty',
                  ),
                  TextFormField(
                    decoration: new InputDecoration(labelText: 'Course'),
                    controller: _courseController,
                    validator: (val) =>
                        val.isNotEmpty ? null : 'Course Should Not Be empty',
                  ),
                  RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    child: Container(
                        width: width * 0.9,
                        child: Text(
                          'Submit',
                          textAlign: TextAlign.center,
                        )),
                    onPressed: () {
                      _submitStudent(context);
                      setState(() {});
                    },
                  ),
                  FutureBuilder(
                    future: dbmanager.getStudentList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        studlist = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: studlist == null ? 0 : studlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            Student st = studlist[index];
                            return Card(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: width * 0.6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Name: ${st.name}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Text(
                                          'Course: ${st.course}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _nameController.text = st.name;
                                      _courseController.text = st.course;
                                      student = st;
                                      updateIndex = index;
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      dbmanager.deleteStudent(st.id);
                                      setState(() {
                                        studlist.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return new CircularProgressIndicator();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitStudent(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (student == null) {
        Student st = new Student(
            name: _nameController.text, course: _courseController.text);
        dbmanager.insertStudent(st).then((id) => {
              _nameController.clear(),
              _courseController.clear(),
              print('Student Added to Db ${id}')
            });
      } else {
        student.name = _nameController.text;
        student.course = _courseController.text;

        dbmanager.updateStudent(student).then((id) => {
              setState(() {
                studlist[updateIndex].name = _nameController.text;
                studlist[updateIndex].course = _courseController.text;
              }),
              _nameController.clear(),
              _courseController.clear(),
              student = null
            });
      }
    }
  }
}
