import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CbtReviewPage extends StatefulWidget {

  final List wrongQuestion;
  final List wrongOptions;
  final List correctOptions;

  CbtReviewPage({Key key, @required this.wrongQuestion,
    this.correctOptions,
    this.wrongOptions
  }) : super(key: key);


  @override
  _CbtReviewPageState createState() => _CbtReviewPageState(
    wrongQuestion,
    wrongOptions,
    correctOptions,
  );
}


class _CbtReviewPageState extends State<CbtReviewPage> {

  List wrongQuestion;
  List wrongOptions;
  List correctOptions;

  _CbtReviewPageState(
      this.wrongQuestion,
      this.wrongOptions,
      this.correctOptions,
      );

  Widget wrongQuestionList({String question, int index}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 10.0,
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
              child: Text(
                  'Wrong Question $index',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
                question,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget wrongAnswer({String wrongAnswer}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        height: 35.0,
        minWidth: double.infinity,
        onPressed: () {},
        color: Colors.redAccent[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              child: Text(
                'Your Answer ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
              child: Text(
                wrongAnswer,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }

  Widget correctAnswer({String correctAnswer}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        height: 35.0,
        minWidth: double.infinity,
        onPressed: () {},
        color: Colors.green,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: Text(
                'Correct Answer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Text(
                correctAnswer,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),

      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Review Page',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 25.0,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
            return ListTile(
              title: Card(
                color: Colors.grey[200],
                child: ListTile(
                  title: Column(
                    children: <Widget>[
                      wrongQuestionList(
                          question: wrongQuestion[index],
                        index: index + 1,
                      ),
                      wrongAnswer(
                          wrongAnswer: wrongOptions[index]
                      ),
                      correctAnswer(
                          correctAnswer: correctOptions[index]
                      ),
                    ],
                  ),
                ),
              ),
            );
        },
        itemCount: wrongQuestion.length,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}


