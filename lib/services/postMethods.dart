import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Post/PostWidgets.dart';
import 'package:my_app_2_2/services/Auth.dart';

class PostMethods {
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');
  final CollectionReference commentCollectionRef =
      Firestore.instance.collection('comments');
  final CollectionReference timeLineCollectionRef =
      Firestore.instance.collection('timeline');
  final CollectionReference followingCollectionRef =
      Firestore.instance.collection('following');
  final CollectionReference exploreCollection =
      Firestore.instance.collection('explore');

  // get specificPost to display for postScreenPage
  Future<DocumentSnapshot> getSpecificPost(
      {@required String userUid, @required String postUid}) async {
    print('post id got: $postUid');
    print('uid got: $userUid');

    print('check: posts/$userUid/userPost/$postUid');
//    print(postCollection
//        .document(userUid)
//        .collection('userPost')
//        .document(postUid)
//        .get()
//        .then((doc) {
////      print(doc.data.values);
//      print(doc.exists);
//    }));

    DocumentSnapshot post = await postCollection
        .document(userUid)
        .collection('userPost')
        .document(postUid)
        .get();

    print(post.documentID + '    id');

    return post;
  }

  Future<void> decrementLikeCount(

      /// reduce like count
      {@required String ownerUid,
      @required String postUid,
      @required String currentUserUid}) async {
    try {
      await exploreCollection
          .document('posts')
          .collection('allPosts')
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
      exploreCollection
        ..document('posts')
            .collection('allPosts')
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
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
      return null;
    }
  }

  Future<void> saveCommentToDatabase({
    @required String postUid,
    @required String comment,
    @required Timestamp timestamp,
  }) async {
    /// sAVE COMMENT to Db
    ///

    var db = Firestore.instance;
    WriteBatch batch = db.batch();

    try {
      UserDataModel user = await AuthService().getLoggedInUserDetails();

      DocumentReference commentRef = commentCollectionRef
          .document(postUid)
          .collection('comments')
          .document();

      DocumentReference postRef = exploreCollection
          .document('posts')
          .collection('allPosts')
          .document(postUid);

      batch.setData(commentRef, {
        'userName': user.userName,
        'comment': comment,
        'timestamp': timestamp,
        'imageUrl': user.displayPicUrl,
        'userUid': user.uid,
        'type': 'text'
      });

      batch.updateData(
        postRef,
        {
          'commentCount': FieldValue.increment(1),
        },
      );

      batch.commit();

//      commentCollectionRef.document(postUid).collection('comments').add({
//        'userName': user.userName,
//        'comment': comment,
//        'timestamp': timestamp,
//        'imageUrl': user.displayPicUrl,
//        'userUid': user.uid,
//        'type': 'text'
//      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<List<PostWidgets>> getUserTimeLinePost(
      {@required String userUid}) async {
    QuerySnapshot querySnapshot = await timeLineCollectionRef
        .document(userUid)
        .collection('timelinePosts')
        .orderBy('timeCreated', descending: true)
        .getDocuments();

    List<PostWidgets> allPost = querySnapshot.documents
        .map((document) => PostWidgets.fromDocument(document))
        .toList();

    return allPost;
  }

  Future<List<PostWidgets>> getExplorePost({@required String userUid}) async {
    QuerySnapshot querySnapshot = await exploreCollection
        .document('posts')
        .collection('allPosts')
        .orderBy('timeCreated', descending: true)
        .getDocuments();

    List<PostWidgets> allPost = querySnapshot.documents
        .map((document) => PostWidgets.fromDocument(document))
        .toList();

    return allPost;
  }

  Future<List> getUserFollowingForTimeLinePage(
      {@required String userUid}) async {
    QuerySnapshot querySnapshot = await followingCollectionRef
        .document(userUid)
        .collection('userFollowing')
        .getDocuments();

    List followingList =
        querySnapshot.documents.map((document) => document.documentID).toList();

    return followingList;
  }

//
}
