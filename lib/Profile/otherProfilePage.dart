import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Chat/chatScreen.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Post/PostWidgets.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';

class OtherUsersProfilePage extends StatefulWidget {
  final UserDataModel user;

  OtherUsersProfilePage({@required this.user});

  @override
  _OtherUsersProfilePageState createState() => _OtherUsersProfilePageState();
}

class _OtherUsersProfilePageState extends State<OtherUsersProfilePage> {
  List<PostWidgets> postList = [];
  bool loading = false;
  int countPost = 0;

  @override
  void initState() {
    getAllPostForProfile();
    super.initState();
  }

  void getAllPostForProfile() async {
    print('uid: ${widget.user.uid}');
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }
      QuerySnapshot querySnapshot = await DatabaseService()
          .postCollection
          .document(widget.user.uid)
          .collection('userPost')
          .orderBy('timeCreated', descending: true)
          .getDocuments();

      if (mounted) {
        setState(() {
          loading = false;
          countPost = querySnapshot.documents.length;
          postList = querySnapshot.documents
              .map((documentSnapshot) =>
                  PostWidgets.fromDocument(documentSnapshot))
              .toList();
        });
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
    }
  }

  Widget editProfileButton() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: <Widget>[
          FlatButton(
            child: Container(
              width: MediaQuery.of(context).size.width * .45,
              height: 26.0,
              child: Text(
                'Follow',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            onPressed: () {},
          ),
          FlatButton(
            child: Container(
              width: MediaQuery.of(context).size.width * .45,
              height: 26.0,
              child: Text(
                'Message',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            onPressed: () {
              print(widget.user.fullName);
              // onTap of message, navigate to chat screen with this user
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        receiver: widget.user,
                      )));
            },
          ),
        ],
      ),
    );
  }

  Column createColumn({String title, int count}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$count',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }

  Widget showDisplayPic(displayPicUrl) {
    if (displayPicUrl == null) {
      return Container(
        child: CircleAvatar(
          radius: 45,
          backgroundImage: AssetImage('assets/profilePic_1.png'),
          backgroundColor: Colors.grey[300],
        ),
      );
    } else {
      return Container(
        child: CircleAvatar(
          radius: 65,
          backgroundImage: CachedNetworkImageProvider(displayPicUrl.toString()),
          backgroundColor: Colors.grey[600],
        ),
      );
    }
  }

  Widget createProfileTopView() {
    return FutureBuilder(
      future: DatabaseService().userCollection.document(widget.user.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SafeArea(
              child:
                  Container(child: Center(child: CircularProgressIndicator())));
        } else {
          var photoUrl = snapshot.data['displayPicUrl'].toString();
          print('url: $photoUrl');
          return Padding(
            padding: EdgeInsets.all(17.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    showDisplayPic(snapshot.data['displayPicUrl']),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              createColumn(title: 'posts', count: countPost),
                              createColumn(title: 'followers', count: 5),
                              createColumn(title: 'following', count: 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              editProfileButton(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 13.0),
                  child: Text(
                    snapshot.data['fullName'],
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5.0),
                  child: Text(
                    snapshot.data['userName'],
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3.0),
                  child: Text(
                    '${snapshot.data['bio']}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget displayPost() {
    if (loading == true) {
      return CircularProgressIndicator();
    } else if (postList.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30),
              child: Icon(
                Icons.photo_library,
                size: 200,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No Posts',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 30.0,
                  ),
                )),
          ],
        ),
      );
    } else {
      return Column(
        children: postList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            widget.user.uid == null
                ? Container(
                    child: Center(
                      child: Text('Loading....'),
                    ),
                  )
                : createProfileTopView(),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            displayPost(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 100,
//            width: 70,
//            child: Center(
//              child: CircularProgressIndicator(
//                backgroundColor: Colors.grey,
//              ),
//            ),
            ),
          ],
        ),
      ),
    );
  }
}
