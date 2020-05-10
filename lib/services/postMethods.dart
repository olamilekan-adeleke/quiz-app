import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/services/Auth.dart';
//import 'package:fluttertoast/fluttertoastAuth.dart';

class PostMethods {
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');
  final CollectionReference commentCollectionRef =
      Firestore.instance.collection('comments');

  // get specificPost to display for postScreenPage
  Future getSpecificPost({@required String userUid, @required String postUid}) {
    try {
      return postCollection
          .document(userUid)
          .collection('userPost')
          .document(postUid)
          .get();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  void decrementLikeCount(

      /// reduce like count
      {@required String ownerUid,
      @required String postUid,
      @required String currentUserUid}) {
    try {
      postCollection
          .document(ownerUid)
          .collection('userPost')
          .document(postUid)
          .updateData({'likes.$currentUserUid': false});
      Fluttertoast.showToast(msg: 'Post Unliked');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> incrementLikeCount(

      /// increase like count
      {
    @required String ownerUid,
    @required String postUid,
    @required String currentUserUid,
  }) async {
    try {
      postCollection
          .document(ownerUid)
          .collection('userPost')
          .document(postUid)
          .updateData({'likes.$currentUserUid': true});
      Fluttertoast.showToast(msg: 'Post liked');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Stream getCommentStream({@required String postUid}) {
    /// get a stream of comment on a particular post
    try {
      return commentCollectionRef
          .document(postUid)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots();
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: e.message);
      return null;
    }
  }

  Future<void> saveCommentToDatabase({
    @required String postUid,
    @required String comment,
    @required Timestamp timestamp
  }) async {
    /// sAVE COMMENT to Db

    try {
      UserDataModel user = await AuthService().getLoggedInUserDetails();

      commentCollectionRef.document(postUid).collection('comments').add({
        'userName': user.userName,
        'comment': comment,
        'timestamp': timestamp,
        'imageUrl': user.displayPicUrl,
        'userUid': user.uid,
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }


    //
}
