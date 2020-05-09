import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderUid;
  String receiverUid;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;
  bool sent;
  bool read;

  Message({
    this.senderUid,
    this.receiverUid,
    this.type,
    this.message,
    this.timestamp,
    this.sent,
    this.read,
  });

  // for sending image message
  Message.imageMessage({
    this.senderUid,
    this.receiverUid,
    this.type,
    this.message,
    this.timestamp,
    this.photoUrl,
    this.sent,
    this.read,
  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderUid'] = this.senderUid;
    map['receiverUid'] = this.receiverUid;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['sent'] = this.sent;
    map['read'] = this.read;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['senderUid'] = this.senderUid;
    map['receiverUid'] = this.receiverUid;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['photoUrl'] = this.photoUrl;
    map['sent'] = this.sent;
    map['read'] = this.read;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.senderUid = map['senderUid'];
    this.receiverUid = map['receiverUid'];
    this.type = map['type'];
    this.message = map['message'];
    this.timestamp = map['timestamp'];
    this.photoUrl = map['photoUrl'];
    this.sent = map['sent'];
    this.read = map['read'];
  }
}
