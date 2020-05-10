import 'package:flutter/material.dart';
import 'package:my_app_2_2/Post/PostWidgets.dart';
import 'package:my_app_2_2/services/postMethods.dart';

class PostScreenPage extends StatelessWidget {
  final String userUid;
  final String postUid;

  PostScreenPage({@required this.userUid, @required this.postUid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PostMethods().getSpecificPost(userUid: userUid, postUid: postUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          PostWidgets post = PostWidgets.fromDocument(snapshot.data);
          return Center(
            child: Scaffold(
              appBar: AppBar(
                title: Text(post.description),
              ),
              body: ListView(
                children: <Widget>[
                  Container(
                    child: post,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
