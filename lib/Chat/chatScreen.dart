import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_app_2_2/Chat/chatWidgets/ModalTile.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Models/messageModel.dart';
import 'package:my_app_2_2/services/chatsMethods.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserDataModel receiver;

  ChatScreen({@required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();
  String senderUid;
  String currentUserUid;

  static final Color senderColor = Color(0xff2b343b);
  static final Color receiverColor = Color(0xff1e2225);
  Radius messageRadius = Radius.circular(10);

  static final Color gradientColorStart = Colors.teal[300];
  static final Color gradientColorEnd = Colors.teal[500];
  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
  bool isWriting = false;

  void sendMessage() {
    // get current text val
    var text = textEditingController.text;

    // convert to message model
    Message message = Message(
      receiverUid: widget.receiver.uid,
      senderUid: senderUid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
    );

    setState(() {
      isWriting = false;
    });

    // add message to Db
    try {
      ChatMethods()
          .addMessageToDb(message: message)
          .timeout(Duration(seconds: 30));
    } catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of(context);
    setState(() {
      senderUid = user.uid;
      currentUserUid = user.uid;
      print(senderUid);
    });

    return Scaffold(
      appBar: myAppBar(),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          chatControlInputs(),
        ],
      ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.userName,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: ChatMethods().chatStream(
          currentUserUid: currentUserUid, receiverUid: widget.receiver.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          print('${snapshot.data.documents.length} len');
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return chatMessageItem(snapshot.data.documents[index]);
            },
          );
        }
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message message = Message.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        alignment: message.senderUid == currentUserUid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: message.senderUid == currentUserUid
            ? senderMessageLayout(message)
            : receiverMessageLayout(message), //senderMessageLayout(),
      ),
    );
  }

  Widget senderMessageLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        LimitedBox(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          child: Container(
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.only(
                topLeft: messageRadius,
                topRight: messageRadius,
                bottomLeft: messageRadius,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                getMessage(message: message),
                getTimeFormat(timestamp: message.timestamp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget receiverMessageLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        LimitedBox(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          child: Container(
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.teal[400],
              borderRadius: BorderRadius.only(
                  bottomRight: messageRadius,
                  topRight: messageRadius,
                  bottomLeft: messageRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getMessage(message: message),
                getTimeFormat(timestamp: message.timestamp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getMessage({@required Message message}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 2),
      child: Text(
        message.message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
      ),
    );
  }

  getTimeFormat({@required Timestamp timestamp}) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 1),
      child: Text(
//        DateFormat("MMM d, EEE HH:mm").format(timestamp.toDate()),
        DateFormat("MMM d, HH:mm").format(timestamp.toDate()),
        style: TextStyle(
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget chatControlInputs() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            gradient: fabGradient,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              showCustomBottomSheet();
            },
          ),
        ),
        Expanded(
          child: TextField(
            controller: textEditingController,
            style: TextStyle(
              color: Colors.white,
            ),
            onChanged: (val) {
              (val.length > 0 && val.trim() != '')
                  ? setWritingTo(true)
                  : setWritingTo(false);
            },
            decoration: InputDecoration(
              hintText: 'Type a Message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              filled: true,
              fillColor: Colors.teal[300],
            ),
          ),
        ),
        isWriting
            ? Container()
            : Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  gradient: fabGradient,
                  shape: BoxShape.circle,
                ),
                child:
                    IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
              ),
        isWriting
            ? Container(
                padding: EdgeInsets.only(right: 2),
                margin: EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  gradient: fabGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                    ),
                    onPressed: () {
                      print('sent');
                      sendMessage();
                    },
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  void showCustomBottomSheet() {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Colors.black,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ModalTile(
                      onTap: () => print('go to camera'),
                      title: "Camera",
                      subtitle: "Share Photos From Device Camera",
                      icon: Icons.photo_camera,
                    ),
                    ModalTile(
                      onTap: () => print('go to gallery'),
                      title: "Media",
                      subtitle: "Share Photos From Gallery",
                      icon: Icons.image,
                    ),
                    ModalTile(
                      onTap: () => print('go to file'),
                      title: "File",
                      subtitle: "Share files",
                      icon: Icons.tab,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
