import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/newChatWithRTDB/database.dart';
import 'package:provider/provider.dart';

class TestChat extends StatefulWidget {
  @override
  _TestChatState createState() => _TestChatState();
}

class _TestChatState extends State<TestChat> {
  TextEditingController textEditingController = TextEditingController();
  List chats = [];
  bool isLoading;
  Query _query;

  @override
  void initState() {
//    isLoading = true;
//    Database().getMessage(userUid: widget.userUid).then((Query query) {
//      setState(() {
//        _query = query;
//        print('done');
//      });
//    });
//    isLoading = false;
//    print(isLoading);
    super.initState();
  }

  Widget messageList() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('NO Items'),
        )
      ],
    );
  }

  Widget chatControlInputs({@required String uid}) {
    return Container(
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
            hintText: 'Input Here',
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
//                print(FirebaseDatabase.instance.reference().child('testMessages').child(uid).orderByChild('timestamp'));
//                print(DateTime.fromMillisecondsSinceEpoch(1).millisecond);
                sendMessage(uid: uid);
              },
            )),
      ),
    );
  }

  Widget messages({@required String userUid}) {
    if (_query.toString().trim() != null) {
      return FirebaseAnimatedList(
        physics: BouncingScrollPhysics(),
        query: Database().getMessage(userUid: userUid),
        itemBuilder: (context, snapshot, animation, index) {
          String messageKey = snapshot.key;
          Map map = snapshot.value;
          String msg = map['message'];
          return ListTile(
            title: Text(msg),
            subtitle: Text(messageKey),
          );
        },
      );
    } else {
      return Text('null');
    }
  }

  Widget streamMessage({@required String uid}) {
    return Flexible(
      child: StreamBuilder(
        stream: Database().chatsStream(userUid: uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('key ' + snapshot.data.snapshot.key.toString());
            print('snap ' + snapshot.data.snapshot.toString());
//                  print('val ' + snapshot.data.snapshot.value.toString());

            Map data = snapshot.data.snapshot.value;
            List items = [];

            if (data != null) {
              data.forEach((index, data) {
                items.add({'key': index, ...data});
                print({'key': index, ...data}.toString());
              });
//                    items = items.sort();
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
//                      Message meaasge = Message.fromMap(items[index]);
                  return ListTile(
                    title: Text(items[index]['message']),
                    trailing: Text(
                      DateFormat('hh:mm:ss')
                          .format(DateTime.fromMillisecondsSinceEpoch(
                            items[index]['timestamp'],
                          ))
                          .toString(),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No Messages'),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(title: Text('chat')),
      body: Column(
        children: <Widget>[
          messages(userUid: user.uid),
//          streamMessage(uid: user.uid),
          chatControlInputs(uid: user.uid),
        ],
      ),
    );
  }

  void sendMessage({@required String uid}) {
    if (textEditingController.value.text.trim() != '') {
      print(textEditingController.text.trim());
      Message message = Message(
          message: textEditingController.text.trim(),
          userUid: uid,
          isRead: false,
          timestamp: DateTime.now());
      print(message);

      WidgetsBinding.instance
          .addPostFrameCallback((_) => textEditingController.clear());
      Database().sendMessage(message: message);
      print('Done');
    }
  }
}

////
//class Todo {
//  String key;
//  String subject;
//  String userUid;
//  Timestamp timestamp;
//  bool isDone;
//
//  Todo({@required this.subject, @required this.userUid, @required this.isDone});
//
//  Todo.fromMap(DataSnapshot snapshot) {
//    key = snapshot.key;
//    subject = snapshot.value['subject'];
//    userUid = snapshot.value['userUid'];
//    timestamp = snapshot.value['timestamp'];
//    isDone = snapshot.value['isDone'];
//  }
//
//  Map toMap() {
//    return {
//      'userUid': userUid,
//      'subject': subject,
//      'isDone': isDone,
//      'timestamp': ServerValue.timestamp,
//    };
//  }
//}

class Message {
  String message;
  String userUid;
  DateTime timestamp;
  bool isRead;

  Message({
    @required this.message,
    @required this.userUid,
    @required this.isRead,
    @required this.timestamp,
  });

  Message.fromMap(DataSnapshot snapshot) {
    message = snapshot.value['message'];
    userUid = snapshot.value['userUid'];
    timestamp = snapshot.value['timestamp'];
    isRead = snapshot.value['isRead'];
  }

  Map toMap() {
    return {
      'userUid': userUid,
      'message': message,
      'isRead': isRead,
      'timestamp': ServerValue.timestamp,
    };
  }
}
