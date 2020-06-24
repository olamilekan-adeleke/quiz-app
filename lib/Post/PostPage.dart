import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Post/PostWidgets.dart';
import 'package:my_app_2_2/notification/notificationPage.dart';
import 'package:my_app_2_2/services/postMethods.dart';

import 'UploadNewPost.dart';

class PostsPage extends StatefulWidget {
  final String userUid;

  PostsPage({@required this.userUid});

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  String currentUserId;
  List<PostWidgets> posts;
  List<String> followingList = [];

//  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
//    getCurrentUser();
    print('uid:    ${widget.userUid}');
    getTimeLinePost();
//    getFollowings();
    super.initState();
  }

  getTimeLinePost() async {
    posts = await PostMethods().getUserTimeLinePost(userUid: widget.userUid);
    if (mounted) {
      setState(() {});
    }
  }

//  getFollowings() async {
//    followingList = await PostMethods()
//        .getUserFollowingForTimeLinePage(userUid: widget.userUid);
//    if (mounted) {
//      setState(() {});
//    }
//  }

  void getCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        currentUserId = user.uid;
      });
    });
  }

  Widget noPostBox() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.photo_library,
              size: 100,
              color: Colors.grey,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              'No Post Found',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              'Follow Your Friends To See Their Post Or Check Out The Explore Page.',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  createUserTimeLine() {
    print('post len: $posts');
    if (posts == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      print('here first');
      if (posts.isEmpty) {
        print('here next');
        return Container(
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .45,
              width: MediaQuery.of(context).size.width * .55,
              child: noPostBox(),
            ),
          ),
        );
      } else {
        return ListView(children: posts);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('uid: $currentUserId');
    return Scaffold(
//      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'TimeLine',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotificationPage(),
                ),
              );
            },
            icon: Icon(Icons.notifications, color: Colors.teal),
          )
        ],
      ),
      body: RefreshIndicator(
        child: createUserTimeLine(),
        onRefresh: () => getTimeLinePost(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UploadNewPostPage(),
            ),
          );
        },
        child: Icon(Icons.add_photo_alternate),
      ),
    );
  }
}
