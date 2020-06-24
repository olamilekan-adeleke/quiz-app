import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatListScreen.dart';
import 'package:my_app_2_2/Chat/chatWidgets/newChatButton.dart';

class ChatHomePage extends StatelessWidget {
  final Color accentColor = Color(0xfffef9eb);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {},
        ),
        elevation: 0.0,
        title: Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(
                Icons.search,
                size: 25,
              ),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              icon: Icon(
                Icons.more_vert,
                size: 25,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 30.0,
//            color: Colors.green,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
                color: Colors.white,
              ),
              child: ChatListScreen(),
            ),
          ),
        ],
      ),
      floatingActionButton: NewChatButton(),
    );
  }
}
