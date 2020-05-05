import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:my_app_2_2/QuizSection/cbtResultPage.dart';

class GetCbtJson extends StatelessWidget {
  var questionNumber;
  var questionLength;
  var randomArray;
  final int number;
  final mins;
  final int sec;
  final selectedCourse;
  String assetToLoad;
  var mydata;
  final Map<int, String> questionMap;
  final Map<int, dynamic> boxColorMap;
  final Map<int, dynamic> choiceButtonColorMap;

  GetCbtJson({
    this.number,
    this.mins,
    this.sec,
    this.questionNumber,
    this.randomArray,
    this.selectedCourse,
    this.questionLength,
    this.questionMap,
    this.boxColorMap,
    this.choiceButtonColorMap,
    this.mydata,
  });

  @override
  Widget build(BuildContext context) {
    print(mydata);
    return CbtQuizPage(
      mydata: mydata,
      number: number,
      mins: mins,
      sec: sec,
      questionNumber: questionNumber,
      questionLength: questionLength,
      randomArray: randomArray,
      questionMap: questionMap,
      boxColorMap: boxColorMap,
      choiceButtonColorMap: choiceButtonColorMap,
    );
//    setAsset();
//    return FutureBuilder(
//      future: DefaultAssetBundle.of(context).loadString(assetToLoad),
//      builder: (context, snapshot) {
//        List mydata = json.decode(snapshot.data.toString());
//        if (mydata == null) {
//          return Scaffold(
//            body: Center(
//              child: Text(
//                'Loading..',
//              ),
//            ),
//          );
//        } else {
//          return CbtQuizPage(
//            mydata: mydata,
//            number: number,
//            mins: mins,
//            sec: sec,
//            questionNumber: questionNumber,
//            questionLength: questionLength,
//            randomArray: randomArray,
//            questionMap: questionMap,
//            boxColorMap: boxColorMap,
//            choiceButtonColorMap: choiceButtonColorMap,
//          );
//        }
//      },
//    );
  }
}

class CbtQuizPage extends StatefulWidget {
  var questionNumber;
  var questionLength;
  var randomArray;
  final mydata;
  final int number;
  final int mins;
  final int sec;
  final Map<int, String> questionMap;
  final Map<int, dynamic> boxColorMap;
  final Map<int, dynamic> choiceButtonColorMap;

  CbtQuizPage({
    Key key,
    @required this.mydata,
    this.number,
    this.mins,
    this.sec,
    this.randomArray,
    this.questionNumber,
    this.questionLength,
    this.questionMap,
    this.boxColorMap,
    this.choiceButtonColorMap,
  }) : super(key: key);

  @override
  _CbtQuizPageState createState() => _CbtQuizPageState(
        mydata,
        number,
        mins,
        sec,
        questionNumber,
        questionLength,
        randomArray,
        questionMap,
        boxColorMap,
        choiceButtonColorMap,
      );
}

class _CbtQuizPageState extends State<CbtQuizPage> {
  int questionNumber;
  int questionLength;
  List randomArray;
  int mins;
  int sec;
  int number;
  int marks = 0;
  var mydata;
  int randomNum = 0;
  String showTimer = '';
  int timer;
  String timeToDisplay = '';
  static int presentRandomNumber = 1;
  int presentQuestionNumber = 1;
  List wrongQuestion = [];
  List wrongOptions = [];
  List wrongQuestionNumber = [];
  List correctOptions = [];
  dynamic timeColor = Colors.white70;
  dynamic initialTime;
  dynamic currentTimer;
  Map<int, String> questionMap;
  Map<int, dynamic> boxColorMap;
  Map<int, dynamic> choiceButtonColorMap;
  List questionsNotAnswered = [];
  String message = '';

  _CbtQuizPageState(
      this.mydata,
      this.number,
      this.mins,
      this.sec,
      this.questionNumber,
      this.questionLength,
      this.randomArray,
      this.questionMap,
      this.boxColorMap,
      this.choiceButtonColorMap);

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void checkTimerColor({double initial, double currentTime}) {
    double _time = initial;
    double _70precentTime = (_time - (70 / 100) * _time).toDouble();

    if (currentTime == _70precentTime) {
      timeColor = Colors.red[600];
    } else {
      timeColor = timeColor;
    }
  }

