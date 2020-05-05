import 'package:flutter/material.dart';
import 'package:my_app_2_2/germany/germanSelectionPage.dart';
import 'package:my_app_2_2/QuizSection/cbtQuizSelectionPage.dart';

class SelectQuizType extends StatefulWidget {

  @override
  _SelectQuizTypeState createState() => _SelectQuizTypeState();
}

class _SelectQuizTypeState extends State<SelectQuizType> {

  Widget cbtButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      child: MaterialButton(
        height: 40.0,
        minWidth: double.infinity,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CbtQuizSelectionPage()
          ));
        },
        color: Colors.green[500],
        child: Text(
          'Select Cbt Quiz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        splashColor: Colors.green[900],
      ),
    );
  }

  Widget germanButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      child: MaterialButton(
        height: 40.0,
        minWidth: double.infinity,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GermanQuizSelectionPage()
          ));
        },
        color: Colors.green[500],
        child: Text(
          'Select German Quiz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        splashColor: Colors.green[900],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select Quiz Type',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: Colors.red,
                  ),
                  Text(
                      'Click The Button Below To Start CBT Quiz',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  cbtButton(),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: Colors.red,
                  ),
                  Text(
                    'Click The Button Below To Start German Quiz',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  germanButton(),
                ],
              ),
            ),
          ],
        ));
  }
}
