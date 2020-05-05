import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'UploadNewPost.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  String currentUserId;

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

  @override
  Widget build(BuildContext context) {
    print('uid: $currentUserId');
    return Scaffold(
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
