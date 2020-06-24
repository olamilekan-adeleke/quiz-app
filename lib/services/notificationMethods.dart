import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app_2_2/notification/notificationWidget/notificationItems.dart';

class NotificationMethods {
  final CollectionReference activityFeedCollectionRef =
      Firestore.instance.collection('feed');

  String feedItemSubCollectionName = 'feedItems';

  Future<List> retrieveNotifications({@required String currentUserUid}) async {
    QuerySnapshot querySnapshot = await activityFeedCollectionRef
        .document(currentUserUid)
        .collection(feedItemSubCollectionName)
        .orderBy('timestamp', descending: true)
        .limit(60)
        .getDocuments();

    List<NotificationItems> notificationItems = [];

    querySnapshot.documents.forEach((documents) {
      notificationItems.add(NotificationItems.fromDocuments(documents));
    });

    print(notificationItems.length);

    return notificationItems;
  }
}
