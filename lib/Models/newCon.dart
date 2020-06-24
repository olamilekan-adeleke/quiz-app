import 'package:cloud_firestore/cloud_firestore.dart';

class NewContactModel {
  Map uids;
  Timestamp lastMessageTimestamp;

  NewContactModel({this.uids, this.lastMessageTimestamp});

//  Map toMap(ContactModel contactModel) {
//    var data = Map<String, dynamic>();
//    data['ContantUid'] = contactModel.uid;
//    data['addedOn'] = contactModel.addedOn;
//    data['lastMessageTimestamp'] = contactModel.lastMessageTimestamp;
//    return data;
//  }

  NewContactModel.fromMap(Map<String, dynamic> mapData) {
    this.uids = mapData['owner'];
    this.lastMessageTimestamp = mapData['lastMessage'];
  }
}
