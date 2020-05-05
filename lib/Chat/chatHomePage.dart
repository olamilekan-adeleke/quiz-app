import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatListScreen.dart';
import 'package:provider/provider.dart';

class ChatHomePage extends StatefulWidget {
  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  String currentUserUid;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of(context);
    setState(() {
      currentUserUid = user.uid;
    });

    return Scaffold(
      appBar: AppBar(
        leading: null,
        elevation: 0,
        title: Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 35,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.search,
              size: 25,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.more_vert,
              size: 25,
            ),
          ),
        ],
      ),
      body: ChatListScreen(currentUserUid: currentUserUid),
    );
  }
}
