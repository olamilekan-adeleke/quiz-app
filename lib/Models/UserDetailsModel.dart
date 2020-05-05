import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String uid;
  String fullName;
  String userName;
  String email;
  String displayPicUrl;

  UserDataModel(
      {this.uid, this.fullName, this.userName, this.email, this.displayPicUrl});

  UserDataModel.fromMap(Map<dynamic, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.fullName = mapData['fullName'];
    this.email = mapData['email'];
    this.userName = mapData['userName'];
    this.displayPicUrl = mapData['displayPicUrl'];
  }

  factory UserDataModel.fromDocument(DocumentSnapshot doc) {
    return UserDataModel(
      uid: doc.documentID,
      fullName: doc['fullName'],
      userName: doc['userName'],
      email: doc['email'],
      displayPicUrl: doc['displayPicUrl'],
    );
  }
}
