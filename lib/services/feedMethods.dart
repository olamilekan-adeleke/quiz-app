import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/services/Auth.dart';

class FeedMethods {
  final CollectionReference activityFeedCollectionRef =
      Firestore.instance.collection('feed');

  void removeLikeFromFeeds(
      {@required String ownUid, @required String postUid}) {
    /// delete from feeds

    try {
      activityFeedCollectionRef
          .document(ownUid)
          .collection('feedsItems')
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

  void addLikeToFeeds({
    @required String ownUid,
    @required String postUid,
    @required String currentOnlineUserUid,
    @required String imageUrl,
  }) async {
    /// add from feeds

    try {
      UserDataModel user = await AuthService().getLoggedInUserDetails();

      activityFeedCollectionRef
          .document(ownUid)
          .collection('feedsItems')
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
  }) async {

    try {
      UserDataModel user = await AuthService().getLoggedInUserDetails();

      activityFeedCollectionRef.document(ownerUid).collection('feedItems').add({
        'type': 'comment',
        'commentDate': timestamp,
        'postUid': postUid,
        'userUid': user.uid,
        'userName': user.uid,
        'userPhotoUrl': user.displayPicUrl,
        'imageUrl': postImageUrl
      });
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }




  //
}
