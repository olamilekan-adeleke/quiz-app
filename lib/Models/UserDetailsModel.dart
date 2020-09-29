import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String uid;
  String fullName;
  String userName;
  String email;
  String displayPicUrl;
  String status;
  int state;
  int postCount;

  UserDataModel({
    this.uid,
    this.fullName,
    this.userName,
    this.email,
    this.displayPicUrl,
    this.state,
    this.status,
    this.postCount,
  });

  UserDataModel.fromMap(Map<dynamic, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.fullName = mapData['fullName'];
    this.email = mapData['email'];
    this.userName = mapData['userName'];
    this.displayPicUrl = mapData['displayPicUrl'];
    this.state = mapData['state'];
    this.status = mapData['status'];
    this.postCount = mapData['postCount'];
  }

  factory UserDataModel.fromDocument(DocumentSnapshot doc) {
    return UserDataModel(
      uid: doc.documentID,
      fullName: doc['fullName'],
      userName: doc['userName'],
      email: doc['email'],
      displayPicUrl: doc['displayPicUrl'],
      postCount: doc['postCount'],
    );
  }
}
