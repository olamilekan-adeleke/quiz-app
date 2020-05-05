import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/QuizSection/QuizPart.dart';

// ignore: must_be_immutable
class GetJsonCbtInfo extends StatelessWidget {
  final int number;
  final mins;
  final int sec;
  final selectedCourse;
  final List<dynamic> questionToAnswer;
  String assetToLoad;
  var mydata;

  GetJsonCbtInfo({
    this.number,
    this.mins,
    this.sec,
    this.selectedCourse,
    this.questionToAnswer,
  });

//  setAsset() {
//    if (selectedCourse == 'EDU211') {
//      assetToLoad = 'assets/CBT_EDU211.json';
//    }
//    if (selectedCourse == 'EDU215') {
//      assetToLoad = 'assets/CBT_EDU215.json';
//    }
//  }
//
  void setQuestionsPara() {
    mydata = questionToAnswer;
  }

  @override
  Widget build(BuildContext context) {
    setQuestionsPara();
    return QuizPageInfo(
        mydate: mydata,
        number: number,
        mins: mins,
        sec: sec,
        selectedCourse: selectedCourse);
//    setAsset();
//    return FutureBuilder(
//      future: DefaultAssetBundle.of(context).loadString(assetToLoad),
//      builder: (context, snapshot) {
//        List mydata = json.decode(snapshot.data.toString());
//        if (mydata == null) {
//          return Scaffold(
//            body: Center(
//              child: Text(
//                'Loading.. :)',
//              ),
//            ),
//          );
//        } else {
//          return QuizPageInfo(
//              mydate: mydata,
//              number: number,
//              mins: mins,
//              sec: sec,
//              selectedCourse: selectedCourse);
//        }
//      },
//    );
  }
}

class QuizPageInfo extends StatefulWidget {
  final mydate;
  final int number;
  final int mins;
  final int sec;
  final String selectedCourse;
  final List<dynamic> questionToAnswer;

  QuizPageInfo(
      {Key key,
      @required this.mydate,
      this.number,
      this.mins,
      this.sec,
      this.selectedCourse,
      this.questionToAnswer})
      : super(key: key);

  @override
  _QuizPageInfoState createState() => _QuizPageInfoState(
        mydate,
        number,
        mins,
        sec,
        selectedCourse,
        questionToAnswer,
      );
}

class _QuizPageInfoState extends State<QuizPageInfo> {
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
  Map<int, dynamic> choiceButtonColorMap;
  final List<dynamic> questionToAnswer;

  _QuizPageInfoState(
    this.mydate,
    this.number,
    this.mins,
    this.sec,
    this.selectedCourse,
    this.questionToAnswer,
  );

  void createQuestionMapping() {
    Map<int, String> questionMapping = Map();
    Map<int, dynamic> colorMapping = Map();
    Map<int, Map<String, dynamic>> choiceColorMapping = Map();

    for (var i = 1; i <= number; i = i + 1) {
      questionMapping[i] = null;
    }
    for (var i = 1; i <= number; i = i + 1) {
      colorMapping[i] = Colors.grey[400];
    }
    for (var i = 1; i <= number; i = i + 1) {
      choiceColorMapping[i] = {
        'a': Colors.blue[400],
        'b': Colors.blue[400],
        'c': Colors.blue[400],
        'd': Colors.blue[400],
      };
    }
    questionMap = questionMapping;
    colorMap = colorMapping;
    choiceButtonColorMap = choiceColorMapping;
  }

  void randomLists() {
    var questionlength = mydate[3]['length'];
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
    createQuestionMapping();
    randomLists();
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
    debugPrint(questionNumber.toString());
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
          print(questionToAnswer);
          setQuestionNumber();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => GetCbtJson(
                    mydata: mydate,
                    mins: mins,
                    sec: sec,
                    number: number,
                    questionNumber: questionNumber,
                    questionLength: questionLength,
                    randomArray: randomArray,
                    selectedCourse: selectedCourse,
                    questionMap: questionMap,
                    boxColorMap: colorMap,
                    choiceButtonColorMap: choiceButtonColorMap,
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
                ),
                Text(
                  'Time Selected: $mins Mins $sec Sec',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(
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
