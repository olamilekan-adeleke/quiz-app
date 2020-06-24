import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Models/messageModel.dart';
import 'package:my_app_2_2/provider/imageUploadProvider.dart';

class NewChatMethods {
  final chatCollectionRef = Firestore.instance.collection('ChatMessages');
  final StorageReference chatStorageReference =
      FirebaseStorage.instance.ref().child('ChatImagePictures');

  final contactsCollectionRef = Firestore.instance.collection('Contacts');

  Future<void> addMessageToDb({Message message}) async {
    /// add/upload message to chat database. required[Message message]

    try {
      // convert message to map
      var messageMap = message.toMap();

      await chatCollectionRef
          .document(message.senderUid + message.receiverUid)
          .collection('chats')
          .document(message.timestamp.microsecondsSinceEpoch.toString())
          .setData(messageMap);

      await chatCollectionRef
          .document(message.senderUid + message.receiverUid)
          .setData({
        'owner': {
          message.senderUid: true,
          message.receiverUid: true,
        },
        'lastMessage': Timestamp.now(),
      }, merge: true);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> uploadImage(
      {@required File image,
      @required String receiverUid,
      @required String senderUId,
      @required ImageUploadProvider imageUploadProvider}) async {
    /// upload chats image details to chat database

    Message message;

    imageUploadProvider.setToLoading();

    print('awit url');
    // await url
    String imageUrl = await uploadImageToStorage(
        image: image, receiverUid: receiverUid, senderUId: senderUId);
    print('got url');

    try {
      if (imageUrl != null) {
        // convert image message to map/json format
        message = Message.imageMessage(
          message: "Image",
          receiverUid: receiverUid,
          senderUid: senderUId,
          timestamp: Timestamp.now(),
          type: 'image',
          photoUrl: [imageUrl],
          sent: true,
          read: false,
        );

        imageUploadProvider.setToIdle();

        Map imageMessageMap = message.toImageMap();

        await chatCollectionRef
            .document(message.senderUid + message.receiverUid)
            .collection('chats')
            .document(message.timestamp.microsecondsSinceEpoch.toString())
            .setData(imageMessageMap);

        await chatCollectionRef
            .document(message.senderUid + message.receiverUid)
            .setData({
          'owner': {
            message.senderUid: true,
            message.receiverUid: true,
          },
          'lastMessage': Timestamp.now(),
        }, merge: true);
        print('done');
      }
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> uploadMultipleImage(
      {@required Message message,
      @required ImageUploadProvider imageUploadProvider}) async {
    /// upload chats image details to chat database

//    imageUploadProvider.setToLoading();

    // await url
//    String imageUrl = await uploadImageToStorage(
//        image: image, receiverUid: receiverUid, senderUId: senderUId);

    try {
      imageUploadProvider.setToIdle();

      Map imageMessageMap = message.toImageMap();

      await chatCollectionRef
          .document(message.senderUid + message.receiverUid)
          .collection('chats')
          .document(message.timestamp.microsecondsSinceEpoch.toString())
          .setData(imageMessageMap);

      await chatCollectionRef
          .document(message.senderUid + message.receiverUid)
          .setData({
        'owner': {
          message.senderUid: true,
          message.receiverUid: true,
        },
        'lastMessage': Timestamp.now(),
      }, merge: true);
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<String> uploadImageToStorage(
      {@required File image, String receiverUid, String senderUId}) async {
    /// upload image to storage and return url. required[File image]

//    File imageToUpload = await ChatUtils.compressImage(imageToCompress: image);

    try {
      // upload image to storage inside a folder of receiver uid, name as "chat with {sender uid}
      StorageUploadTask uploadTask = chatStorageReference
          .child(receiverUid)
          .child(senderUId)
          .child(Timestamp.now().toDate().toString())
          .putFile(image);

      // get image url
      String imageUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();

      //return url
      return imageUrl;
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: e.message);
      return null;
    }
  }

  Stream<QuerySnapshot> chatStream({@required String docId}) {
    /// stream to listen for chat collection ref. required[String currentUserUid, String receiverUid]

    return chatCollectionRef
        .document(docId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> chats({@required String currentUserUid}) {
    return chatCollectionRef
        .where('owner', arrayContains: currentUserUid.trim())
        .orderBy('lastMessage')
        .getDocuments();
  }

  Future<String> getUserChatDetails(
      {@required String currentUserUid, @required String receiverUid}) async {
    String chatBetweenDetails;
    await chatCollectionRef
        .where('owner.$currentUserUid', isEqualTo: true)
        .where('owner.$receiverUid', isEqualTo: true)
//        .orderBy('lastMessage', descending: true)
        .getDocuments()
        .then((doc) {
      print('test');
      print('lenght:' + doc.documents.length.toString());
      doc.documents.forEach((result) {
        chatBetweenDetails = result.documentID;
        print('r: ${result.documentID}');
      });
    });

    return chatBetweenDetails;
  }

  Stream<QuerySnapshot> fetchContacts({String userUid}) {
    return chatCollectionRef
        .where('owner.$userUid', isEqualTo: true)
        .orderBy('lastMessage', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> fetchLastMessageBetweenTwoUsers(
      {@required String chatDocId}) {
    return chatCollectionRef
        .document(chatDocId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();

//    print('read made to db to get the last mesage btw users chats');
  }
}
