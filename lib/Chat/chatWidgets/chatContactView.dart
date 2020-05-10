import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatScreen.dart';
import 'package:my_app_2_2/Chat/chatWidgets/ChatCustomTile.dart';
import 'package:my_app_2_2/Chat/chatWidgets/LastMessageBetween.dart';
import 'package:my_app_2_2/Chat/chatWidgets/cachedImage.dart';
import 'package:my_app_2_2/Chat/chatWidgets/onlineIndicator.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Models/contactModel.dart';
import 'package:my_app_2_2/services/Auth.dart';
import 'package:my_app_2_2/services/chatsMethods.dart';
import 'package:provider/provider.dart';

class ChatContactView extends StatelessWidget {
  final ContactModel contact;
  final AuthService auth = AuthService();

  ChatContactView({@required this.contact});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: auth.getUserDetailByUid(uid: contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserDataModel userDataModel = snapshot.data;

          return ViewLayout(contact: userDataModel);
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
  final ChatMethods chatMethods = ChatMethods();

  ViewLayout({@required this.contact});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of(context);
    return CustomTile(
      mini: false,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(receiver: contact),
          ),
        );
      },
      title: Text(
        contact.userName,
        style: TextStyle(fontSize: 19),
      ),
      subtitle: LastMessageBetween(
        stream: chatMethods.fetchLastMessageBetweenTwoUsers(
            senderUid: user.uid, receiverUid: contact.uid),
      ),
      leading: Container(
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.displayPicUrl,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
