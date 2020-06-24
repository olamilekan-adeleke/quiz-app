import 'package:flutter/material.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/services/newChatMethods.dart';
import 'package:provider/provider.dart';

class NewChatButton extends StatelessWidget {
  Future<void> test({String uid}) async {
    List userList = [];
    Map map = {};
    var q = NewChatMethods().fetchContacts(userUid: uid);
    print('q@: $q');
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return GestureDetector(
      onTap: () => test(uid: user.uid),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal,
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 25,
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}
