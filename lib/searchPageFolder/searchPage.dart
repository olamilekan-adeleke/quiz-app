import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Profile/ProfilePage.dart';
import 'package:my_app_2_2/Profile/otherProfilePage.dart';
import 'package:my_app_2_2/services/FirestoreDatabase.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var queryResultSet = [];
  var tempSearchStore = [];
  List<UserDataModel> searchList;
  var query = '';
  TextEditingController searchController = TextEditingController();
  bool isStillLoadingData = true;
  String currentUserUid;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
        if (mounted) {
          setState(() {
            currentUserUid = user.uid;
            print('uid: $currentUserUid');
            print('one before');
          });
        }
      });
      print('two');
    } catch (e) {
      print(e.message);
      Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
    }
  }

  void whenToStartSearch({String value}) {
    if (value.length == 1) {
      print('now');
      print('1: value');
      print('1' + isStillLoadingData.toString());
      setState(() {
        isStillLoadingData = true;
      });
      print('2' + isStillLoadingData.toString());
      print('hi');
      try {
        DatabaseService()
            .fetchSpecificUsers(keyWord: value)
            .then((List<UserDataModel> list) {
          setState(() {
            searchList = list;
            isStillLoadingData = false;
          });
        });
      } catch (e) {
        Fluttertoast.showToast(msg: e.message, toastLength: Toast.LENGTH_LONG);
        setState(() {
          isStillLoadingData = false;
        });
      }
    }
  }

  // Navigate to search user profile
  void navigateToProfilePage({@required UserDataModel searchUser}) {
    if (searchUser.uid == currentUserUid) {
      print('this is logged in user!');
      Fluttertoast.showToast(msg: 'this is logged in user!');
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => OwnerProfilePage()));
    } else {
      print('this is not logged in user!');
      Fluttertoast.showToast(msg: 'this is not logged in user!');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OtherUsersProfilePage(
            user: searchUser,
          ),
        ),
      );
    }
  }

  Widget customSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: searchController,
        onChanged: (val) {
          setState(() {
            query = val;
          });
          print(val);
          whenToStartSearch(value: val);
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(
              color: Colors.black,
              icon: Icon(Icons.close),
              iconSize: 20.0,
              onPressed: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => searchController.clear());
              },
            ),
            contentPadding: EdgeInsets.only(left: 25.0),
            hintText: 'Search by User Name',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),
      ),
    );
  }

  buildSuggestionList({String query}) {
    final List<UserDataModel> suggestionList = query.isEmpty
        ? []
        : searchList.where((UserDataModel user) {
            String getUserName = user.userName.toLowerCase();
            String _query = query.toLowerCase();
            String getName = user.fullName.toLowerCase();
            bool matchesUserName = getUserName.contains(_query);
            bool matchesName = getName.contains(_query);

            return (matchesUserName || matchesName);
          }).toList();
    print(suggestionList.length);

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        UserDataModel searchUser = UserDataModel(
          uid: suggestionList[index].uid,
          fullName: suggestionList[index].fullName,
          email: suggestionList[index].email,
          userName: suggestionList[index].userName,
          displayPicUrl: suggestionList[index].displayPicUrl,
        );

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: searchUser.displayPicUrl == null
                ? AssetImage('assets/profilePic_1.png')
                : CachedNetworkImageProvider(searchUser.displayPicUrl),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchUser.userName,
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          subtitle: Text(
            searchUser.fullName,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          onTap: () {
            print(searchUser.uid);
            navigateToProfilePage(searchUser: searchUser);
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(query);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            customSearchBar(),
            Expanded(
              child: isStillLoadingData == true
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: buildSuggestionList(query: query),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
