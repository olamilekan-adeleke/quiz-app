import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/germany/germanPerviewQuestionsPage.dart';

class GermanResultPage extends StatefulWidget {
  final int marks;
  List wrongQuestion;
  List wrongQuestionNumber;
  List wrongAnswer;
  List correctOptions;

  GermanResultPage({
    Key key,
    @required this.marks,
    this.wrongQuestion,
    this.wrongQuestionNumber,
    this.wrongAnswer,
    this.correctOptions,
  }) : super(key: key);

  @override
  _GermanResultPageState createState() => _GermanResultPageState(
        marks,
        wrongQuestion,
        wrongQuestionNumber,
        wrongAnswer,
        correctOptions,
      );
}

class _GermanResultPageState extends State<GermanResultPage> {
  int marks;
  List wrongQuestions;
  List wrongQuestionNumber;
  List wrongAnswer;
  List correctOptions;

  _GermanResultPageState(
    this.marks,
    this.wrongQuestions,
    this.wrongQuestionNumber,
    this.wrongAnswer,
    this.correctOptions,
  );

  Widget continueButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 4.0,
      ),
      child: MaterialButton(
        height: 45.0,
        minWidth: 80.0,
        onPressed: () {
          Navigator.of(context).pop();
        },
        color: Colors.green[500],
        child: Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        splashColor: Colors.green[800],
      ),
    );
  }

  Widget reviewQuestionsButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 4.0,
      ),
      child: MaterialButton(
        height: 45.0,
        minWidth: 80.0,
        onPressed: () {
          print(wrongAnswer);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PreviewQuestionsPage(
                    wrongQuestion: wrongQuestions,
                    wrongQuestionNumber: wrongQuestionNumber,
                    wrongAnswer: wrongAnswer,
                    correctOptions: correctOptions,
                  )));
        },
        color: Colors.green[500],
        child: Text(
          'Preview Questions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        splashColor: Colors.green[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          'Result Page',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Center(
              child: Text('Image place holder'),
            ),
          ),
          Divider(),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                'Congratulations! You socred $marks marks!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                continueButton(),
                reviewQuestionsButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
