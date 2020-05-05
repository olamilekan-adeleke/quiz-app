import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatWidgets/ChatCustomTile.dart';

class ChatListScreen extends StatefulWidget {
  final currentUserUid;

  ChatListScreen({@required this.currentUserUid});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomTile(
            mini: false,
            onTap: () {},
            title: Text(
              'Ola Mi',
              style: TextStyle(fontSize: 19),
            ),
            subtitle: Text(
              'Hello',
              style: TextStyle(fontSize: 14),
            ),
            leading: Container(
              child: Stack(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/556667/pexels-photo-556667.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
