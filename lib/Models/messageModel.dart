import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderUid;
  String receiverUid;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;

  Message({
    this.senderUid,
    this.receiverUid,
    this.type,
    this.message,
    this.timestamp,
  });

  // for sending image message
  Message.imageMessage({
    this.senderUid,
    this.receiverUid,
    this.type,
    this.message,
    this.timestamp,
    this.photoUrl,
  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderUid'] = this.senderUid;
    map['receiverUid'] = this.receiverUid;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.senderUid = map['senderUid'];
    this.receiverUid = map['receiverUid'];
    this.type = map['type'];
    this.message = map['message'];
    this.timestamp = map['timestamp'];
  }
}
