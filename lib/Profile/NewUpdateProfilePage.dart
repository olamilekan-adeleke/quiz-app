import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class NewUpdateProfile extends StatefulWidget {
  final File imageSelected;
  final String photoUrl;

  NewUpdateProfile(
      {Key key, @required this.imageSelected, @required this.photoUrl})
      : super(key: key);

  @override
  _NewUpdateProfileState createState() =>
      _NewUpdateProfileState(imageSelected: imageSelected, photoUrl: photoUrl);
}

class _NewUpdateProfileState extends State<NewUpdateProfile> {
  File imageSelected;
  String photoUrl;

  _NewUpdateProfileState({this.imageSelected, this.photoUrl});

  bool isUpdatingDatabase = false;

  @override
  void initState() {
    print('img: $imageSelected');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * .75,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20) //all(Radius.circular(15)),
                  ),
              child: Image.file(imageSelected),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 50),
            child: UpLoader(
              file: imageSelected,
              photoUrl: photoUrl,
            ),
          ),
        ],
      ),
    );
  }
}

class UpLoader extends StatefulWidget {
  final File file;
  final String photoUrl;

  UpLoader({Key key, @required this.file, @required this.photoUrl})
      : super(key: key);

  @override
  _UpLoaderState createState() => _UpLoaderState();
}

class _UpLoaderState extends State<UpLoader> {
  StorageUploadTask uploadTask;
  String uid;
  bool isUpdatingDatabase = false;
  bool isDeleting = false;

  Future upload(context, {String uid}) async {
    setState(() {
      isDeleting = true;
    });
    try {
      var fileUrl = Uri.decodeFull(basename(widget.photoUrl))
          .replaceAll(RegExp(r'(\?alt).*'), '');
      String fileName = basename(widget.file.path);

      setState(() {
        isDeleting = false;
      });

      StorageReference firebaseRef = FirebaseStorage.instance
          .ref()
          .child('profilePics')
          .child(uid)
          .child(fileName);

      setState(() {
        uploadTask = firebaseRef.putFile(widget.file);
      });
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        isUpdatingDatabase = true;
        print('done: $imageUrl');
      });

      // to delete
      print('deleting');
      StorageReference firebaseDeleteRef = FirebaseStorage.instance
          .ref()
          .child('profilePics')
          .child(uid)
          .child(basename(fileUrl));
      print(basename(fileUrl));
      await firebaseDeleteRef.delete().catchError((_) {});
      print('done deleting');

      await DatabaseService(uid: uid)
          .updateUserDisplayPic(imageUrl: imageUrl)
          .then((_) async {
        print(1);
        await DatabaseService(uid: uid)
            .updateUserPublicDisplayPic(imageUrl: imageUrl)
            .then((_) {
          print(2);
        });
      });
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: 'Pictuer Updated', toastLength: Toast.LENGTH_LONG);
    } on SocketException catch (e) {
      setState(() {
        isUpdatingDatabase = false;
      });
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      setState(() {
        isUpdatingDatabase = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // provider is here so can use the current uid
    final user = Provider.of(context);
    setState(() {
      uid = user.uid;
    });

    if (uploadTask != null) {
      return isDeleting == true
          ? Container(
              child: Column(
                children: <Widget>[
                  SpinKitCircle(
                    color: Colors.teal,
                    size: 50,
                  ),
                  Text(
                    'Loading..',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          : StreamBuilder<StorageTaskEvent>(
              stream: uploadTask.events,
              builder: (context, snapshot) {
                var event = snapshot?.data?.snapshot;
                double progressPercent = event != null
                    ? event.bytesTransferred / event.totalByteCount
                    : 0;
                return uploadTask.isComplete
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              color: Colors.black,
                              child: SpinKitCircle(
                                size: 50,
                                color: Colors.teal,
                              ),
                            ),
                            Container(
                              child: Text(
                                'Updating Database...',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                        children: <Widget>[
                          if (uploadTask.isComplete)
                            Container(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'Image Has Been Update.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          if (uploadTask.isInProgress)
                            FlatButton(
                              onPressed: () => uploadTask.pause(),
                              child: Icon(
                                Icons.pause,
                                color: Colors.white,
                              ),
                            ),
                          if (uploadTask.isPaused)
                            FlatButton(
                              child:
                                  Icon(Icons.play_arrow, color: Colors.white),
                              onPressed: uploadTask.resume,
                            ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5, right: 20),
                                  child: LinearProgressIndicator(
                                    value: progressPercent,
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                  '${(progressPercent * 100).toStringAsFixed(1)}% ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ],
                          )
                        ],
                      ));
              });
    } else {
      return Container(
        height: 90,
        padding: EdgeInsets.all(20),
        child: FlatButton.icon(
          color: Colors.teal,
          onPressed: () {
            setState(() {
              isUpdatingDatabase = true;
            });
            upload(context, uid: uid);
          },
          icon: Icon(Icons.cloud_upload),
          label: Text(
            'Update Profile Pic.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
