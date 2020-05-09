import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Models/contactModel.dart';
import 'package:my_app_2_2/Models/messageModel.dart';
import 'package:my_app_2_2/provider/imageUploadProvider.dart';

class ChatMethods {
  final chatCollectionRef = Firestore.instance.collection('messages');
  final StorageReference chatStorageReference =
      FirebaseStorage.instance.ref().child('ChatImagePictures');

  final contactsCollectionRef = Firestore.instance.collection('Contacts');

  Future<void> addMessageToDb({Message message}) async {
    /// add/upload message to chat database. required[Message message]

    try {
      // convert message to map
      var messageMap = message.toMap();

      // add message to sender database collection
      await chatCollectionRef
          .document(message.senderUid)
          .collection(message.receiverUid)
          .document(message.timestamp.microsecondsSinceEpoch.toString())
          .setData(messageMap);
//          .add(messageMap);

      // add message to receiver database collection
      await chatCollectionRef
          .document(message.receiverUid)
          .collection(message.senderUid)
          .document(message.timestamp.microsecondsSinceEpoch.toString())
          .setData(messageMap);
//          .add(messageMap);

      await addToContacts(
        senderUid: message.senderUid,
        receiverUid: message.receiverUid,
      );
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  // this function is to get the stream to doc of chats order by time sent.
  Stream<QuerySnapshot> chatStream(
      {@required String currentUserUid, @required String receiverUid}) {
    /// stream to listen for chat collection ref. required[String currentUserUid, String receiverUid]

    return chatCollectionRef
        .document(currentUserUid)
        .collection(receiverUid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String> uploadImageToStorage(
      {@required File image, String receiverUid, String senderUId}) async {
    /// upload image to storage and get/return url. required[File image]

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

  void uploadImage(
      {@required File image,
      @required String receiverUid,
      @required String senderUId,
      @required ImageUploadProvider imageUploadProvider}) async {
    /// upload chats image details to chat database

    Message message;

    imageUploadProvider.setToLoading();

    // await url
    String imageUrl = await uploadImageToStorage(
        image: image, receiverUid: receiverUid, senderUId: senderUId);

    try {
      if (imageUrl != null) {
        // convert image message to map/json format
        message = Message.imageMessage(
          message: "Image",
          receiverUid: receiverUid,
          senderUid: senderUId,
          timestamp: Timestamp.now(),
          type: 'image',
          photoUrl: imageUrl,
          sent: false,
          read: false,
        );

        imageUploadProvider.setToIdle();

        Map imageMessageMap = message.toImageMap();

        // set/upload to database now
        await chatCollectionRef
            .document(message.senderUid)
            .collection(message.receiverUid)
            .add(imageMessageMap);

        // add message to receiver database collection
        await chatCollectionRef
            .document(message.receiverUid)
            .collection(message.senderUid)
            .add(imageMessageMap);

        await addToContacts(
            senderUid: message.senderUid, receiverUid: message.receiverUid);
      }
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>

      /// get contact ref of the sender
      contactsCollectionRef
          .document(of)
          .collection('contacts')
          .document(forContact);

  Future<void> addToSenderContact(
      String senderUid, String receiverUid, currentTime) async {
    // add to sender contact Db
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderUid, forContact: receiverUid).get();

    // add if only the sender document dose not already exist
    if (!senderSnapshot.exists) {
      ContactModel receiverContact = ContactModel(
        uid: receiverUid,
        addedOn: currentTime,
        lastMessageTimestamp: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);
      getContactsDocument(of: senderUid, forContact: receiverUid)
          .setData(receiverMap);
    } else if (senderSnapshot.exists) {
//      ContactModel receiverContact = ContactModel(
//        lastMessageTimestamp: currentTime,
//      );

//      var receiverMap = receiverContact.toMap(receiverContact);
      getContactsDocument(of: senderUid, forContact: receiverUid).updateData({
        'lastMessageTimestamp': currentTime,
      });
    }
  }

  Future<void> addToReceiverContact(
      String senderUid, String receiverUid, currentTime) async {
    // add to sender contact Db
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverUid, forContact: senderUid).get();

    // add if only the sender document dose not already exist
    if (!receiverSnapshot.exists) {
      ContactModel senderContact = ContactModel(
        uid: senderUid,
        addedOn: currentTime,
        lastMessageTimestamp: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);
      getContactsDocument(of: receiverUid, forContact: senderUid)
          .setData(senderMap);
    }
    // if it exist the add the time of last sent message so the chat list can be order by it
    // meaning lAst sent message is at
    if (receiverSnapshot.exists) {
//      ContactModel senderContact = ContactModel(
//        lastMessageTimestamp: currentTime,
//      );

//      var senderMap = senderContact.toMap(senderContact);
      getContactsDocument(of: receiverUid, forContact: senderUid).updateData({
        'lastMessageTimestamp': currentTime,
      });
    }
  }

  addToContacts({String senderUid, String receiverUid}) async {
    /// add user to  list for chat list

    // get current time of first chat
    Timestamp currentTime = Timestamp.now();
    await addToSenderContact(senderUid, receiverUid, currentTime);
    await addToReceiverContact(senderUid, receiverUid, currentTime);
  }

  Stream<QuerySnapshot> fetchContacts({String userUid}) => contactsCollectionRef
      .document(userUid)
      .collection('contacts')
      .orderBy('lastMessageTimestamp', descending: true)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetweenTwoUsers(
          {@required String senderUid, @required String receiverUid}) =>
      chatCollectionRef
          .document(senderUid)
          .collection(receiverUid)
          .orderBy('timestamp')
          .snapshots();

  Future<void> updateIsSent({@required Message message}) async {
    await chatCollectionRef
        .document(message.senderUid)
        .collection(message.receiverUid)
        .document(message.timestamp.microsecondsSinceEpoch.toString())
        .updateData({
      'sent': true,
    });

    // add message to receiver database collection
    await chatCollectionRef
        .document(message.receiverUid)
        .collection(message.senderUid)
        .document(message.timestamp.microsecondsSinceEpoch.toString())
        .updateData({
      'sent': true,
    });
//        .add(messageMap);
  }

  Future<void> updateIsRead({@required Message message}) async {
    await chatCollectionRef
        .document(message.senderUid)
        .collection(message.receiverUid)
        .document(message.timestamp.microsecondsSinceEpoch.toString())
        .updateData({
      'read': true,
    });

    // add message to receiver database collection
    await chatCollectionRef
        .document(message.receiverUid)
        .collection(message.senderUid)
        .document(message.timestamp.microsecondsSinceEpoch.toString())
        .updateData({
      'read': true,
    });
    print('messgae read!');
  }
}
