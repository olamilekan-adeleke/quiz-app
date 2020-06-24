import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/comment/commentWidget/commentQuietBox.dart';
import 'package:my_app_2_2/comment/commentWidget/commentView.dart';
import 'package:my_app_2_2/services/Auth.dart';
import 'package:my_app_2_2/services/postMethods.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class CommentPage extends StatefulWidget {
  final String postUid;
  final String ownerUid;
  final String imageUrl;
  final dynamic displayPicUrl;
  final String userName;
  final Timestamp timestamp;
  final int likeCount;
  final int commentCount;

  CommentPage({
    @required this.imageUrl,
    @required this.ownerUid,
    @required this.postUid,
    @required this.displayPicUrl,
    @required this.userName,
    @required this.timestamp,
    @required this.likeCount,
    @required this.commentCount,
  });

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentTextEditingController = TextEditingController();
  String currentUserUid;
  String text = '';
  List<Asset> imageList = [];
  List imageUrls = [];

//  String _error = '';

  @override
  void initState() {
    print('llllllllllllllllllllllllllllllll');
    print(widget.likeCount);
    super.initState();
  }

  void saveComment() {
    Timestamp timestamp = Timestamp.now();
    String comment = commentTextEditingController.text;

    PostMethods()
        .saveCommentToDatabase(
      postUid: widget.postUid,
      comment: comment,
      timestamp: timestamp,
    )
        .then((_) {
//      bool isNotPostOwner = widget.postUid != currentUserUid;
//      if (isNotPostOwner) {
//        FeedMethods().addCommentToFeed(
//          ownerUid: widget.ownerUid,
//          timestamp: timestamp,
//          postUid: widget.postUid,
//          postImageUrl: widget.imageUrl,
//          comment: comment,
//        );
//      }
    });
    commentTextEditingController.clear();
    if (mounted) {
      setState(() {
        text = '';
      });
    }
    Fluttertoast.showToast(msg: 'Comment Sucessfull');
  }

  selectImage(functionContext) {
    return showDialog(
        context: functionContext,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            title: Text(
              'New Post',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Capture Image With Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  'Select Image From Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  'Select Multiple Images From Gallery/Camera',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: getManyImage,
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Future captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
      imageQuality: 80,
    );
    await uploadImage(image: imageFile);
  }

  Future pickImageFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (imageFile != null) {
      Fluttertoast.showToast(msg: 'Uploading...');
      await uploadImage(image: imageFile);
      Fluttertoast.showToast(msg: 'Done');
    }
  }

  Future<String> uploadImageToStorage({@required File image}) async {
    /// upload image to storage and return url. required[File image]

    final StorageReference commentStorageReference =
        FirebaseStorage.instance.ref().child('commentPictures');

    try {
      print('uploading....');
      StorageUploadTask uploadTask = commentStorageReference
          .child(Timestamp.now().toDate().toString())
          .putFile(image);

      // get image url
      String imageUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();

      //return url
      print('got url');
      return imageUrl;
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: e.message);
      return null;
    }
  }

  Future<void> uploadImage({
    @required File image,
  }) async {
    final CollectionReference commentCollectionRef =
        Firestore.instance.collection('comments');
    Timestamp timestamp = Timestamp.now();
//    String comment = commentTextEditingController.text;

    String imageUrl = await uploadImageToStorage(image: image);

    try {
      if (imageUrl != null) {
        print('saving detail to db');
        // convert image message to map/json format
        UserDataModel user = await AuthService().getLoggedInUserDetails();

        commentCollectionRef
            .document(widget.postUid)
            .collection('comments')
            .add({
          'userName': user.userName,
          'timestamp': timestamp,
          'imageUrl': user.displayPicUrl,
          'userUid': user.uid,
          'type': 'image',
          'commentImageUrl': [imageUrl],
        });
        commentTextEditingController.clear();
        if (mounted) {
          setState(() {
            text = '';
          });
        }
      }
      print('done');
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> getManyImage() async {
    Navigator.pop(context);
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: imageList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      imageList = resultList;
//      _error = error;
    });

    if (imageList.isNotEmpty && resultList.isNotEmpty) {
      await uploadMultipleImages();
      print('done uploading');
    }
  }

  Future<dynamic> uploadMultipleImages() async {
//    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final StorageReference commentStorageReference =
        FirebaseStorage.instance.ref().child('commentPictures');

    final CollectionReference commentCollectionRef =
        Firestore.instance.collection('comments');

    Timestamp timestamp = Timestamp.now();

//    String comment = commentTextEditingController.text;

    try {
      for (var i = 0; i < imageList.length; i++) {
        StorageReference reference =
            commentStorageReference.child(Timestamp.now().toDate().toString());

        var image = (await imageList[i].getByteData()).buffer.asUint8List();

        StorageUploadTask uploadTask = reference.putData(image);

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          // You can use this to notify yourself or your user in any kind of way.
          // For example: you could use the uploadTask.events stream in a StreamBuilder instead
          // to show your user what the current status is. In that case, you would not need to cancel any
          // subscription as StreamBuilder handles this automatically.

          // Here, every StorageTaskEvent concerning the upload is printed to the logs.
          print('EVENT ${event.type}');
          print(event.snapshot.bytesTransferred.toString() +
              ' / ' +
              event.snapshot.totalByteCount.toString());
        });

        StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
        streamSubscription.cancel();

        String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

        print(imageUrl);
        imageUrls.add(imageUrl);
      }

      print(imageUrls.length);
      print('about to sent');

      UserDataModel user = await AuthService().getLoggedInUserDetails();

      commentCollectionRef.document(widget.postUid).collection('comments').add({
        'userName': user.userName,
        'timestamp': timestamp,
        'imageUrl': user.displayPicUrl,
        'userUid': user.uid,
        'type': 'image',
        'commentImageUrl': imageUrls,
      });
      commentTextEditingController.clear();

      print('sent doneeeeeeee');
      if (mounted) {
        setState(() {
          imageList = [];
          imageUrls = [];
          text = '';
        });
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Widget realTimeCommentStream() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: PostMethods().getCommentStream(postUid: widget.postUid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var commentList = snapshot.data.documents;
            if (commentList.isEmpty) {
              return CommentQuietBox();
            } else {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                itemCount: commentList.length,
                itemBuilder: (context, index) {
                  Comment comment = Comment.fromDocument(commentList[index]);
                  return CommentView(
                      comment: comment, currentUserUid: currentUserUid);
                },
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget displayComments() {
    return StreamBuilder(
      stream: PostMethods().getCommentStream(postUid: widget.postUid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          List<Comment> comment = [];
          snapshot.data.documents.forEach((doc) {
            comment.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: comment,
          );
        }
      },
    );
  }

  Widget inputLayout() {
    return Container(
      padding: EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: ListTile(
        title: Container(
          constraints: BoxConstraints(maxHeight: 100),
          child: TextFormField(
            controller: commentTextEditingController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: 'Write comment here..',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (val) {
              if (mounted) {
                setState(() {
                  text = val;
                });
              }
            },
          ),
        ),
        trailing: text.trim().length != 0 || text.trim().length != 0
            ? IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                onPressed: () {
                  saveComment();
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.attach_file,
                  color: Colors.blue,
                ),
                onPressed: () {
                  selectImage(context);
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    setState(() {
      currentUserUid = user.uid;
    });

    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: ListView(
                  children: <Widget>[
                    post(
                      displayPicUrl: widget.displayPicUrl,
                      userName: widget.userName,
                      timestamp: widget.timestamp,
                      postImageUrl: widget.imageUrl,
                      likeCount: widget.likeCount.toString(),
                      commentCount: widget.commentCount,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Container(
                        child: realTimeCommentStream(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: inputLayout(),
          )
        ],
      ),
    );
  }

  Widget post({
    @required dynamic displayPicUrl,
    @required String userName,
    @required Timestamp timestamp,
    @required String postImageUrl,
    @required String likeCount,
    @required int commentCount,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: double.infinity,
//        height: 560.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        backgroundImage: displayPicUrl != null
                            ? CachedNetworkImageProvider(displayPicUrl)
                            : AssetImage('assets/profilePic_1.png'),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    title: Text(
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(timeAgo.format(timestamp.toDate())),
                    trailing: IconButton(
                      icon: Icon(Icons.more_horiz),
                      color: Colors.black,
                      onPressed: () => print('More'),
                    ),
                  ),
                  InkWell(
                    onDoubleTap: () => print('Like post'),
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: 380.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: ExtendedImage.network(
                        widget.imageUrl,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .65,
                        fit: BoxFit.fill,
                        handleLoadingProgress: true,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        cache: false,
                      ),
                    ),
                  ),
//                  Padding(
//                    padding: EdgeInsets.symmetric(horizontal: 20.0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Row(
//                          children: <Widget>[
//                            Row(
//                              children: <Widget>[
//                                IconButton(
//                                  icon: Icon(Icons.favorite_border),
//                                  iconSize: 30.0,
//                                  onPressed: () => print('Like post'),
//                                ),
//                                Text(
//                                  '$likeCount',
//                                  style: TextStyle(
//                                    fontSize: 14.0,
//                                    fontWeight: FontWeight.w600,
//                                  ),
//                                ),
//                              ],
//                            ),
//                            SizedBox(width: 20.0),
//                            Row(
//                              children: <Widget>[
//                                IconButton(
//                                  icon: Icon(Icons.chat),
//                                  iconSize: 30.0,
//                                  onPressed: () {},
//                                ),
//                                Text(
//                                  '$commentCount',
//                                  style: TextStyle(
//                                    fontSize: 14.0,
//                                    fontWeight: FontWeight.w600,
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ],
//                        ),
//                        IconButton(
//                          icon: Icon(Icons.bookmark_border),
//                          iconSize: 30.0,
//                          onPressed: () => print('Save post'),
//                        ),
//                      ],
//                    ),
//                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String userName;
  final String userUid;
  final String imageUrl;
  final String comment;
  final String type;
  final List commentImageUrl;
  final Timestamp timestamp;

  Comment({
    this.userName,
    this.userUid,
    this.imageUrl,
    this.comment,
    this.timestamp,
    this.type,
    this.commentImageUrl,
  });

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot) {
    return Comment(
      userName: documentSnapshot['userName'],
      userUid: documentSnapshot['userUid'],
      imageUrl: documentSnapshot['imageUrl'],
      comment: documentSnapshot['comment'],
      type: documentSnapshot['type'],
      commentImageUrl: documentSnapshot['commentImageUrl'],
      timestamp: documentSnapshot['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.only(bottom: 6.0),
//      child: Container(
//        child: Column(
//          children: <Widget>[
//            ListTile(
//              title: Text(
//                userName + ': ' + comment,
//                style: TextStyle(
//                  fontSize: 18.0,
//                ),
//              ),
//              leading: CachedImage(
//                imageUrl,
//                isRound: true,
//                radius: 30,
//              ),
//              subtitle: Text(
//                timeAgo.format(timestamp.toDate()),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
  }
}
