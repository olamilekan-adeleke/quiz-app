import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatWidgets/chatContactView.dart';
import 'package:my_app_2_2/Chat/chatWidgets/chatQuietBox.dart';
import 'package:my_app_2_2/Models/contactModel.dart';
import 'package:my_app_2_2/services/chatsMethods.dart';
import 'package:provider/provider.dart';

class ChatListScreen extends StatelessWidget {
  final ChatMethods chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of(context);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: chatMethods.fetchContacts(userUid: user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docLis = snapshot.data.documents;

              if (docLis.isEmpty) {
                return ChatQuietBox();
              } else {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(10),
                  itemCount: docLis.length,
                  itemBuilder: (context, index) {
                    ContactModel contact =
                        ContactModel.fromMap(docLis[index].data);
                    return ChatContactView(contact: contact);
                  },
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
