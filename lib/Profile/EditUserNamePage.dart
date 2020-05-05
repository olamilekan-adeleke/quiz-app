import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserDisplayPicUrl;

  EditProfilePage({this.currentOnlineUserDisplayPicUrl});

//  EditProfilePage({this.userName});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController controller;

  final formKey = GlobalKey<FormState>();

  String userNameToUpdate;

  String uid;
  bool isUpdating;

  bool validateAndSave() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(userNameToUpdate);
      return true;
    } else {
      return false;
    }
  }

  void updateUserName() async {
    if (validateAndSave() == true) {
      setState(() {
        isUpdating = true;
      });
      try {
        await DatabaseService(uid: uid)
            .updateUserUserName(userName: userNameToUpdate);
        await DatabaseService(uid: uid)
            .updatePublicUserUserName(userName: userNameToUpdate);
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'Profile Updated');
      } catch (e) {
        print(e);
        setState(() {
          isUpdating = false;
        });
        Fluttertoast.showToast(
            msg: e.message.toString(), toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // provider is here so can use the current uid
    final user = Provider.of(context);
    setState(() {
      uid = user.uid;
    });
    return Scaffold(
//      backgroundColor: Colors.white,
      body: isUpdating == true
          ? Container(
              child: Center(
                child: SpinKitPouringHourglass(
                  color: Colors.teal,
                  duration: Duration(seconds: 1),
                ),
              ),
              color: Colors.black,
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20),
//                        height: MediaQuery.of(context).size.height * .45,
//                        width: ,
                        child: Container(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: CachedNetworkImageProvider(widget
                                .currentOnlineUserDisplayPicUrl
                                .toString()),
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      ),
                      Container(
                        child: Form(
                          key: formKey,
                          child: TextFormField(
//                            initialValue: widget.userName,
                            decoration: InputDecoration(
                              labelText: 'Enter User Name',
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'UserName Can\'t Be Empty';
                              } else if (value.trim().length <= 3) {
                                return 'UserName Must Be More Than 3 Characters';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) => userNameToUpdate = value.trim(),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[200]))),
                      ),
                      SizedBox(height: 30),
                      Container(
                        child: FlatButton(
                          onPressed: () {
                            updateUserName();
                          },
                          child: Text('Updata Username'),
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
