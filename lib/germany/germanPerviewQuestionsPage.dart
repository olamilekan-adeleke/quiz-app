import 'package:flutter/material.dart';

class PreviewQuestionsPage extends StatefulWidget {
  final List wrongQuestion;
  final List wrongQuestionNumber;
  final List wrongAnswer;
  final List correctOptions;

  PreviewQuestionsPage(
      {Key key,
        @required this.wrongQuestion,
        this.wrongQuestionNumber,
        this.wrongAnswer,
        this.correctOptions,
      })
      : super(key: key);

  @override
  _PreviewQuestionsPageState createState() => _PreviewQuestionsPageState(
    wrongQuestion,
    wrongQuestionNumber,
    wrongAnswer,
    correctOptions,
  );
}

class _PreviewQuestionsPageState extends State<PreviewQuestionsPage> {
  List wrongQuestions;
  List wrongQuestionNumber;
  List wrongAnswer;
  List correctOptions;


  _PreviewQuestionsPageState(this.wrongQuestions, this.wrongQuestionNumber, this.wrongAnswer,
      this.correctOptions,);

  Widget wrongQuestionListCard({String question, int index}) {
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
                'Wrong Question ${wrongQuestionNumber[index]}',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18.0,
                ),
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

  Widget wrongAnswerCard({String wrongAnswer}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 2.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        height: 35.0,
        minWidth: double.infinity,
        onPressed: () {},
        color: Colors.red,
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
              ),
            ),
            Padding(
              padding:  EdgeInsets.fromLTRB(0, 20, 0, 5),
              child: Text(
                wrongAnswer,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19.0,
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

  Widget correctAnswerCard({String correctAnswer}) {
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
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                'Correct Answer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
              child: Text(
                correctAnswer,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19.0,
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
              color: Colors.grey[100],
              child: ListTile(
                title: Column(
                  children: <Widget>[
                    wrongQuestionListCard(
                      question: wrongQuestions[index],
                      index: index,
                    ),
                    wrongAnswerCard(
                      wrongAnswer: wrongAnswer[index],
                    ),
                    correctAnswerCard(
                        correctAnswer: correctOptions[index]
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: wrongQuestions.length,
        physics: BouncingScrollPhysics(),
      ),
    );
  }
}