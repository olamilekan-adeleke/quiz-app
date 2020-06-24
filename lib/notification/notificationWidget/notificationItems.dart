import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;

Widget mediaPreview;
String notificationItemText;

class NotificationItems extends StatelessWidget {
  final String type;
  final String userName;
  final String userUid;
  final Timestamp timestamp;
  final String imageUrl;
  final String postUid;
  final String userPhotoUrl;
  final String comment;

  NotificationItems({
    this.type,
    this.userName,
    this.userUid,
    this.timestamp,
    this.imageUrl,
    this.postUid,
    this.userPhotoUrl,
    this.comment,
  });

  factory NotificationItems.fromDocuments(DocumentSnapshot documentSnapshot) {
    return NotificationItems(
      type: documentSnapshot['type'],
      userName: documentSnapshot['userName'],
      userUid: documentSnapshot['userUid'],
      timestamp: documentSnapshot['timestamp'],
      imageUrl: documentSnapshot['imageUrl'],
      postUid: documentSnapshot['postUid'],
      userPhotoUrl: documentSnapshot['userPhotoUrl'],
      comment: documentSnapshot['commentData'],
    );
  }

//  void navigateToProfilePage(context,
//      {@required UserDataModel commentOwnerDetails}) {
//    if (commentOwnerDetails.uid == currentUserUid) {
//      Navigator.of(context).push(MaterialPageRoute(
//          builder: (BuildContext context) => OwnerProfilePage()));
//    } else {
//      print('this is not logged in user!');
//      Navigator.of(context).push(MaterialPageRoute(
//          builder: (BuildContext context) => OtherUsersProfilePage(
//                user: commentOwnerDetails,
//              )));
//    }
//  }

  setMediaPreview(context) {
    if (type == 'comment' || type == 'like') {
      mediaPreview = GestureDetector(
        onTap: () {
          print('postUid: $postUid');
          print('userUid: $userUid');
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (context) =>
//                  PostScreenPage(userUid: userUid, postUid: postUid),
//            ),
//          );
        },
        child: Container(
          height: 50,
          width: 50,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: imageUrl != null
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(imageUrl),
                      ),
                    ),
                  )
                : Container(),
          ),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'like') {
      notificationItemText = 'Liked Your Post.';
    } else if (type == 'comment') {
      notificationItemText = 'Commented: $comment';
    } else if (type == 'follow') {
      notificationItemText = 'Started Following You.';
    } else {
      notificationItemText = 'Error, Unknown Type';
    }
  }

  @override
  Widget build(BuildContext context) {
    setMediaPreview(context);

    return Card(
      color: Colors.grey,
      child: Container(
        padding: EdgeInsets.only(bottom: 2.0),
        child: ListTile(
          title: GestureDetector(
            onTap: () {
              print('navigate to profile');
            },
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' $notificationItemText')
                ],
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: userPhotoUrl != null
                ? CachedNetworkImageProvider(userPhotoUrl)
                : AssetImage('assets/profilePic_1.png'),
            backgroundColor: Colors.grey,
          ),
          subtitle: Text(
            timeAgo.format(
              timestamp.toDate(),
            ),
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
