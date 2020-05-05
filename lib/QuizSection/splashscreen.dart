import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Others/Loadingpage.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 1), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoadingPage()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[400],

      body: Center(
        child: Text(
          'QuizIT',
          style: TextStyle(
            fontSize: 50.0,
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
