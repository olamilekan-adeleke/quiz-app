import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_image/network.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';
//import 'fl';

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
  bool showHeart = false;
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
    super.initState();
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

  Widget buil() {
    return Container(
      child: TransitionToImage(
        image: AdvancedNetworkImage(
          imageUrl,
          disableMemoryCache: true,
          loadedCallback: () {
            print('It works!');
          },
          loadFailedCallback: () {
            print('Oh, no!');
          },
          loadingProgress: (double progress, List lis) {
            print('Now Loading: $progress');
//            CircularProgressIndicator(
//              value: progress,
//            );
          },
        ),
        loadingWidgetBuilder: (_, double progress, __) =>
            Text(progress.toString()),
        fit: BoxFit.contain,
        placeholder: const Icon(Icons.refresh),
        width: 400.0,
        height: 300.0,
        enableRefresh: true,
      ),
    );
  }

//  Widget testPic() {
//    return MeetNetworkImage(
//      imageUrl: imageUrl,
//      loadingBuilder: (loadingBuilder) {
//        return Center(
//          child: CircularProgressIndicator(
//            value: loa,
//          ),
//        );
//      },
//      errorBuilder: (context, e) => Center(
//        child: Text('Error appear!'),
//      ),
//    );
//  }

  Widget testPic3() {
    return Image(
      image: new NetworkImageWithRetry(imageUrl),
    );
  }

  Widget testPic2() {
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

  Widget postImage() {
    return Container(
      height: MediaQuery.of(context).size.height * .65,
      width: MediaQuery.of(context).size.width,
      child: CachedNetworkImage(
//        cacheManager: DefaultCacheManager,
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
            ),
          ),
        ),
//        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        progressIndicatorBuilder: (context, url, downloadProgress) {
          print(downloadProgress.progress.toString() +
              ' / ' +
              downloadProgress.totalSize.toString());
          return Container(
            child: Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress),
            ),
          );
        },
      ),
    );
  }

  Widget postPic() {
    return Container(
      height: MediaQuery.of(context).size.height * .65,
//      width: MediaQuery.of(context).size.width,
      child: CachedNetworkImage(
//        cacheManager: Base,
        imageUrl: imageUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          print(downloadProgress.progress.toString() +
              ' / ' +
              downloadProgress.totalSize.toString());
          return Container(
            child: Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress),
            ),
          );
        },
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget postFooter() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () => print('liked'),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  size: 28.0,
                ),
                onPressed: () => print('navigate to comment page'),
              ),
            ),
          ],
        ),
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

  Widget wholePostBody() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
      ),
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
          testPic2(),
          postFooter(),
          Divider(),
        ],
      ),
    );
  }
}

class PostPicBody extends StatelessWidget {
  final String url;

  PostPicBody({this.url});

  Future<bool> cacheImage(String url, BuildContext context) async {
    bool hasError = true;
    var output = Completer<bool>();
    precacheImage(
      NetworkImage(url),
      context,
      onError: (e, stackTrace) => hasError = false,
    ).then((_) => output.complete(hasError));
    return output.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cacheImage(url, context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.hasError) {
          return Container(
            height: MediaQuery.of(context).size.height * .65,
            child: CircularProgressIndicator(),
          );
        }
//        if (snapshot.hasData == false) {
//          return Container(
//            height: MediaQuery.of(context).size.height * .65,
//            decoration: BoxDecoration(color: Colors.grey),
//            child: Text('Error'),
//          );
//        }
        else {
          return Container(
            height: MediaQuery.of(context).size.height * .65,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () => print('url: $url'),
              child: Image.network(url, fit: BoxFit.fill,
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
          );
        }
      },
    );
  }
}
