import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';

import 'package:my_app_2_2/germany/germanQuestionPage.dart';

class GetJsonGermanInfo extends StatelessWidget {
  final int number;
  final mins;
  final int sec;
  final selectedCourse;

  GetJsonGermanInfo({this.number, this.mins, this.sec, this.selectedCourse});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString('assets/German_EDU211.json'),
      builder: (context, snapshot) {
        List mydata = json.decode(snapshot.data.toString());
        if (mydata == null) {
          return Scaffold(
            body: Center(
              child: Text(
                'Loading.. :)',
              ),
            ),
          );
        } else {
          return GermanInfoPage(
              mydate: mydata,
              number: number,
              mins: mins,
              sec: sec,
              selectedCourse: selectedCourse
          );
        }
      },
    );
  }
}

class GermanInfoPage extends StatefulWidget {
  final mydate;
  final int number;
  final int mins;
  final int sec;
  final String selectedCourse;

  GermanInfoPage({
    Key key,
    @required this.mydate,
    this.number,
    this.mins,
    this.sec,
    this.selectedCourse,
  }) : super(key: key);

  @override
  _GermanInfoPageState createState() =>
      _GermanInfoPageState(mydate, number, mins, sec, selectedCourse);
}

class _GermanInfoPageState extends State<GermanInfoPage> {
  int mins;
  int sec;
  int number;
  int marks = 0;
  var mydate;
  int randomNum = 0;
  int questionNumber = 1;
  int questionNumberChoose = 1;
  int questionLength;
  String showTimer = '';
  int timer;
  String timeToDisplay = '';
  static List randomArray;
  String selectedCourse;
  Map<int, String> questionMap;
  Map<int, dynamic> colorMap;

  _GermanInfoPageState(
      this.mydate, this.number, this.mins, this.sec, this.selectedCourse);

  void createQuestionMapping (){
    Map<int, String> questionMapping = Map();
    Map<int, dynamic> colorMapping = Map();
    for (var i = 1; i <= number; i = i + 1){
      questionMapping[i] = null;
    }
    for (var i = 1; i <= number; i = i + 1){
      colorMapping[i] = Colors.grey[400];
    }
    questionMap = questionMapping;
    colorMap = colorMapping;
  }



  void randomLists() {
    var questionlength = mydate[2]['length'];
    var randomarray;
    var distinctIds = [];
    var rand = Random();
    for (int _ = 1;;) {
      distinctIds.add(rand.nextInt(questionlength));
      randomarray = distinctIds.toSet().toList();
      if (randomarray.length < number) {
        continue;
      } else if (randomarray == 1) {
        continue;
      } else {
        break;
      }
    }
    randomArray = randomarray;
    questionLength = questionlength;
  }

  @override
  void initState() {
    randomLists();
    createQuestionMapping();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void setQuestionNumber() {
    questionNumber = randomArray[randomNum];
  }

  Widget startCbtButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 10.0,
      ),
      child: MaterialButton(
        height: 55.0,
        minWidth: double.infinity,
        onPressed: () {
          setQuestionNumber();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  GermanQuestionPage(
                    number: number,
                    mins: mins,
                    sec: sec,
                    questionNumber: questionNumber,
                    randomArray: randomArray,
                    questionLength: questionLength,
                    questionMap: questionMap,
                    colorMap: colorMap,
                  )));
        },
        color: Colors.green[500],
        child: Text(
          'Start Quiz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.teal,
            title: Text(
              'Info Page',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Image palce holder!!',
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Course Selected: $selectedCourse',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),Text(
                      'Time Selected: $mins Mins $sec Sec',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),Text(
                      'Number Of Selected: $number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: startCbtButton(),
              ),
            ],
          ),
        ));
  }
}
