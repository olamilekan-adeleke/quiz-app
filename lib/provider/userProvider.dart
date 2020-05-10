import 'package:flutter/cupertino.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/services/Auth.dart';

class UserProvider with ChangeNotifier {
  String _user;
  AuthService authMethods = AuthService();

  String get getUser => _user;

  Future<void> refreshUser() async {
    User user = await authMethods.getUserDetails();
    _user = user.uid;
    notifyListeners();
  }
}
