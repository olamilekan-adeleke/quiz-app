import 'package:flutter/material.dart';
import 'package:my_app_2_2/loginAndRegisteration/RegisterPage.dart';
import 'package:my_app_2_2/loginAndRegisteration/loginPage.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginPage(toggleView: toggleView);
    } else {
      return RegistrationPage(toggleView: toggleView);
    }
  }
}
