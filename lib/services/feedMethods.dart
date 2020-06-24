import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/services/Auth.dart';

class FeedMethods {
  final CollectionReference activityFeedCollectionRef =
      Firestore.instance.collection('feed');
  String feedItemSubCollectionName = 'feedItems';

  Future<void> removeLikeFromFeeds(
      {@required String ownUid, @required String postUid}) async {
    /// delete from feeds

    try {
      await activityFeedCollectionRef
          .document(ownUid)
          .collection(feedItemSubCollectionName)
          .document(postUid)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> addLikeToFeeds({
    @required String ownUid,
    @required String postUid,
    @required String currentOnlineUserUid,
    @required String imageUrl,
  }) async {
    /// add from feeds

    try {
      UserDataModel user = await AuthService().getLoggedInUserDetails();

      await activityFeedCollectionRef
          .document(ownUid)
          .collection(feedItemSubCollectionName)
          .document(postUid)
          .setData({
        'type': 'like',
        'userName': user.userName,
        'userUid': currentOnlineUserUid,
        'timestamp': Timestamp.now(),
        'imageUrl': imageUrl,
        'postUid': postUid,
        'userPhotoUrl': user.displayPicUrl,
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> addCommentToFeed({
    @required String ownerUid,
    @required Timestamp timestamp,
    @required String postUid,
    @required String postImageUrl,
    @required String comment,
  }) async {
    try {
      UserDataModel user = await AuthService().getLoggedInUserDetails();

      activityFeedCollectionRef
          .document(ownerUid)
          .collection(feedItemSubCollectionName)
          .add({
        'type': 'comment',
        'userName': user.userName,
        'userUid': user.uid,
        'commentData': comment,
        'imageUrl': postImageUrl,
        'postUid': postUid,
        'userPhotoUrl': user.displayPicUrl,
        'timestamp': timestamp,
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> addFeedItem(
      {@required String searchUserUid,
      @required String currentLoggedInUserUid,
      @required Timestamp timestamp}) async {
    try {
      UserDataModel currentUser = await AuthService().getLoggedInUserDetails();

      //
      activityFeedCollectionRef
          .document(searchUserUid)
          .collection(feedItemSubCollectionName)
          .document(currentLoggedInUserUid)
          .setData({
        'type': 'follow',
        'timestamp': timestamp,
        'ownerUid': searchUserUid,
        'followerUserName': currentUser.userName,
        'followerPhotoUrl': currentUser.displayPicUrl,
        'followerUid': currentUser.uid,
      });
      print('done follow');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.messgae);
    }
  }

  void deleteFeedItem(
      {@required String searchUserUid,
      @required String currentLoggedInUserUid}) {
    activityFeedCollectionRef
        .document(searchUserUid)
        .collection(feedItemSubCollectionName)
        .document(currentLoggedInUserUid)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
        print('done unfollow');
      }
    });
  }

//
}
