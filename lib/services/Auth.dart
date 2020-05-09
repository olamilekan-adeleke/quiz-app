import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Chat/chatUtils.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/enum/userState.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference publicUserCollection =
      Firestore.instance.collection('publicUserData');

  // get current user
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await auth.currentUser();
    return currentUser;
  }

  // get use
  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await publicUserCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }

  Future<UserDataModel> getLoggedInUserDetails() async {
    try {
      FirebaseUser currentUser = await getCurrentUser();

      DocumentSnapshot documentSnapshot =
      await publicUserCollection.document(currentUser.uid).get();

      return UserDataModel.fromMap(documentSnapshot.data);
    }catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      return null;
    }
  }

  // get uid of logged in user
  Future<String> getCurrentUserUid() async {
    String uid;
    try {
      FirebaseUser currentUser;
      currentUser = await auth.currentUser();
      uid = currentUser.uid;
//      return currentUser.uid;
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      print(e);
    }
    return uid;
  }

  // create user model
  User userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream get user {
    return auth.onAuthStateChanged.map(userFromFirebase);
  }

  // sign in ann
  Future sigInAnnon() async {
    try {
      AuthResult result = await auth.signInAnonymously();
      FirebaseUser user = result.user;
      return userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email an pass
  Future loginWithEmailAndPassword({String email, String password}) async {
    try {
      AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      return null;
    }
  }

  // register with email an pass
  Future registerWithEmailAndPassword(
      {String email, String password, String fullName, String userName}) async {
    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseUser user = result.user;

      // create user data
      await DatabaseService(uid: user.uid).updateUserData(
        email: email,
        fullName: fullName,
        userName: userName,
      );

      // create public user data
      await DatabaseService(uid: user.uid).createPublicUserData(
        email: email,
        fullName: fullName,
        userName: userName,
      );

      return userFromFirebase(user);
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      print(e.toString());
      return null;
    }
  }

  Future<UserDataModel> getUserDetailByUid({String uid}) async {
    try {
      DocumentSnapshot documentSnapshot =
          await publicUserCollection.document(uid).get();
      return UserDataModel.fromDocument(documentSnapshot);
    } catch (e) {
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
      print(e.toString());
    }
  }

  void setUserState({@required String userUid, @required UserState userState}) {
    int stateToNumber = ChatUtils.stateToNumber(userState: userState);

    publicUserCollection.document(userUid).updateData({
      'state': stateToNumber,
      'lastSeen': Timestamp.now(),
    });
  }

  Stream<DocumentSnapshot> getUserStream({@required String uid}) =>
      publicUserCollection.document(uid).snapshots();

  //
}
