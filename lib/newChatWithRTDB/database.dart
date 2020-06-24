import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app_2_2/newChatWithRTDB/testChatScreen.dart';

class Database {
  Future<String> sendMessage({@required Message message}) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .reference()
        .child('testMessages')
        .child(message.userUid)
        .push();
//        .child(DateTime.fromMillisecondsSinceEpoch(1).toString());

    databaseReference.set(message.toMap());

    print('sent');
    return databaseReference.key;
  }

  Query getMessage({@required String userUid}) {
    return FirebaseDatabase.instance
        .reference()
        .child('testMessages')
        .child(userUid)
        .orderByChild('timestamp');
  }

  Stream chatsStream({@required String userUid}) {
    return FirebaseDatabase.instance
        .reference()
        .child('testMessages')
        .child(userUid)
        .limitToLast(10)
        .orderByChild("timestamp")
        .onValue;
  }
}
