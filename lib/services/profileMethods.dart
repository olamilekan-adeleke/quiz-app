import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileMethods {
  final CollectionReference postCollection =
      Firestore.instance.collection('posts');
  final CollectionReference followersCollectionRef =
      Firestore.instance.collection('followers');
  final CollectionReference followingCollectionRef =
      Firestore.instance.collection('following');
  final CollectionReference exploreCollectionRef =
      Firestore.instance.collection('explore');

  Future followYourSelfAfterRegistration({@required String userUid}) async {
    /// user will ahve to follow him/her self so she can see her own post on the timeline page
    await followersCollectionRef
        .document(userUid)
        .collection('userFollowers')
        .document(userUid)
        .setData({});
  }

  Future<QuerySnapshot> getUserPost({@required String userUid}) async {
    // TODO: save the post count in the users public details
    /// get a list of all post
    QuerySnapshot querySnapshot = await exploreCollectionRef
        .document('posts')
        .collection('allPosts')
        .where('ownerId', isEqualTo: userUid)
        .orderBy('timeCreated', descending: true)
        .getDocuments();

    return querySnapshot;
  }

  void addCurrentLoggedInUserFromSearchUserFollowers(
      {@required String searchUserUid,
      @required String currentLoggedInUserUid}) {
    try {
      followersCollectionRef
          .document(searchUserUid)
          .collection('userFollowers')
          .document(currentLoggedInUserUid)
          .setData({});
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.messgae);
    }
  }

  void addSearchUserFromCurrentLoggedInUserFollowings(
      {@required String searchUserUid,
      @required String currentLoggedInUserUid}) {
    try {
      followingCollectionRef
          .document(currentLoggedInUserUid)
          .collection('userFollowing')
          .document(searchUserUid)
          .setData({});
      print('done follow');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.messgae);
    }
  }

  void deleteCurrentLoggedInUserFromSearchUserFollowers(
      {@required String searchUserUid,
      @required String currentLoggedInUserUid}) {
    try {
      followersCollectionRef
          .document(searchUserUid)
          .collection('userFollowers')
          .document(currentLoggedInUserUid)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
          print('done unfollow');
        }
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.messgae);
    }
  }

  void deleteSearchUserFromCurrentLoggedInUserFollowings(
      {@required String searchUserUid,
      @required String currentLoggedInUserUid}) {
    try {
      followingCollectionRef
          .document(currentLoggedInUserUid)
          .collection('userFollowing')
          .document(searchUserUid)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
          print('done unfollow');
        }
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.messgae);
    }
  }

  Future<bool> checkIfFollowing(
      {@required String userProfileUid,
      @required String currentUserUid}) async {
    print('useruid: $userProfileUid');
    print('currentuser: $currentUserUid');
    bool isFollowing;

    try {
      DocumentSnapshot documentSnapshot = await followersCollectionRef
          .document(userProfileUid)
          .collection('userFollowers')
          .document(currentUserUid)
          .get();

      print('folllowing = ${documentSnapshot.exists.toString()}');

      if (documentSnapshot.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.messgae);
    }

    return isFollowing;
  }

  Future<int> getUserFollowingsCount({@required String userProfileUid}) async {
    int totalFollowings = 0;

    try {
      QuerySnapshot querySnapshot = await followingCollectionRef
          .document(userProfileUid)
          .collection('userFollowing')
          .getDocuments();

      totalFollowings = querySnapshot.documents.length;
      print(totalFollowings.toString() + ' 00000');

      return totalFollowings;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.messgae);
      return 0;
    }
  }

  Future<int> getUsersFollowersCount({@required String userProfileUid}) async {
    int totalFollowers;

    try {
      QuerySnapshot querySnapshot = await followersCollectionRef
          .document(userProfileUid)
          .collection('userFollowers')
          .getDocuments();

      totalFollowers = querySnapshot.documents.length;

      return totalFollowers;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.messgae);
      return 0;
    }
  }
}
