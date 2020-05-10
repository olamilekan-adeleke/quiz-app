import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatUtils.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/enum/userState.dart';
import 'package:my_app_2_2/services/Auth.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthService authMethods = AuthService();

  OnlineDotIndicator({
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (ChatUtils.numbetToStae(number: state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.red;
      }
    }

    return Align(
      alignment: Alignment.topRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: authMethods.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          UserDataModel user;

          if (snapshot.hasData && snapshot.data.data != null) {
            user = UserDataModel.fromMap(snapshot.data.data);
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 5, top: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(user?.state),
            ),
          );
        },
      ),
    );
  }
}
