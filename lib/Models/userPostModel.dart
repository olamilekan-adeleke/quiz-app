import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostModel {
  String postId;
  Timestamp timeCreated;

  UserPostModel({this.postId, this.timeCreated});

  Map toMap(UserPostModel contactModel) {
    var data = Map<String, dynamic>();
    data['postId'] = contactModel.postId;
    data['timeCreated'] = contactModel.timeCreated;
    return data;
  }

  UserPostModel.fromMap(Map<String, dynamic> mapData) {
    this.postId = mapData['postId'];
    this.timeCreated = mapData['timeCreated'];
  }
}
