import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/Post/PostWidgets.dart';
import 'package:my_app_2_2/Profile/EditUserNamePage.dart';
import 'package:my_app_2_2/Profile/NewUpdateProfilePage.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';
import 'package:my_app_2_2/services/profileMethods.dart';
import 'package:provider/provider.dart';

class OwnerProfilePage extends StatefulWidget {
  @override
  _OwnerProfilePageState createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  bool loading = false;
  File imageSelected;
  var fullName;
  var photoUrl;
  String currentUserUid;
  int countPost = 0;
  List<PostWidgets> postList = [];
  bool isLoadingPic = false;
  int countTotalFollowings = 0;
  int countTotalFollowers = 0;

  @override
  void initState() {
//    getCurrentUser();

    // call function when build is done
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllPostForProfile();
      getAllFollowers();
      getAllFollowings();
    });
    super.initState();
  }

  void getAllFollowers() async {
    countTotalFollowers = await ProfileMethods()
        .getUsersFollowersCount(userProfileUid: currentUserUid);
    print('followers: $countTotalFollowers');
    setState(() {});
  }

  void getAllFollowings() async {
    countTotalFollowings = await ProfileMethods()
        .getUserFollowingsCount(userProfileUid: currentUserUid);
    print('followings: $countTotalFollowings');
    if (mounted) {
      setState(() {});
    }
  }

