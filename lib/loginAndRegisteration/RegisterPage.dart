import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/constants/loadingWidget.dart';
import 'package:my_app_2_2/services/Auth.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';

class RegistrationPage extends StatefulWidget {
  final Function toggleView;
  RegistrationPage({this.toggleView});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final AuthService auth = AuthService();

  final formKey = GlobalKey<FormState>();
  bool notShowPassword;
  String message = 'Sign Up';

  bool loading = false;

  String firstName;
  String email;
  String lastName;
  String _password;
  String _passwordAgain;
  String userName;
  String faculty;
  String department;
  Timestamp timeCreated;

  String fullName;
  String password;

  void logOut() async {
    await auth.signOut();
    print('sign out');
  }

  void validateAndSave() {
    final form = formKey.currentState;
    try {
      if (form.validate()) {
        form.save();
        getUserInfo();
      } else {
        setState(() {
          loading = false;
        });
        showToast('Invaild Input, Try Again!');
      }
    } catch (e) {
      showToast(e.message);
    }
  }

  void checkIfUsernameAlreadyExist() async {
    List<UserDataModel> searchList;
    await DatabaseService().fetchAllUsers().then((List<UserDataModel> list) {
      searchList = list;
    });

    final List<UserDataModel> listOfUserWithSameUserName =
        searchList.where((UserDataModel user) {
      String getUserName = user.userName.toLowerCase();
      String _query = userName.toLowerCase();
//      String getEmail = user.email.toLowerCase();
//      String _queryEmail = email.toLowerCase();

      bool matchesUserName = getUserName.contains(_query);
//      bool matchesEmail = getEmail.contains(_queryEmail);

      return (matchesUserName);
    }).toList();

    final List<UserDataModel> listOfUserWithSameEmail =
        searchList.where((UserDataModel user) {
//      String getUserName = user.userName.toLowerCase();
//      String _query = userName.toLowerCase();
      String getEmail = user.email.toLowerCase();
      String _queryEmail = email.toLowerCase();
//      bool matchesUserName = getUserName.contains(_query);
      bool matchesEmail = getEmail.contains(_queryEmail);

      return (matchesEmail);
    }).toList();

    print(listOfUserWithSameUserName.length.toString());
    print(listOfUserWithSameEmail.length.toString());
    if (listOfUserWithSameEmail.length != 0) {
      print('Email Address Already Taken!');
      Fluttertoast.showToast(
        msg: 'Email Address Already Taken!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      setState(() {
        loading = false;
      });
    }
    if (listOfUserWithSameUserName.length != 0) {
      Fluttertoast.showToast(
        msg: 'User Name Already Taken!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      print('Email Address Already Taken!');
      setState(() {
        loading = false;
      });
    } else {
      registerUser();
    }
  }

  void getUserInfo() {
    if (_password != _passwordAgain) {
      print('$_password = $_passwordAgain');
      showToast('Password Must Be Same');
    } else {
      password = _passwordAgain;
      fullName = '$firstName $lastName';
      setState(() {
        loading = true;
      });
      checkIfUsernameAlreadyExist();
    }
  }

  Future showToast(String message) {
    return Fluttertoast.showToast(msg: message);
  }

  Future<void> registerUser() async {
    print(email);
    print(password);
    print(userName);

    dynamic result = auth.registerWithEmailAndPassword(
      email: email,
      password: password,
      fullName: fullName,
      userName: userName,
    );



    if (result == null) {
      setState(() {
        loading = false;
      });
    }

//    logOut();

//    setState(() {
//      message = 'Loading...';
//    });
//    print(email);
//
//    FirebaseAuth.instance
//        .createUserWithEmailAndPassword(
//      email: email.trim(),
//      password: password,
//    )
//        .then((signedInUser) {
//      print(signedInUser.user.uid.toString());
//      return signedInUser.user.uid;
////      UserManagement().storeNewUserInfo(signedInUser, context);
//    }).catchError((e) {
//      print('${e.message}');
//      showToast(e.message.toString());
//
//      setState(() {
//        message = 'Sign Up';
//      });
//    });
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
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "You\'re Welcome.",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
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
                              height: 1,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.trim().isEmpty) {
                                          return 'First Name Can\'t Be Empty';
                                        } else if (value.trim().length < 3) {
                                          return 'First Name Must Be More Than 2 Characters';
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'First Name',
                                      ),
                                      onSaved: (value) =>
                                          firstName = value.trim(),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
//                                decoration: BoxDecoration(
//                                    border: Border(
//                                        bottom: BorderSide(
//                                            color: Colors.grey[200]))),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.trim().isEmpty) {
                                            return 'Last Name Can\'t Be Empty';
                                          } else if (value.trim().length < 3) {
                                            return 'Last Name Must Be More Than 2 Characters';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Last Name',
                                        ),
                                        onSaved: (value) =>
                                            lastName = value.trim(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.trim().isEmpty) {
                                            return 'UserName Can\'t Be Empty';
                                          } else if (value.trim().length <= 3) {
                                            return 'UserName Must Be More Than 3 Characters';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'UserName',
                                        ),
                                        onSaved: (value) =>
                                            userName = value.trim(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: TextFormField(
//                                      validator: (value) {
//                                        if (value.trim().isEmpty) {
//                                          return 'Field Can\'t Be Empty';
//                                        } else {
//                                          return null;
//                                        }
//                                      },
                                        decoration: InputDecoration(
                                          labelText: 'Faculty',
                                        ),
                                        onSaved: (value) =>
                                            email = value.trim(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: TextFormField(
//                                      validator: (value) {
//                                        if (value.trim().isEmpty) {
//                                          return 'Field Can\'t Be Empty';
//                                        } else {
//                                          return null;
//                                        }
//                                      },
                                        decoration: InputDecoration(
                                          labelText: 'Department',
                                        ),
                                        onSaved: (value) =>
                                            department = value.trim(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.trim().isEmpty) {
                                            return 'Email Can\'t Be Empty';
                                          } else if (!EmailValidator.validate(
                                              value.trim())) {
                                            return 'Not a vaild Email';
                                          } else if (!value
                                              .trim()
                                              .endsWith('.com')) {
                                            return 'Invalid Email';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                        ),
                                        onSaved: (value) =>
                                            email = value.trim(),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.info_outline,
                                            size: 18,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                'Be sure to submit a vaild/correct email address as this email will be use if there is a case of forgotten paswword.',
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.trim().isEmpty) {
                                            return 'Password Can\'t Be Empty';
                                          } else if (value.trim().length < 6) {
                                            return 'Password Must Be More Than 6 Characters';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                        ),
//                                    obscureText: true,
                                        onSaved: (value) {
                                          _password = value.trim();
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value.trim().isEmpty) {
                                            return 'Password Can\'t Be Empty';
                                          } else if (value.trim().length < 6) {
                                            return 'Password Must Be More Than 6 Characters';
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Password Again!',
                                        ),
                                        onSaved: (value) {
                                          _passwordAgain = value.trim();
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
//                                    obscureText: notshowPassword,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
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
                                  onPressed: () {
                                    validateAndSave();
                                  },
                                  child: Center(
                                    child: Text(
                                      "$message",
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
                              'Have An Account? Log In',
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
                                      "Log In",
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
        ),
      );
    }
  }
}
