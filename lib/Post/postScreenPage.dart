import 'package:flutter/material.dart';
import 'package:my_app_2_2/services/postMethods.dart';

class PostScreenPage extends StatelessWidget {
  final String userUid;
  final String postUid;

  PostScreenPage({@required this.userUid, @required this.postUid});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // check: posts/nrQG6SPgCKXQ5yMeqQRiMBv4SIg1/userPost/69c01341-48a4-472c-9cb9-e8f54af50756
      child: FutureBuilder(
//        future: PostMethods()
//            .postCollection
//            .document(userUid)
//            .collection('userPost')
//            .document('79b98aa6-314f-40c1-9e16-3c9fd9f7fbbb')
//            .get(),
        future:
            PostMethods().getSpecificPost(userUid: userUid, postUid: postUid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            print(snapshot.data['userName']);
//            PostWidgets post = PostWidgets.fromDocument(snapshot.data);
            return Center(
              child: Scaffold(
                appBar: AppBar(
//                  title: Text(post.description),
                    ),
                body: ListView(
                  children: <Widget>[
                    Container(
//                      child: post,
                        ),
                  ],
                ),
              ),
            );
          } else {
            return Text('text');
          }
        },
      ),
    );
  }
}
