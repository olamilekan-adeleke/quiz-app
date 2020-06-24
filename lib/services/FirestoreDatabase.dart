import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // collection ref
  final CollectionReference userCollection =
      Firestore.instance.collection('userData');

  final CollectionReference publicUserCollection =
      Firestore.instance.collection('publicUserData');

//  final CollectionReference postCollection =
//      Firestore.instance.collection('posts');

  final CollectionReference exploreCollection =
      Firestore.instance.collection('explore');

  Future updateUserData(
      {String fullName, String email, String userName}) async {
    return await userCollection.document(uid).setData({
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'userName': userName,
      'displayPicUrl': null,
    });
  }

  Future createPublicUserData(
      {String fullName, String email, String userName}) async {
    return await publicUserCollection.document(uid).setData({
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'userName': userName,
      'displayPicUrl': null,
      'searchkey': userName.substring(0, 1).toLowerCase(),
    });
  }

  // update user profile pic
  Future updateUserDisplayPic({String imageUrl}) async {
    return await userCollection.document(uid).updateData({
      'displayPicUrl': imageUrl,
    });
  }

  // update user profile pic for public
  Future updateUserPublicDisplayPic({String imageUrl}) async {
    return await publicUserCollection.document(uid).updateData({
      'displayPicUrl': imageUrl,
    });
  }

  // update user userName
  Future updateUserUserName({String userName}) async {
    return await userCollection.document(uid).updateData({
      'userName': userName,
      'searchkey': userName.substring(0, 1).toLowerCase(),
    });
  }

  // update Public user userName
  Future updatePublicUserUserName({String userName}) async {
    return await publicUserCollection.document(uid).updateData({
      'userName': userName,
      'searchkey': userName.substring(0, 1).toLowerCase(),
    });
  }

  // user list form snapshot
  UserDataModel userDetailsFromSnapshot(DocumentSnapshot snapshot) {
    return UserDataModel(
      uid: uid,
      fullName: snapshot.data['fullName'],
      email: snapshot.data['email'],
      userName: snapshot.data['userName'],
      displayPicUrl: snapshot.data['displayPicUrl'],
    );
  }

  // get user data in stream
  Stream<UserDataModel> get userInfoInStreams {
    return userCollection
        .document(uid)
        .snapshots()
        .map(userDetailsFromSnapshot);
  }

//  // without streams
//  get userInfo async {
//    Future<DocumentSnapshot> querySnapshot =
//        publicUserCollection.document(uid).;
//  }

  // get all user
  Future<List<UserDataModel>> fetchAllUsers() async {
    List<UserDataModel> userLists = List<UserDataModel>();

    QuerySnapshot querySnapshot = await publicUserCollection.getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      userLists.add(UserDataModel.fromMap(querySnapshot.documents[i].data));
      print(querySnapshot.documents[i].data['email']);
    }
    return userLists;
  }

  // get specific users
  Future<List<UserDataModel>> fetchSpecificUsers({String keyWord}) async {
    List<UserDataModel> userLists = List<UserDataModel>();

    QuerySnapshot querySnapshot = await publicUserCollection
        .where('searchkey', isEqualTo: keyWord)
        .getDocuments();
    print('got 1');
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      userLists.add(UserDataModel.fromMap(querySnapshot.documents[i].data));
      print(querySnapshot.documents[i].data['email']);
    }
    return userLists;
  }

  // save post info to fire store
//  Future savePostInfoToFireStore(
//      {String imageUrl,
//      String description,
//      String userName,
//      String ownerUid,
//      String postId}) async {
//    print('saving');
//    postCollection
//        .document(ownerUid)
//        .collection('userPost')
//        .document(postId)
//        .setData({
//      'postId': postId,
//      'ownerId': ownerUid,
//      'timeCreated': Timestamp.now(),
//      'likes': {},
//      'userName': userName,
//      'description': description,
//      'imageUrl': imageUrl,
//    });
//    print('done');
//  }

  Future savePostToDb(
      {String imageUrl,
      String description,
      String userName,
      String ownerUid,
      String postId}) async {
    var db = Firestore.instance;
    WriteBatch batch = db.batch();

    DocumentReference userDetailsCollectionRef =
        publicUserCollection.document(ownerUid);

//    DocumentReference userPostCollectionRef = postCollection
//        .document(ownerUid)
//        .collection('userPost')
//        .document(postId);

    DocumentReference explorePostCollectionRef = exploreCollection
        .document('posts')
        .collection('allPosts')
        .document(postId);

//    batch.setData(
//      userPostCollectionRef,
//      {
//        'postId': postId,
//        'timeCreated': Timestamp.now(),
//      },
//    );

    batch.updateData(
      userDetailsCollectionRef,
      {
        'postCount': FieldValue.increment(1),
      },
    );

    batch.setData(
      explorePostCollectionRef,
      {
        'postId': postId,
        'ownerId': ownerUid,
        'timeCreated': Timestamp.now(),
        'likes': {},
        'userName': userName,
        'description': description,
        'imageUrl': imageUrl,
        'commentCount': 0,
      },
    );

    batch.commit();
  }

//
}
