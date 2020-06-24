import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_2_2/Post/PostWidgets.dart';
import 'package:my_app_2_2/Post/UploadNewPost.dart';
import 'package:my_app_2_2/notification/notificationPage.dart';
import 'package:my_app_2_2/services/postMethods.dart';

class ExplorePage extends StatefulWidget {
  final String userUid;

  ExplorePage({@required this.userUid});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<PostWidgets> posts;

  @override
  void initState() {
    getExplorePost();
    super.initState();
  }

  getExplorePost() async {
    posts = await PostMethods().getExplorePost(userUid: widget.userUid);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      appBar: customAppBar(),
      body: RefreshIndicator(
        child: explorePosts(),
        onRefresh: () => getExplorePost(),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
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

  Widget explorePosts() {
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
        return ListView(
          physics: BouncingScrollPhysics(),
          children: posts,
        );
      }
    }
  }

  AppBar customAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Explore',
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
          icon: FaIcon(
            FontAwesomeIcons.solidBell,
            color: Colors.teal,
          ),
        )
      ],
    );
  }
}
