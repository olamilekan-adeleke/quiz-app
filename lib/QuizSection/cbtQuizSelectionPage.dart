import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/classes/QuestionDbNew.dart';
import 'package:my_app_2_2/download/DownloadPage.dart';
import 'package:my_app_2_2/germany/germanInfo.dart';
import 'package:numberpicker/numberpicker.dart';

import 'CbtInfo.dart';

class CbtQuizSelectionPage extends StatefulWidget {
  @override
  _CbtQuizSelectionPageState createState() => _CbtQuizSelectionPageState();
}

class Course {
  int num;
  String name;

  Course(this.num, this.name);

  static List<Course> getCourses() {
    return <Course>[
      Course(1, 'Select Course'),
      Course(2, 'EDU211'),
      Course(3, 'EDU215'),
    ];
  }
}

class _CbtQuizSelectionPageState extends State<CbtQuizSelectionPage> {
  List<Course> _courses = Course.getCourses();
  List<DropdownMenuItem<Course>> _dropDownItems;
  Course _selectedCourse;

  String selectedCourse;
  List<dynamic> questionToAnswer;
  final DbQuestionManager dbQuestionManager = DbQuestionManager();
  List questionList;

  int mins = 0;
  int sec = 0;
  int number = 0;
  int timeForTimer = 0;
  String timeToDisplay = '';

  @override
  void initState() {
    _dropDownItems = buildDropDownMenuItems(_courses);
    _selectedCourse = _dropDownItems[0].value;
    super.initState();
  }

  void getQuestionsList() async {
    questionList = await dbQuestionManager.getQuestionList();
    print(questionList);
  }

  List<DropdownMenuItem<Course>> buildDropDownMenuItems(List courses) {
    List<DropdownMenuItem<Course>> items = List();
    for (Course course in courses) {
      items.add(
        DropdownMenuItem(
          value: course,
          child: Container(
            width: 150,
            child: Text(
              course.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }

  void onDropDownButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
              child: FutureBuilder(
                  future: dbQuestionManager.getQuestionList(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Center(
                          child: Text(
                            'No Data Found!!',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ),
                      );
                    } else {
                      if (snapshot.hasData) {
                        questionList = snapshot.data;
                        print(questionList);

                        if (questionList.length == 0) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Opps, No Data Found!!',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Click on the buttom below to navigate to the download page',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      color: Colors.green[400],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DownloadPage()));
                                      },
                                      child: Text(
                                        'Download Page',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.separated(
                            separatorBuilder: (context, int) =>
                                Divider(thickness: 1),
                            itemCount: questionList
                                .length, //= null ? 0 : questionList.length,
                            itemBuilder: (context, index) {
                              Question question = questionList[index];
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    selectedCourse = question.questionName;
                                    questionToAnswer =
                                        json.decode(question.questionFile);
                                  });

                                  print(selectedCourse);
                                  print(questionToAnswer);
                                  print(questionToAnswer.runtimeType);
                                  Navigator.pop(context);
                                },
                                leading: Text('${index + 1}'),
                                title: Text('${question.questionName}'),
                              );
                            },
                          );
                        }
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text(
                              'Please Wait....',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 20),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          );
        });
  }

  Widget startCbtButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 4.0,
      ),
      child: MaterialButton(
        height: 40.0,
        minWidth: 80.0,
        onPressed: () {
          if (number == 0 || mins == 0 || selectedCourse == null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('QuizIT'),
                content: Text(
                    'Please Make Sure You Have Selected Course, Number Of Questions '
                    'And A Time Above 60 Sec !',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    )),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            print(selectedCourse);
            print(questionToAnswer);
            print(questionToAnswer.runtimeType);

            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GetJsonCbtInfo(
                      number: number,
                      mins: mins,
                      sec: sec,
                      selectedCourse: _selectedCourse.name,
                      questionToAnswer: questionToAnswer,
                    )));
          }
        },
        color: Colors.green[500],
        child: Text(
          'Start CBT Test',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }

  Widget startGermanButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 4.0,
      ),
      child: MaterialButton(
        height: 35.0,
        minWidth: 80.0,
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GetJsonGermanInfo(
                    number: number,
                    mins: mins,
                    sec: sec,
                    selectedCourse: _selectedCourse.name,
                  )));
        },
        color: Colors.green[500],
        child: Text(
          'Start German Test',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }

  onChangeDropdownItems(Course selectedCourse) {
    setState(() {
      _selectedCourse = selectedCourse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            'Select Options',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Select  Course',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.green[400],
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              onDropDownButtonPressed();
                            },
                            child: Text(
                              'Tap To Select Course',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
//                      color: Colors.green,
                          ),
                        ),
                      ),

//                  DropdownButton(
//                    elevation: 50,
//                    value: _selectedCourse,
//                    items: _dropDownItems,
//                    onChanged: onChangeDropdownItems,
//                  ),
                    ],
                  ),
                ),
              ),
            ),
//            Divider(),
            Expanded(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Number Of Qusetions',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: 20.0),
                                child: Text(
                                  'Number',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              NumberPicker.integer(
                                  initialValue: number,
                                  minValue: 0,
                                  maxValue: 40,
                                  listViewWidth: 65.0,
                                  onChanged: (val) {
                                    setState(() {
                                      number = val;
                                    });
                                  })
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Select Time',
                            style: TextStyle(
                              color: Colors.green[500],
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20.0),
                                    child: Text(
                                      'Mins',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  NumberPicker.integer(
                                      initialValue: mins,
                                      minValue: 0,
                                      maxValue: 60,
                                      listViewWidth: 65.0,
                                      onChanged: (val) {
                                        setState(() {
                                          mins = val;
                                        });
                                      })
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20.0),
                                    child: Text(
                                      'Sec',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  NumberPicker.integer(
                                      initialValue: sec,
                                      minValue: 0,
                                      maxValue: 60,
                                      listViewWidth: 55.0,
                                      onChanged: (val) {
                                        setState(() {
                                          sec = val;
                                        });
                                      })
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Selected Coures: $selectedCourse',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Number Of Question: $number',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Time Selected: $mins Mins $sec sec',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Container(child: startCbtButton()),
            ),
          ],
        ));
  }
}