  void startTimer() async {
    timer = ((mins * 60) + sec);
    currentTimer = timer.toDouble();
    initialTime = timer.toDouble();

    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          computeResults();
          moveToResultPage();
        } else if (timer < 60) {
          if (timer < 10) {
            timeToDisplay = '0' + timer.toString();
            timer = timer - 1;
            currentTimer = timer.toDouble();
          } else {
            timeToDisplay = timer.toString();
            timer = timer - 1;
            currentTimer = timer.toDouble();
          }
        } else if (timer < 3600) {
          int m = timer ~/ 60;
          int s = timer - (60 * m);
          if (s < 10) {
            timeToDisplay = m.toString() + ':0' + s.toString();
            timer = timer - 1;
            currentTimer = timer.toDouble();
          } else {
            timeToDisplay = m.toString() + ':' + s.toString();
            timer = timer - 1;
            currentTimer = timer.toDouble();
          }
        }
        checkTimerColor(initial: initialTime, currentTime: currentTimer);
      });
    });
  }

  void computeResults({String option}) {
    wrongQuestionNumber = [];
    wrongOptions = [];
    wrongQuestion = [];
    correctOptions = [];
    marks = 0;

    questionMap.forEach((key, value) {
      if (value == null) {
        wrongQuestionNumber.add(key);
        wrongQuestion.add(mydata[0][randomArray[key - 1].toString()]);
        correctOptions.add(mydata[2][randomArray[key - 1].toString()]);
        wrongOptions.add('No Answer Was Submited For This Question.');
      } else if (value != null) {
        if (value.toLowerCase().trim() ==
            mydata[2][randomArray[key - 1].toString()]
                .toString()
                .toLowerCase()) {
          marks++;
        } else {
          wrongQuestionNumber.add(key);
          wrongQuestion.add(mydata[0][randomArray[key - 1].toString()]);
          correctOptions.add(mydata[2][randomArray[key - 1].toString()]);
          wrongOptions.add(value);
        }
      }
    });
    moveToResultPage();
  }

  void moveToResultPage() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => CbtResultPage(
              marks: marks,
              correctOptions: correctOptions,
              wrongQuestion: wrongQuestion,
              wrongOptions: wrongOptions,
            )));
  }

  void moveToBoxNumber(int boxNumber) {
    setState(() {
      questionNumber = randomArray[boxNumber - 1];
      presentQuestionNumber = boxNumber;
    });
  }

  void nextQuestion() {
    setState(() {
      if (presentQuestionNumber < number) {
        questionNumber = randomArray[presentQuestionNumber];
        presentQuestionNumber++;
      }
    });
  }

  void resetButtons() {
    choiceButtonColorMap[presentQuestionNumber]
        .update('a', (value) => Colors.blue[400]);
    choiceButtonColorMap[presentQuestionNumber]
        .update('b', (value) => Colors.blue[400]);
    choiceButtonColorMap[presentQuestionNumber]
        .update('c', (value) => Colors.blue[400]);
    choiceButtonColorMap[presentQuestionNumber]
        .update('d', (value) => Colors.blue[400]);
  }

  void onPressedOfButton({String option}) {
    resetButtons();
    questionMap.update(presentQuestionNumber,
        (value) => mydata[1][questionNumber.toString()][option]);
    boxColorMap.update(presentQuestionNumber, (value) => Colors.green);
    choiceButtonColorMap[presentQuestionNumber]
        .update(option, (value) => Colors.blue[900]);
    nextQuestion();
    print(questionMap);
  }

  void confirmSubmit() {
    String _notAnswered = '';
    questionsNotAnswered = [];
    questionMap.forEach((key, value) {
      if (value == null) {
        questionsNotAnswered.add(key.toString());
      }
    });

    if (questionsNotAnswered.length == 0) {
      message = '';
    } else {
      for (var i in questionsNotAnswered) {
        _notAnswered = '$_notAnswered $i,';
      }
      message = 'You have Not Answered Questions $_notAnswered';
    }
  }

//  void checkAnswer(String k) {
//    if (mydata[2][questionNumber.toString()] ==
//        mydata[1][questionNumber.toString()][k]) {
//      marks = marks + 1;
//    } else {
//      wrongQuestion.add(mydata[0][questionNumber.toString()]);
//      wrongOptions.add(mydata[1][questionNumber.toString()][k]);
//      correctOptions.add(mydata[2][questionNumber.toString()]);
//    }
//    setState(() {});
//    Timer(Duration(microseconds: 1), nextQuestion);
//  }

  Widget choiceButton(String k) {
    return SizedBox(
      width: 250,
      height: 60,
      child: Padding(
        padding: EdgeInsets.symmetric(),
        child: MaterialButton(
          onPressed: () {
            onPressedOfButton(option: k);
          },
          child: Text(
            mydata[1][questionNumber.toString()][k],
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            maxLines: 5,
          ),
          color: choiceButtonColorMap[presentQuestionNumber][k],
          minWidth: 200.0,
          height: 80.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        ),
      ),
    );
  }

  Widget endButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: MaterialButton(
        onPressed: () {
          confirmSubmit();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Warning'),
              content: Text('Are You Sure You Want To End Quiz!!\n$message',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                  )),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    computeResults();
                  },
                  child: Text(
                    'YES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black45,
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'NO',
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
        },
        color: Colors.red[500],
        child: Text(
          'End Quiz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }

  Widget rows() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: number,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            width: 50,
            height: 30,
            child: FlatButton(
              onPressed: () {
                moveToBoxNumber(index + 1);
              },
              color: boxColorMap[index + 1],
              child: Text(
                '${index + 1}',
                maxLines: 1,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('QuizIT'),
                    content: Text(
                        'Click On The Exit Button If You Want To End Quiz.',
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
                  ));
        },
        child: Scaffold(
//          backgroundColor: Colors.green,
          body: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                color: Colors.green[600],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    endButton(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            '${presentQuestionNumber.toString()} out of $number questions | ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20.0,
                              color: Colors.black45,
                            ),
                          ),
                          Text(
                            timeToDisplay,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                              color: timeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
//                      height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      color: Colors.green,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              mydata[0][questionNumber.toString()],
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(bottom: 10),
                child: rows(),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      choiceButton('a'),
                      SizedBox(height: 12.0),
                      choiceButton('b'),
                      SizedBox(height: 12.0),
                      choiceButton('c'),
                      SizedBox(height: 12.0),
                      choiceButton('d'),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0,
                child: Text(
                  'ads place holder',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// clip code start here....
class MyClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 50);
    var controlPoint = Offset(50, size.height);
    var endpoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endpoint.dx, endpoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
