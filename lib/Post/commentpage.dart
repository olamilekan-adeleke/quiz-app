import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Chat/chatWidgets/cachedImage.dart';
import 'package:my_app_2_2/services/feedMethods.dart';
import 'package:my_app_2_2/services/postMethods.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class CommentPage extends StatefulWidget {
  final String postUid;
  final String ownerUid;
  final String imageUrl;

  CommentPage(
      {@required this.imageUrl,
      @required this.ownerUid,
      @required this.postUid});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentTextEditingController = TextEditingController();
  String currentUserUid;

  void saveComment() {
    Timestamp timestamp = Timestamp.now();

    PostMethods().saveCommentToDatabase(
      postUid: widget.postUid,
      comment: commentTextEditingController.text,
      timestamp: timestamp,
    );

    bool isNotPostOwner = widget.postUid != currentUserUid;

    if (isNotPostOwner) {
      FeedMethods().addCommentToFeed(
        ownerUid: widget.ownerUid,
        timestamp: timestamp,
        postUid: widget.postUid,
        postImageUrl: widget.imageUrl,
      );
    }
    commentTextEditingController.clear();
  }

  Widget displayComments() {
    return StreamBuilder(
      stream: PostMethods().getCommentStream(postUid: widget.postUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<Comment> comment = [];
          snapshot.data.documents.forEach((doc) {
            comment.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: comment,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of(context);
    setState(() {
      currentUserUid = user.uid;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentTextEditingController,
              decoration: InputDecoration(
                labelText: 'Write comment here..',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            trailing: OutlineButton(
              onPressed: () {
                if (commentTextEditingController.text.trim().length > 0 &&
                    commentTextEditingController.text.trim() != '') {
                  saveComment();
                } else {
                  Fluttertoast.showToast(msg: 'please Input Comment');
                }
              },
              borderSide: BorderSide.none,
              child: Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userName;
  final String userUid;
  final String imageUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.userName,
    this.userUid,
    this.imageUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot) {
    return Comment(
      userName: documentSnapshot['userName'],
      userUid: documentSnapshot['userUid'],
      imageUrl: documentSnapshot['imageUrl'],
      comment: documentSnapshot['comment'],
      timestamp: documentSnapshot['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0),
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                userName + ': ' + comment,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              leading: CachedImage(
                imageUrl,
                isRound: true,
                radius: 30,
              ),
              subtitle: Text(
                timeAgo.format(timestamp.toDate()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
