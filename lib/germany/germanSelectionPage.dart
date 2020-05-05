import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/germany/germanInfo.dart';
import 'package:numberpicker/numberpicker.dart';

class GermanQuizSelectionPage extends StatefulWidget {
  @override
  _GermanQuizSelectionPageState createState() =>
      _GermanQuizSelectionPageState();
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

class _GermanQuizSelectionPageState extends State<GermanQuizSelectionPage> {
  List<Course> _courses = Course.getCourses();
  List<DropdownMenuItem<Course>> _dropDownItems;
  Course _selectedCourse;

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
        backgroundColor: Colors.white,
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
                  SizedBox(),
                  DropdownButton(
                    elevation: 50,
                    value: _selectedCourse,
                    items: _dropDownItems,
                    onChanged: onChangeDropdownItems,
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
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
                  Column(
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
                ],
              ),
            ),
            Divider(),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Selected Coures: ${_selectedCourse.name}',
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
            SizedBox(
              width: double.infinity,
              child: Container(
                child: startGermanButton(),
              ),
            ),
          ],
        ));
  }
}
