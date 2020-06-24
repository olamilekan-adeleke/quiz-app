import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Chat/chatScreen.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/Post/PostWidgets.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';
import 'package:my_app_2_2/services/feedMethods.dart';
import 'package:my_app_2_2/services/newChatMethods.dart';
import 'package:my_app_2_2/services/profileMethods.dart';
import 'package:provider/provider.dart';

class OtherUsersProfilePage extends StatefulWidget {
  final UserDataModel user;

  OtherUsersProfilePage({@required this.user});

  @override
  _OtherUsersProfilePageState createState() => _OtherUsersProfilePageState();
}

class _OtherUsersProfilePageState extends State<OtherUsersProfilePage> {
  String currentOnlineUserUid;
  List<PostWidgets> postList = [];
  bool loading = false;
  int countPost = 0;
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  bool following = false;

  @override
  void initState() {
    getAllPostForProfile();
    getAllFollowers();
    getAllFollowings();
    // call function when build is done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfAlreadyFollowing();
    });
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
//      QuerySnapshot querySnapshot = await DatabaseService()
//          .postCollection
//          .document(widget.user.uid)
//          .collection('userPost')
//          .orderBy('timeCreated', descending: true)
//          .getDocuments();
      if (mounted) {
        try {
          QuerySnapshot querySnapshot =
              await ProfileMethods().getUserPost(userUid: widget.user.uid);
          setState(() {
            loading = false;
//            countPost = querySnapshot.documents.length;
            postList = querySnapshot.documents
                .map((documentSnapshot) =>
                    PostWidgets.fromDocument(documentSnapshot))
                .toList();
          });
        } catch (e) {
          print(e);
          Fluttertoast.showToast(msg: e.messgae);
        }
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
    }
  }

  void getAllFollowers() async {
    countTotalFollowers = await ProfileMethods()
        .getUsersFollowersCount(userProfileUid: widget.user.uid);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getAllFollowings() async {
    countTotalFollowings = await ProfileMethods()
        .getUserFollowingsCount(userProfileUid: widget.user.uid);
    if (mounted) {
      setState(() {});
    }
  }

  void checkIfAlreadyFollowing() async {
    following = await ProfileMethods().checkIfFollowing(
        userProfileUid: widget.user.uid, currentUserUid: currentOnlineUserUid);
    if (mounted) {
      setState(() {});
    }
  }

  void followUser() {
    setState(() {
      following = true;
    });
    Timestamp timestamp = Timestamp.now();

    ProfileMethods().addCurrentLoggedInUserFromSearchUserFollowers(
        searchUserUid: widget.user.uid,
        currentLoggedInUserUid: currentOnlineUserUid);
    ProfileMethods().addSearchUserFromCurrentLoggedInUserFollowings(
        searchUserUid: widget.user.uid,
        currentLoggedInUserUid: currentOnlineUserUid);
    FeedMethods().addFeedItem(
        searchUserUid: widget.user.uid,
        currentLoggedInUserUid: currentOnlineUserUid,
        timestamp: timestamp);
    print('following');
  }

  Future<void> unFollowUser() async {
    setState(() {
      following = false;
    });

    ProfileMethods().deleteCurrentLoggedInUserFromSearchUserFollowers(
        searchUserUid: widget.user.uid,
        currentLoggedInUserUid: currentOnlineUserUid);

    ProfileMethods().deleteSearchUserFromCurrentLoggedInUserFollowings(
        searchUserUid: widget.user.uid,
        currentLoggedInUserUid: currentOnlineUserUid);

    FeedMethods().deleteFeedItem(
        searchUserUid: widget.user.uid,
        currentLoggedInUserUid: currentOnlineUserUid);
    print('unfollow');
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
              child: following == true
                  ? Text(
                      'Unfollow',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.white),
                    )
                  : Text(
                      'Follow',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: following == true ? Colors.grey : Colors.blue,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
            onPressed: () {
              if (following == true) {
                unFollowUser();
              } else {
                followUser();
              }
            },
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
            onPressed: () async {
              print(widget.user.fullName);
              print(widget.user.uid);
              print(currentOnlineUserUid);
              String chatDetails = await NewChatMethods().getUserChatDetails(
                  currentUserUid: currentOnlineUserUid,
                  receiverUid: widget.user.uid);
              print('details: $chatDetails');
              // onTap of message, navigate to chat screen with this user
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        chatDocId: chatDetails,
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
                              createColumn(
                                title: 'posts',
                                count: snapshot.data['postCount'],
                              ),
                              createColumn(
                                  title: 'followers',
                                  count: countTotalFollowers),
                              createColumn(
                                  title: 'following',
                                  count: countTotalFollowings),
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
    final user = Provider.of<User>(context);
    if (mounted) {
      setState(() {
        currentOnlineUserUid = user.uid;

        //call function after build is done
//        checkIfAlreadyFollowing();
      });
    }
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
