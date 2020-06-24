import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatWidgets/LastMessageBetween.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/services/Auth.dart';
import 'package:my_app_2_2/services/chatsMethods.dart';
import 'package:my_app_2_2/services/newChatMethods.dart';
import 'package:provider/provider.dart';

class ChatContactView extends StatelessWidget {
  final String currentUserUid;
  final String currentUserChatDocId;
  final AuthService auth = AuthService();

  ChatContactView({
    @required this.currentUserUid,
    @required this.currentUserChatDocId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: auth.getUserDetailByUid(uid: currentUserUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserDataModel userDataModel = snapshot.data;

          return ViewLayout(
            contact: userDataModel,
            chatDocId: currentUserChatDocId,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final UserDataModel contact;
  final String chatDocId;
  final ChatMethods chatMethods = ChatMethods();

  ViewLayout({@required this.contact, @required this.chatDocId});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return LastMessageBetweenDetails(
      stream: NewChatMethods()
          .fetchLastMessageBetweenTwoUsers(chatDocId: chatDocId),
      contact: contact,
      chatDocId: chatDocId,
    );

//    return CustomTile(
////      mini: false,
//      onTap: () {
//        Navigator.of(context).push(
//          MaterialPageRoute(
//            builder: (context) => ChatScreen(
//              receiver: contact,
//              chatDocId: chatDocId,
//            ),
//          ),
//        );
//      },
//      title: Text(
//        contact.userName,
//        style: TextStyle(fontSize: 19),
//      ),
////      subtitle: Text('subTitle'),
//      subtitle: LastMessageBetweenDetails(
//        stream: NewChatMethods().fetchLastMessageBetweenTwoUsers(chatDocId: chatDocId),
//      ),
//      leading: Container(
//        child: Stack(
//          children: <Widget>[
//            contact.displayPicUrl == null
//                ? CircleAvatar(
//                    radius: 35,
//                    backgroundImage: AssetImage('assets/profilePic_1.png'),
//                  )
//                : CachedImage(
//                    contact.displayPicUrl,
//                    radius: 60,
//                    isRound: true,
//                  ),
//            OnlineDotIndicator(
//              uid: contact.uid,
//            ),
//          ],
//        ),
//      ),
////      trailing: Column(
////        children: <Widget>[
////          Text(
////          )
////        ],
////      ),
//    );
  }
}
