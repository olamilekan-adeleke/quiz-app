import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app_2_2/Models/messageModel.dart';

class ChatMethods {
  final chatCollectionRef = Firestore.instance.collection('messages');

  Future<void> addMessageToDb({Message message}) async {
    // convert message to map
    var messageMap = message.toMap();

    // add message to sender database collection
    await chatCollectionRef
        .document(message.senderUid)
        .collection(message.receiverUid)
        .add(messageMap);

    // add message to receiver database collection
    await chatCollectionRef
        .document(message.receiverUid)
        .collection(message.senderUid)
        .add(messageMap);
  }

  // this function is to get the stream to doc of chats order by time sent.
  Stream<QuerySnapshot> chatStream(
      {@required String currentUserUid, @required String receiverUid}) {
    return chatCollectionRef
        .document(currentUserUid)
        .collection(receiverUid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
