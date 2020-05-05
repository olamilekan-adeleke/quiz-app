import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // get current user
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await auth.currentUser();
    return currentUser;
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
}
