import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';
import 'package:uuid/uuid.dart';

class UploadNewPostPage extends StatefulWidget {
  @override
  _UploadNewPostPageState createState() => _UploadNewPostPageState();
}

class _UploadNewPostPageState extends State<UploadNewPostPage> {
  File file;
  String currentUserName;
  String currentUserUid;
  final formKey = GlobalKey<FormState>();
  String description;
  bool isUploading = false;
  String postId = Uuid().v4();

  final StorageReference storageReference =
      FirebaseStorage.instance.ref().child('PostsPictures');

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        setState(() {
          currentUserUid = user.uid;
          print(currentUserUid);
        });

        // the following code is for getting just the user name object for the
        // public user data collections
        Firestore.instance
            .collection('publicUserData')
            .document(currentUserUid)
            .get()
            .then((doc) {
          if (mounted) {
            setState(() {
              currentUserName = doc['userName'];
            });
          }
          print(currentUserName);
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<String> uploadImageToFirebaseStorage(
      {File imageFile, String postId, String uid}) async {
    print('started uploading');
    StorageUploadTask storageUploadTask =
        storageReference.child(uid).child('post_$postId').putFile(imageFile);
    storageUploadTask.events.listen((event) {
      var progress = event.snapshot.bytesTransferred.toDouble() /
          event.snapshot.totalByteCount.toDouble();
      print(progress);
    });

    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
      imageQuality: 80,
    );
    setState(() {
      file = imageFile;
    });
  }

  Future pickImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      file = imageFile;
    });
  }

  bool validateAndSave() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      print(description);
      return true;
    } else {
      return false;
    }
  }

  void uploadImageAndSave() async {
    if (validateAndSave() == true) {
      setState(() {
        isUploading = true;
      });
      print('validate');
      try {
        if (currentUserName != null && currentUserUid != null) {
//          String uploadedImageUrl = await StorageDatabaseService()
//              .uploadImageToFirebaseStorage(
//                  imageFile: file, postId: postId, uid: currentUserUid);
          var uploadedImageUrl = await uploadImageToFirebaseStorage(
              imageFile: file, postId: postId, uid: currentUserUid);
          DatabaseService().savePostInfoToFireStore(
            imageUrl: uploadedImageUrl,
            userName: currentUserName,
            ownerUid: currentUserUid,
            postId: postId,
            description: description,
          );
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: 'Done');
        } else {
          Fluttertoast.showToast(
              msg: 'Please wait A Sec And Try Again.',
              toastLength: Toast.LENGTH_LONG);
        }
      } catch (e) {
        setState(() {
          isUploading = false;
        });
        Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
        Navigator.of(context).pop();
      }
    }
  }

  selectImage(functionContext) {
    return showDialog(
        context: functionContext,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            title: Text(
              'New Post',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Capture Image With Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  'Select Image From Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Widget displayUploadScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_photo_alternate,
            color: Colors.black,
            size: 200,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RaisedButton(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'Upload A New Post',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
              onPressed: () => selectImage(context),
            ),
          )
        ],
      ),
    );
  }

  Widget displayUploadFormScreen() {
    return isUploading == true
        ? Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitPouringHourglass(
                    color: Colors.teal,
                    size: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Uplaoding, Please be patient..',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'New Post',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    print('button pressed');
                    uploadImageAndSave();
                  },
//              validateAndSave();
                  child: Text(
                    'Share',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 330.0,
//            color: Colors.black,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: AspectRatio(
                    aspectRatio: 19 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: FileImage(file),
                      )),
                    ),
                  ),
                ),
                Container(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'description',
                          hintText: 'Say Something About The Image'),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'description Can\'t Be Empty';
                        } else if (value.trim().length <= 3) {
                          return 'description Must Be More Than 3 Characters';
                        } else if (value.trim().length > 250) {
                          return 'description Must Not Be More Than 250 Characters';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => description = value.trim(),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[200]))),
                ),
                SizedBox(height: 30),
//          Container(
//            child: SizedBox(
//              width: MediaQuery.of(context).size.width * 0.45,
//              child: FlatButton(
//                onPressed: () {},
//                child: Text('Upload Post'),
//                color: Colors.green,
//              ),
//            ),
//          ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
