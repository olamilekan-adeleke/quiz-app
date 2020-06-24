import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_app_2_2/Chat/chatScreen.dart';
import 'package:my_app_2_2/Chat/chatWidgets/cachedImage.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Models/messageModel.dart';

class LastMessageBetweenDetails extends StatefulWidget {
  final stream;
  final UserDataModel contact;
  final String chatDocId;

  LastMessageBetweenDetails({
    @required this.stream,
    @required this.contact,
    @required this.chatDocId,
  });

  @override
  _LastMessageBetweenDetailsState createState() =>
      _LastMessageBetweenDetailsState();
}

class _LastMessageBetweenDetailsState extends State<LastMessageBetweenDetails> {
  Box<String> chatCheckBox = Hive.box<String>('chatCheck');

  Widget getIconIndicator({@required Message message}) {
    return Container(
      child: ValueListenableBuilder(
        valueListenable: chatCheckBox.listenable(),
        builder: (context, box, widget) {
          if (box.get(message.timestamp.toString()) == null) {
            return Container(
              child: Icon(Icons.check),
            );
          } else {
            return Container(
              child: Icon(Icons.access_time),
            );
          }
        },
      ),
    );
  }

  Widget newMessageIcon() {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }

  Widget getTimeFormat({@required Timestamp timestamp}) {
    return Padding(
      padding: EdgeInsets.only(top: 1),
      child: Text(
//        DateFormat("MMM d, HH:mm").format(timestamp.toDate()),
        DateFormat("HH:mm").format(timestamp.toDate()),
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget lastMessageDetails() {
    return StreamBuilder(
      stream: widget.stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data.documents;

          if (docList.isNotEmpty) {
            Message message = Message.fromMap(docList.last.data);
            return Column(
              children: <Widget>[
                Container(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            receiver: widget.contact,
                            chatDocId: widget.chatDocId,
                          ),
                        ),
                      );
                    },
                    leading: Container(
                      child: Stack(
                        children: <Widget>[
                          widget.contact.displayPicUrl == null
                              ? CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      AssetImage('assets/profilePic_1.png'),
                                )
                              : CachedImage(
                                  widget.contact.displayPicUrl,
                                  radius: 60,
                                  isRound: true,
                                ),
//                      OnlineDotIndicator(
//                        uid: widget.contact.uid,
//                      ),
                        ],
                      ),
                    ),
                    title: Text(
                      widget.contact.userName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400],
                      ),
                    ),
                    subtitle: Container(
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          getIconIndicator(message: message),
                          SizedBox(width: 5),
                          message.type == 'text'
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * .50,
                                  child: Text(
                                    message.message,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : Row(
                                  children: <Widget>[
                                    Text(
                                      '${message.photoUrl.length} picture sent',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Icon(Icons.photo, color: Colors.grey)
                                  ],
                                ),
                        ],
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        getTimeFormat(timestamp: message.timestamp),
                        newMessageIcon(),
                      ],
                    ),
                  ),
                ),
                Divider(),
              ],
            );
          } else {
            return Text(
              'No Message Yet!',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            );
          }
        } else {
          return Text(
            'Loading.....',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return lastMessageDetails();
//    return StreamBuilder(
//      stream: widget.stream,
//      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//        if (snapshot.hasData) {
//          var docList = snapshot.data.documents;
//
//          if (docList.isNotEmpty) {
//            Message message = Message.fromMap(docList.last.data);
//            return SizedBox(
//              width: MediaQuery.of(context).size.width * .6,
//              child: Text(
//                message.message,
//                maxLines: 1,
//                overflow: TextOverflow.ellipsis,
//                style: TextStyle(
//                  color: Colors.grey,
//                  fontSize: 14,
//                ),
//              ),
//            );
//          } else {
//            return Text(
//              'No Message Yet!',
//              style: TextStyle(
//                color: Colors.grey,
//                fontSize: 14,
//              ),
//            );
//          }
//        } else {
//          return Text(
//            'Loading.....',
//            style: TextStyle(
//              color: Colors.grey,
//              fontSize: 14,
//            ),
//          );
//        }
//      },
//    );
  }
}
