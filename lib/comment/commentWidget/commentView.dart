import 'package:carousel_pro/carousel_pro.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatWidgets/cachedImage.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Profile/ProfilePage.dart';
import 'package:my_app_2_2/Profile/otherProfilePage.dart';
import 'package:my_app_2_2/comment/commentpage.dart';
import 'package:my_app_2_2/services/Auth.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class CommentView extends StatelessWidget {
  final Comment comment;
  final String currentUserUid;

  CommentView({@required this.comment, @required this.currentUserUid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().getUserDetailByUid(uid: comment.userUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserDataModel commentOwnerDetails = snapshot.data;

          return CommentLayout(
            commentOwnerDetails: commentOwnerDetails,
            comment: comment,
            currentUserUid: currentUserUid,
          );
        } else {
          return Container(
            padding: EdgeInsets.all(5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class CommentLayout extends StatelessWidget {
  final UserDataModel commentOwnerDetails;
  final Comment comment;
  final String currentUserUid;

  CommentLayout({
    @required this.commentOwnerDetails,
    @required this.comment,
    @required this.currentUserUid,
  });

  // Navigate to  user profile page
  void navigateToProfilePage(context,
      {@required UserDataModel commentOwnerDetails}) {
    if (commentOwnerDetails.uid == currentUserUid) {
      print('this is logged in user!');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => OwnerProfilePage()));
    } else {
      print('this is not logged in user!');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => OtherUsersProfilePage(
                user: commentOwnerDetails,
              )));
    }
  }

  Widget textComment(context) {
    return ListTile(
      title: Text(
        commentOwnerDetails.userName,
        style: TextStyle(fontSize: 19),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          comment.comment,
          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
        ),
      ),
      leading: GestureDetector(
        onTap: () => navigateToProfilePage(context,
            commentOwnerDetails: commentOwnerDetails),
        child: Container(
          child: commentOwnerDetails.displayPicUrl == null
              ? CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/profilePic_1.png'),
                )
              : CachedImage(
                  commentOwnerDetails.displayPicUrl,
                  radius: 40,
                  isRound: true,
                ),
        ),
      ),
      trailing: Text(
        timeAgo.format(comment.timestamp.toDate()),
      ),
    );
  }

  Widget imageComment(context, {@required String commentImageUrl}) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              commentOwnerDetails.userName,
              style: TextStyle(fontSize: 19),
            ),
            leading: GestureDetector(
              onTap: () => navigateToProfilePage(context,
                  commentOwnerDetails: commentOwnerDetails),
              child: Container(
                child: commentOwnerDetails.displayPicUrl == null
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/profilePic_1.png'),
                      )
                    : CachedImage(
                        commentOwnerDetails.displayPicUrl,
                        radius: 40,
                        isRound: true,
                      ),
              ),
            ),
            trailing: Text(
              timeAgo.format(comment.timestamp.toDate()),
            ),
          ),
          Container(
            child: SizedBox(
              height: 360,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                onDoubleTap: () {
                  print('show full image');
                },
                child: ExtendedImage.network(
                  commentImageUrl,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .65,
                  fit: BoxFit.fill,
                  handleLoadingProgress: true,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  cache: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget multiImageComment(context, {@required List commentImageUrlList}) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              commentOwnerDetails.userName,
              style: TextStyle(fontSize: 19),
            ),
            leading: GestureDetector(
              onTap: () => navigateToProfilePage(context,
                  commentOwnerDetails: commentOwnerDetails),
              child: Container(
                child: commentOwnerDetails.displayPicUrl == null
                    ? CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/profilePic_1.png'),
                      )
                    : CachedImage(
                        commentOwnerDetails.displayPicUrl,
                        radius: 40,
                        isRound: true,
                      ),
              ),
            ),
            trailing: Text(
              timeAgo.format(comment.timestamp.toDate()),
            ),
          ),
          Container(
            child: SizedBox(
              height: 360,
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                  onDoubleTap: () {
                    print('show full image');
                  },
                  child: Carousel(
                    images: commentImageUrlList.map(
                      (images) {
                        return Container(
                          child: ExtendedImage.network(
                            images,
                            fit: BoxFit.fill,
                            handleLoadingProgress: true,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            cache: true,
                            enableMemoryCache: true,
                          ),
                        );
                      },
                    ).toList(),
                    autoplay: false,
                    indicatorBgPadding: 0.0,
                    dotPosition: DotPosition.bottomCenter,
                    dotSpacing: 15.0,
                    dotSize: 4,
                    dotIncreaseSize: 2.5,
                    dotIncreasedColor: Colors.teal,
                    dotBgColor: Colors.transparent,
                    dotColor: Colors.grey,
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: Duration(milliseconds: 2000),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget commentImage({
    @required BuildContext context,
    @required List commentImageUrl,
  }) {
    if (commentImageUrl.length < 2) {
      return imageComment(context, commentImageUrl: commentImageUrl[0]);
    } else {
      return multiImageComment(context, commentImageUrlList: commentImageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        comment.type == 'text'
            ? textComment(context)
            : commentImage(
                context: context, commentImageUrl: comment.commentImageUrl),
        Divider(),
      ],
    );
  }
}