//  void getCurrentUser() async {
//    try {
//      await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
//        if (mounted) {
//          setState(() {
//            currentUserUid = user.uid;
//            print('one before');
//          });
//        }
//      });
//      print('two');
////      await AuthService().getLoggedInUserDetails().then((user) {
////        print('name: ${user.userName}');
////      });
////      print('end');
//
//    } catch (e) {
//      print(e.message);
//      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
//    }
//  }

  Future getImage({@required String photoUrl}) async {
    setState(() {
      isLoadingPic = true;
    });
    await ImagePicker.pickImage(source: ImageSource.gallery)
        .then((image) async {
      print(image.path);
      await ImageCropper.cropImage(
        sourcePath: image.path,
        maxWidth: 450,
        maxHeight: 450,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      ).then((imageCropped) {
        if (imageCropped != null) {
          imageSelected = imageCropped;
          print('image: $imageSelected');
          if (mounted) {
            setState(() {
              imageSelected = imageCropped;
              print('image: $imageSelected');
            });
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewUpdateProfile(
                    imageSelected: imageSelected,
                    photoUrl: photoUrl,
                  )));
          setState(() {
            isLoadingPic = false;
          });
        }
      });
    });
    setState(() {
      isLoadingPic = false;
    });
  }

  void getAllPostForProfile() async {
    try {
      if (mounted) {
        setState(() {
          loading = true;
        });
      }

//      QuerySnapshot querySnapshot = await DatabaseService().

//      QuerySnapshot querySnapshot = await DatabaseService()
//          .postCollection
//          .document(currentUserUid)
//          .collection('userPost')
//          .orderBy('timeCreated', descending: true)
//          .getDocuments();

      QuerySnapshot querySnapshot =
          await ProfileMethods().getUserPost(userUid: currentUserUid);

      if (mounted) {
        setState(() {
          loading = false;
//          countPost = querySnapshot.documents.length;
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

  void editProfile(String currentOnlineUserDisplayPic) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditProfilePage(
              currentOnlineUserDisplayPicUrl: currentOnlineUserDisplayPic,
            )));
  }

  Widget showDisplayPic({String displayPicUrl}) {
    if (displayPicUrl == null) {
      return Stack(
        children: <Widget>[
          Container(
            child: CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage('assets/profilePic_1.png'),
              backgroundColor: Colors.grey[300],
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 6.0,
            child: IconButton(
              onPressed: () {
                getImage(photoUrl: photoUrl);
              },
              iconSize: 30,
              tooltip: 'Update Profile Pic',
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.grey[300],
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Container(
            child: CircleAvatar(
              radius: 65,
              backgroundImage: CachedNetworkImageProvider(
                displayPicUrl.toString(),
                scale: 1,
              ),
              backgroundColor: Colors.grey[600],
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Container(
              child: IconButton(
                onPressed: () {
                  getImage(photoUrl: photoUrl);
                },
                iconSize: 30,
                tooltip: 'Update Profile Pic',
                icon: Icon(
                  Icons.add_a_photo,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      );
    }
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

  Widget editProfileButton({String currentOnlineUserDisplayPicUrl}) {
    return Container(
      padding: EdgeInsets.only(top: 3.0),
      child: FlatButton(
        child: Container(
          width: MediaQuery.of(context).size.width * .45,
          height: 26.0,
          child: Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        onPressed: () {
          editProfile(currentOnlineUserDisplayPicUrl);
        },
      ),
    );
  }

  Widget createProfileTopView(BuildContext buildContext) {
    return FutureBuilder(
      future:
          DatabaseService().publicUserCollection.document(currentUserUid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SafeArea(
              child:
                  Container(child: Center(child: CircularProgressIndicator())));
        } else {
          photoUrl = snapshot.data['displayPicUrl'].toString();
          print('url: $photoUrl');
          return Padding(
            padding: EdgeInsets.all(17.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    showDisplayPic(
                        displayPicUrl: snapshot.data['displayPicUrl']),
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
                              editProfileButton(
                                  currentOnlineUserDisplayPicUrl: snapshot
                                      .data['displayPicUrl']
                                      .toString()),
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
    print('uid: $currentUserUid');
    final user = Provider.of<User>(context);
    setState(() {
      currentUserUid = user.uid;
    });
    return isLoadingPic == true
        ? Container(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: SpinKitPouringHourglass(
                    size: 80,
                    color: Colors.teal,
                  ),
                ),
                Container(
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            body: Container(
              child: ListView(
                children: <Widget>[
                  currentUserUid == null
                      ? Container(
                          child: Center(
                            child: Text('Loading....'),
                          ),
                        )
                      : createProfileTopView(context),
                  Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  Container(child: displayPost()),
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

  cd() {
    return Column(
      children: <Widget>[
        Icon(
          Icons.refresh,
          size: 50,
        ),
        Text('Failed to load image, Tap to Reload'),
      ],
    );
  }
}

//Future<QuerySnapshot> fetchPosts({String userUid}) => DatabaseService()
//    .postCollection
//    .document(userUid)
//    .collection('userPost')
//    .orderBy('timeCreated', descending: true)
//    .getDocuments();
//
//Future getPostByUid({String postId}) async {
//  try {
//    DocumentSnapshot documentSnapshot = await DatabaseService()
//        .exploreCollection
//        .document('posts')
//        .collection('allPosts')
//        .document(postId)
//        .get();
//    return documentSnapshot;
//  } catch (e) {
//    Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
//    print(e.toString());
//  }
//}

//class PostList extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final user = Provider.of(context);
//    return Container(
//      child: FutureBuilder(
//        future: fetchPosts(userUid: user.uid),
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            var docLis = snapshot.data.documents;
//
//            if (docLis.isEmpty) {
//              return Container(child: Center(child: Text('empty')));
//            } else {
//              return Container(
//                child: ListView.builder(
//                  shrinkWrap: true,
//                  physics: NeverScrollableScrollPhysics(),
//                  padding: EdgeInsets.all(10),
//                  itemCount: docLis.length,
//                  itemBuilder: (context, index) {
//                    UserPostModel userPostDetails =
//                        UserPostModel.fromMap(docLis[index].data);
//                    return Container(
//                      width: double.infinity,
//                      child: PostView(userPost: userPostDetails),
//                    );
//                  },
//                ),
//              );
//            }
//          } else {
//            return Container();
//          }
//        },
//      ),
//    );
//  }
//}

//class PostView extends StatelessWidget {
//  final UserPostModel userPost;
//
//  PostView({@required this.userPost});
//
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder(
//      future: getPostByUid(postId: userPost.postId),
//      builder: (context, snapshot) {
//        if (snapshot.hasData) {
//          PostWidgets post = PostWidgets.fromDocument(snapshot.data);
////          PostWidgets userPostDetails = snapshot.data;
//
//          return Container(
//            width: double.infinity,
//            child: post,
//          );
//        } else {
//          return Center(
//            child: CircularProgressIndicator(),
//          );
//        }
//      },
//    );
//  }
//}
