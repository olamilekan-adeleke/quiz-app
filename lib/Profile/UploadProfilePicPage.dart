//import 'dart:io';
//
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:my_app_2_2/services/FirestoreDatabase.dart';
//import 'package:path/path.dart';
//import 'package:provider/provider.dart';
//
//class UploadProfilePicPage extends StatefulWidget {
//  final File imageSelected;
//  var photoUrl;
//
//  UploadProfilePicPage({
//    Key key,
//    @required this.imageSelected,
//    this.photoUrl,
//  }) : super(key: key);
//
//  @override
//  _UploadProfilePicPageState createState() => _UploadProfilePicPageState(
//      imageSelected: imageSelected, photoUrl: photoUrl);
//}
//
//class _UploadProfilePicPageState extends State<UploadProfilePicPage> {
//  File imageSelected;
//  String uid;
//  bool isUploading = false;
//  var photoUrl;
//
//  _UploadProfilePicPageState({this.imageSelected, this.photoUrl});
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  Future uploadImage({uid, context}) async {
//    try {
//      var fileUrl = Uri.decodeFull(basename(photoUrl))
//          .replaceAll(RegExp(r'(\?alt).*'), '');
//      String fileName = basename(imageSelected.path);
//
//      // to delete
//      StorageReference firebaseDeleteRef = FirebaseStorage.instance
//          .ref()
//          .child('profilePics')
//          .child(uid)
//          .child(basename(fileUrl));
//      print(basename(fileUrl));
//      await firebaseDeleteRef.delete();
//
//      StorageReference firebaseRef = FirebaseStorage.instance
//          .ref()
//          .child('profilePics')
//          .child(uid)
//          .child(fileName);
//
//      StorageUploadTask uploadTask = firebaseRef.putFile(imageSelected);
//      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//      String imageUrl = await taskSnapshot.ref.getDownloadURL();
//      setState(() {
//        print(imageUrl);
//      });
//      await DatabaseService(uid: uid).updateUserDisplayPic(imageUrl: imageUrl);
//      await DatabaseService(uid: uid)
//          .updateUserPublicDisplayPic(imageUrl: imageUrl);
//      Navigator.pop(context);
//    } catch (e) {
//      print(e);
//      setState(() {
//        isUploading = false;
//      });
//      uploadImageForFirstTime(uid: uid);
//      Fluttertoast.showToast(
//          msg: e.message.toString(), toastLength: Toast.LENGTH_LONG);
//    }
//  }
//
//  Future uploadImageForFirstTime({uid, context}) async {
//    try {
//      String fileName = basename(imageSelected.path);
//
//      StorageReference firebaseRef = FirebaseStorage.instance
//          .ref()
//          .child('profilePics')
//          .child(uid)
//          .child(fileName);
//
//      StorageUploadTask uploadTask = firebaseRef.putFile(imageSelected);
//      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
//      String imageUrl = await taskSnapshot.ref.getDownloadURL();
//      setState(() {
//        print(imageUrl);
//      });
//      await DatabaseService(uid: uid).updateUserDisplayPic(imageUrl: imageUrl);
//      await DatabaseService(uid: uid)
//          .updateUserPublicDisplayPic(imageUrl: imageUrl);
//      Navigator.pop(context);
//      Fluttertoast.showToast(msg: 'Profile Pic Updated');
//    } catch (e) {
//      print(e);
//      setState(() {
//        isUploading = false;
//      });
//      Fluttertoast.showToast(
//          msg: e.message.toString(), toastLength: Toast.LENGTH_LONG);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // provider is here so can use the current uid
//    final user = Provider.of(context);
//    setState(() {
//      uid = user.uid;
//    });
//    return SafeArea(
//      child: isUploading == true
//          ? Container(
//              child: SpinKitPouringHourglass(
//                color: Colors.green,
//                size: 80,
//              ),
//            )
//          : Scaffold(
//              backgroundColor: Colors.black,
//              body: Container(
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Center(
//                      child: Container(
//                        child: CircleAvatar(
//                          radius: 120,
//                          backgroundColor: Colors.grey[600],
//                          child: ClipOval(
//                            child: SizedBox(
//                              height: 210.0,
//                              width: 210.0,
//                              child: Image.file(
//                                imageSelected,
//                                fit: BoxFit.fill,
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    SizedBox(height: 50),
//                    SizedBox(
//                      width: MediaQuery.of(context).size.width * 0.6,
//                      child: FlatButton(
//                        color: Colors.green,
//                        onPressed: () {
//                          print('uid: $uid');
//                          setState(() {
//                            isUploading = true;
//                          });
//                          if (photoUrl != null) {
//                            uploadImage(uid: user.uid, context: context);
//                          } else {
//                            uploadImageForFirstTime(
//                                uid: user.uid, context: context);
//                          }
//                        },
//                        child: Text('Upload'),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//    );
//  }
//}
