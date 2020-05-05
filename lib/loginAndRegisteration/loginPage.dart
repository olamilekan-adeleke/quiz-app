import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/constants/loadingWidget.dart';
import 'package:my_app_2_2/services/Auth.dart';

class LoginPage extends StatefulWidget {
  final Function toggleView;
  LoginPage({this.toggleView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService auth = AuthService();

  bool loading = false;

  final formKey = GlobalKey<FormState>();
  String email, password;
  String message = 'Log In';

  void validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        loading = true;
      });
      print('From is vaild');
      logInUser();
    } else {
      showToast('Invaild Inputs');
    }
  }

  void logInUser() async {
    dynamic result = await auth.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (result == null) {
      setState(() {
        loading = false;
      });
    }

//    setState(() {
//      message = 'Loading....';
//    });
//    FirebaseAuth.instance
//        .signInWithEmailAndPassword(
//      email: email,
//      password: password,
//    )
//        .then((user) {
//      Navigator.of(context).pushReplacementNamed('/homepage');
//    }).catchError((e) {
//      print(e.toString());
//      showToast(e.message.toString());
//      setState(() {
//        message = 'Log In';
//      });
//    });
//    setState(() {
//      message = 'Log In';
//    });
  }

  Future showToast(String message) {
    return Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return LoadingWidget();
    } else {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.teal[800],
            Colors.teal[700],
            Colors.teal[300]
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return 'Email Can\'t Be Empty';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                      ),
                                      onSaved: (value) => email = value.trim(),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.trim().isEmpty) {
                                            return 'Password Can\'t Be Empty';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                        ),
                                        obscureText: true,
                                        onSaved: (value) =>
                                            password = value.trim(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          FlatButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            color: Colors.transparent,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
//                              border: Border.all(
//                                color: Colors.black,
//                                style: BorderStyle.solid,
//                                width: 1.0,
//                              ),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.teal[400],
                              ),
                              child: FlatButton(
                                onPressed: () async {
                                  validateAndSave();
//                                setState(() {
//                                  message = 'Loading....';
//                                });
                                },
                                child: Center(
                                  child: Text(
                                    '$message',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Don\'t Have An Account? Sign Up',
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: Colors.transparent,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.transparent,
                              ),
                              child: FlatButton(
                                onPressed: () {
                                  widget.toggleView();
                                },
                                child: Center(
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
