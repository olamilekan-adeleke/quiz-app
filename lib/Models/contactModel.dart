import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  String uid;
  Timestamp addedOn;
  Timestamp lastMessageTimestamp;

  ContactModel({this.uid, this.addedOn, this.lastMessageTimestamp});

  Map toMap(ContactModel contactModel) {
    var data = Map<String, dynamic>();
    data['ContantUid'] = contactModel.uid;
    data['addedOn'] = contactModel.addedOn;
    data['lastMessageTimestamp'] = contactModel.lastMessageTimestamp;
    return data;
  }

  ContactModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['ContantUid'];
    this.addedOn = mapData['addedOn'];
    this.lastMessageTimestamp = mapData['lastMessageTimestamp'];
  }
}
