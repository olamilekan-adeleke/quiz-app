import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatWidgets/chatContactView.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/services/chatsMethods.dart';
import 'package:my_app_2_2/services/newChatMethods.dart';
import 'package:provider/provider.dart';

import 'chatWidgets/chatQuietBox.dart';

class ChatListScreen extends StatelessWidget {
  final ChatMethods chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: NewChatMethods().fetchContacts(userUid: user.uid),
//          stream: chatMethods.fetchContacts(userUid: user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('hasData');
              var docLis = snapshot.data.documents;

              if (docLis.isEmpty) {
                return ChatQuietBox();
              } else {
                print('hasData print');
                Map usersMapList = {};
                print(docLis[0].data['owner']);
                print(docLis[0].documentID);
                for (var map in docLis) {
                  var currentUser = map.data['owner'].keys;
                  String docId = map.documentID;
//                  print(map.data['owner']);
                  currentUser.forEach((doc) {
                    if (doc != user.uid) {
                      usersMapList.addAll({'$docId': doc});
//                      userList.add(doc);
                    }
                  });
                }
                print('lenDoc: ${docLis.length}');
                print('user: $usersMapList');
                print('keys: ${usersMapList.keys.toList()[0]}');
//                return Container();
                return ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    itemCount: docLis.length,
                    itemBuilder: (context, index) {
                      List userChatDocIdList = usersMapList.keys.toList();
                      List userUidList = usersMapList.values.toList();
//                ContactModel contact = ContactModel.fromMap(docLis[index].data);
                      return ChatContactView(
                        currentUserUid: userUidList[index],
                        currentUserChatDocId: userChatDocIdList[index],
                      );
                    },
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              );
            }
          }),
    );
  }
}
