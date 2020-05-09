import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/germany/germanResultPage.dart';

// ignore: must_be_immutable
class GermanQuestionPage extends StatelessWidget {
  var questionNumber;
  var questionLength;
  var randomArray;
  final int number;
  final mins;
  final int sec;
  final Map<int, String> questionMap;
  final Map<int, dynamic> colorMap;

  GermanQuestionPage({
    this.number,
    this.mins,
    this.sec,
    this.questionNumber,
    this.randomArray,
    this.questionLength,
    this.questionMap,
    this.colorMap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context)
          .loadString('assets/German_EDU211.json'),
      builder: (context, snapshot) {
        List myData = json.decode(snapshot.data.toString());
        if (myData == null) {
          return Scaffold(
            body: Center(
              child: Text(
                'Loading..',
              ),
            ),
          );
        } else {
          return GermanPage(
            myData: myData,
            number: number,
            mins: mins,
            sec: sec,
            questionNumber: questionNumber,
            questionLength: questionLength,
            randomArray: randomArray,
            questionMap: questionMap,
            colorMap: colorMap,
          );
        }
      },
    );
  }
}

// ignore: must_be_immutable
class GermanPage extends StatefulWidget {
  final myData;
  var questionNumber;
  var questionLength;
  var randomArray;
  final int number;
  final int mins;
  final int sec;
  TextEditingController answer;
  final Map<int, String> questionMap;
  final Map<int, dynamic> colorMap;

  GermanPage({
    Key key,
    @required this.myData,
    this.number,
    this.mins,
    this.sec,
    this.randomArray,
    this.questionNumber,
    this.questionLength,
    this.questionMap,
    this.colorMap,
  }) : super(key: key);

  @override
  _GermanPageState createState() => _GermanPageState(
        myData,
        number,
        mins,
        sec,
        questionNumber,
        questionLength,
        randomArray,
        questionMap,
        colorMap,
      );
}

class _GermanPageState extends State<GermanPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  int questionNumber;
  int questionLength;
  List randomArray;
  int mins;
  int sec;
  int number;
  int marks = 0;
  var myData;
  int randomNum = 0;
  String showTimer = '';
  int timer;
  String timeToDisplay = '';
  static int presentRandomNumber = 1;
  int presentQuestionNumber = 1;
  List wrongQuestion = [];
  List wrongAnswer = [];
  List correctAnswer = [];
  List wrongQuestionNumber = [];
  dynamic timeColor = Colors.white70;
  dynamic initialTime;
  dynamic currentTimer;
  dynamic answer;
  Map<int, String> questionMap;
  Map<int, dynamic> colorMap;
  List questionsNotAnswered = [];
  String message = '';

  _GermanPageState(
    this.myData,
    this.number,
    this.mins,
    this.sec,
    this.questionNumber,
    this.questionLength,
    this.randomArray,
    this.questionMap,
    this.colorMap,
  );

  @override
  void initState() {
//    startTimer();
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
    double timeAtEightyPercent = (_time - (80 / 100) * _time).toDouble();

    if (currentTime == timeAtEightyPercent) {
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

  void computeResults() {
    wrongQuestionNumber = [];
    wrongAnswer = [];
    wrongQuestion = [];
    correctAnswer = [];
    marks = 0;

    questionMap.forEach((key, value) {
      if (value == null) {
        wrongQuestionNumber.add(key);
        wrongQuestion.add(myData[0][randomArray[key - 1].toString()]);
        correctAnswer.add(myData[1][randomArray[key - 1].toString()]);
        wrongAnswer.add('No Answer Was Submited For This Question.');
      } else if (value != null) {
        if (value.toString().toLowerCase().trim() ==
            myData[1][randomArray[key - 1].toString()]
                .toString()
                .toLowerCase()) {
          marks++;
        } else {
          wrongQuestionNumber.add(key);
          wrongQuestion.add(myData[0][randomArray[key - 1].toString()]);
          correctAnswer.add(myData[1][randomArray[key - 1].toString()]);
          wrongAnswer.add(value);
        }
      }
    });
    moveToResultPage();
  }

  void moveToResultPage() {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => GermanResultPage(
              marks: marks,
              wrongQuestion: wrongQuestion,
              wrongQuestionNumber: wrongQuestionNumber,
              wrongAnswer: wrongAnswer,
              correctOptions: correctAnswer,
            )));
  }

  void submitAnswer() {
    questionMap.update(presentQuestionNumber, (value) => answer.trim());
    colorMap.update(presentQuestionNumber, (value) => Colors.green);
  }

  void moveToBoxNumber(int boxNumber) {
    setState(() {
      questionNumber = randomArray[boxNumber - 1];
      presentQuestionNumber = boxNumber;
      if (questionMap[presentQuestionNumber] == null) {
        controller.text = ''.trim();
      } else {
        controller.text = questionMap[presentQuestionNumber].trim();
      }
    });
  }

  void nextQuestion() {
    submitAnswer();
    setState(() {
      if (presentQuestionNumber < number) {
        questionNumber = randomArray[presentQuestionNumber];
        presentQuestionNumber++;
        if (questionMap[presentQuestionNumber] == null) {
          controller.text = ''.trim();
        } else {
          controller.text = questionMap[presentQuestionNumber].trim();
        }
      }
    });
  }

  void submit() {
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

  void validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      nextQuestion();
    }
  }

  Widget nextQuestionButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Padding(
        padding: EdgeInsets.symmetric(),
        child: MaterialButton(
          onPressed: () {},
          child: Text(
            'Next Question',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            maxLines: 5,
          ),
          color: Colors.blue[500],
          splashColor: Colors.blue[800],
          highlightColor: Colors.blue[900],
          minWidth: 200.0,
          height: 60.0,
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
          submit();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Warning'),
              content: Text('Are You Sure You Want To End Quiz!! \n$message',
                  style: TextStyle(
                    fontSize: 17.0,
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
              color: colorMap[index + 1],
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
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.green[600],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    endButton(),
                    Row(
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
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    ClipPath(
                      clipper: MyClipper(),
                      child: Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              '${myData[0][questionNumber.toString()]}',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              rows(),
              Container(
                child: Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 50.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: controller,
                          validator: (val) => val.trim().isEmpty
                              ? 'Answer Field Can\'t Be Empty'
                              : null,
                          decoration:
                              InputDecoration(hintText: 'Enter Your Answer!'),
                          onChanged: (val) {
                            answer = val;
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 30.0,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              color: Colors.green,
                              onPressed: () {
                                validateAndSave();
                              },
                              child: Text('Submit Answer'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    // TODO: implement shouldReclip
    return true;
  }
}
