import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/HomePages/HomePage.dart';
import 'package:my_app_2_2/QuizSection/reviewCbtQuestion.dart';

class CbtResultPage extends StatefulWidget {
  final int marks;
  List wrongQuestion;
  List wrongOptions;
  List correctOptions;

  CbtResultPage({
    Key key,
    @required this.marks,
    this.wrongQuestion,
    this.wrongOptions,
    this.correctOptions,
  }) : super(key: key);

  @override
  _CbtResultPageState createState() => _CbtResultPageState(
        marks,
        wrongQuestion,
        wrongOptions,
        correctOptions,
      );
}

class _CbtResultPageState extends State<CbtResultPage> {
  int marks;
  List wrongQuestion;
  List wrongOptions;
  List correctOptions;

  _CbtResultPageState(
    this.marks,
    this.wrongQuestion,
    this.wrongOptions,
    this.correctOptions,
  );

  Widget continueButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        },
        color: Colors.green[500],
        child: Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        height: 50.0,
        minWidth: 100.0,
      ),
    );
  }

  Widget reviewButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => CbtReviewPage(
                    wrongQuestion: wrongQuestion,
                    wrongOptions: wrongOptions,
                    correctOptions: correctOptions,
                  )));
        },
        color: Colors.green[500],
        child: Text(
          'Review Questions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        height: 50.0,
        minWidth: 100.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Result Page',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Text('image place holder'),
            ),
            Divider(),
            Expanded(
                flex: 5,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Congratulations! You socred $marks marks!',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          continueButton(),
                          reviewButton(),
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }
}
