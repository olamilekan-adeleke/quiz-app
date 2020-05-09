import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Post/commentpage.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';
import 'package:my_app_2_2/services/feedMethods.dart';
import 'package:my_app_2_2/services/postMethods.dart';

class PostWidgets extends StatefulWidget {
  final String postId;
  final String ownerId;

  final dynamic timeCreated;
  final dynamic likes;
  final String userName;
  final String description;
  final String imageUrl;

  PostWidgets({
    this.postId,
    this.ownerId,
    this.timeCreated,
    this.likes,
    this.userName,
    this.description,
    this.imageUrl,
  });

  factory PostWidgets.fromDocument(DocumentSnapshot documentSnapshot) {
    return PostWidgets(
      postId: documentSnapshot['postId'],
      ownerId: documentSnapshot['ownerId'],
      timeCreated: documentSnapshot['timeCreated'],
      likes: documentSnapshot['likes'],
      userName: documentSnapshot['userName'],
      description: documentSnapshot['description'],
      imageUrl: documentSnapshot['imageUrl'],
    );
  }

  int getTotalNumberOfLikes({Map likes}) {
    if (likes == null) {
      return 0;
    }
    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });
    return counter;
  }

  @override
  _PostWidgetsState createState() => _PostWidgetsState(
        postId: this.postId,
        ownerId: this.ownerId,
        timeCreated: this.timeCreated,
        likes: this.likes,
        userName: this.userName,
        description: this.description,
        imageUrl: this.imageUrl,
        likeCount: this.getTotalNumberOfLikes(likes: this.likes),
      );
}

class _PostWidgetsState extends State<PostWidgets> {
  final String postId;
  final String ownerId;

  final Timestamp timeCreated;
  Map likes;
  final String userName;
  final String description;
  final String imageUrl;
  int likeCount;
  bool isLiked;
  bool showHeart;
  String currentUserId;

  _PostWidgetsState({
    this.postId,
    this.ownerId,
    this.timeCreated,
    this.likes,
    this.userName,
    this.description,
    this.imageUrl,
    this.likeCount,
  });

  @override
  void initState() {
    getCurrentUser();
//    isPostLikedByCurrentOnLineUser();
    super.initState();
  }

  void isPostLikedByCurrentOnLineUser() {
    if (likes[currentUserId] == true) {
      setState(() {
        showHeart = true;
      });
    } else {
      showHeart = false;
    }
  }

  void getCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        currentUserId = user.uid;
      });
    });
  }

  Widget postHeader() {
    return Material(
      elevation: 1.0,
      child: Container(
        child: FutureBuilder(
          future:
              DatabaseService().publicUserCollection.document(ownerId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              UserDataModel user = UserDataModel.fromDocument(snapshot.data);
              print(user.userName);
//          bool isPostOwner = currentUserId.toString() == ownerId;
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.displayPicUrl != null
                      ? CachedNetworkImageProvider(user.displayPicUrl)
                      : AssetImage('assets/profilePic_1.png'),
                  backgroundColor: Colors.grey,
                ),
                title: GestureDetector(
                  onTap: () => print('navigate to user profile'),
                  child: Text(
                    '${user.userName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => print('to delete post'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget postBody() {
    return Container(
      height: MediaQuery.of(context).size.height * .65,
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () => print(imageUrl.toString()),
        // gesture is used here so if user click on the image, the image will
        // expand to the screen width and height to get a better, bigger image view
        child: Container(
//          width: MediaQuery.of(context).size.width * .98,
          child: AspectRatio(
            aspectRatio: 16 / 9,
//            child: CachedNetworkImage(
//              imageUrl: imageUrl,
//              placeholder: (context, url) => CircularProgressIndicator(),
//              errorWidget: (context, url, error) => Icon(Icons.error),
//            ),
            child: Image.network(imageUrl, fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes
                    : null,
              ));
            }),
          ),
        ),
      ),
    );
  }

  Widget postBody2() {
    return ExtendedImage.network(
      imageUrl,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .65,
      fit: BoxFit.fill,
      cache: false,
//      border: Border.all(color: Colors.red, width: 1.0),
//      shape: boxShape,
//      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      //cancelToken: cancellationToken,
    );
  }

  Widget postFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 5),
                child: Container(
                  child: FlatButton(
                    onPressed: () {
                      likePostFunction();
                    },
                    child: showHeart == true || likes[currentUserId] == true
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 0, top: 5),
                child: Container(
                  child: FlatButton(
                    onPressed: () {
                      displayComment(context,
                          postUid: postId,
                          ownerUid: ownerId,
                          imageUrl: imageUrl);
                    },
                    child: Icon(Icons.chat_bubble_outline),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                '$likeCount likes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                '$userName   ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                '$description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
//            Expanded(
//              child: Text('${timeCreated.toString()}'),
//            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          postHeader(),
          postBody2(),
          postFooter(),
          Divider(),
        ],
      ),
    );
  }

  void addLike() {
    bool isNotPostOwner = currentUserId != ownerId;

    if (isNotPostOwner) {
      FeedMethods().addLikeToFeeds(
        ownUid: ownerId,
        postUid: postId,
        currentOnlineUserUid: currentUserId,
        imageUrl: imageUrl,
      );
      print('added');
    }
  }

  void removeLike() {
    bool isNotPostOwner = currentUserId != ownerId;
    if (isNotPostOwner) {
      FeedMethods().removeLikeFromFeeds(ownUid: ownerId, postUid: postId);
    }
  }

  void likePostFunction() {
    bool liked = likes[currentUserId] == true;

    if (liked == true) {
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        likes[currentUserId] = false;
        showHeart = false;
      });

      // remove like
      PostMethods().decrementLikeCount(
          ownerUid: ownerId, postUid: postId, currentUserUid: currentUserId);

      removeLike();
    } else if (!liked) {
      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        likes[currentUserId] = true;
        showHeart = true;
      });

      PostMethods().incrementLikeCount(
          ownerUid: ownerId, postUid: postId, currentUserUid: currentUserId);

      addLike();
      print('got here?');
    }
  }

  displayComment(BuildContext context,
      {@required String postUid,
      @required String ownerUid,
      @required String imageUrl}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommentPage(
          imageUrl: imageUrl,
          ownerUid: ownerUid,
          postUid: postUid,
        ),
      ),
    );
  }

}
