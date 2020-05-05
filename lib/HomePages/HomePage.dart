import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Chat/chatHomePage.dart';
import 'package:my_app_2_2/Post/UploadNewPost.dart';
import 'package:my_app_2_2/Profile/ProfilePage.dart';
import 'package:my_app_2_2/QuizSection/QuizHomePage.dart';
import 'package:my_app_2_2/searchPageFolder/searchPage.dart';
import 'package:my_app_2_2/services/Auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService auth = AuthService();
  Color homeColorOnSelect;
  Color searchColorOnSelect;
  Color chatColorOnSelect;
  Color infoColorOnSelect;

  Widget widgetToDisplay;

  PageController pageController;
  int getPageIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    setState(() {
      widgetToDisplay = QuizHomPage();
      homeColorOnSelect = Colors.teal;
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<String> getUid() async {
    final FirebaseUser currentUser = await auth.getCurrentUser();
    final uid = currentUser.uid;
    print('uid: $uid');
    return uid;
  }

  void pageChanged(int pageIndex) {
    setState(() {
      getPageIndex = pageIndex;
    });
  }

  void onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 200), curve: Curves.bounceInOut);
  }

  Widget display() {
    return Container(
      child: widgetToDisplay,
    );
  }

  Scaffold homeMainScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          QuizHomPage(),
          SearchPage(),
          UploadNewPostPage(),
          ChatHomePage(),
          OwnerProfilePage(),
        ],
        controller: pageController,
        onPageChanged: pageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        activeColor: Colors.teal,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.add_photo_alternate)),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline)),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return homeMainScreen();
//    return Scaffold(
//      body: Container(
//        child: display(),
//      ),
//      bottomNavigationBar: BottomAppBar(
//        child: Container(
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.home),
//                onPressed: () {
//                  setState(() {
//                    widgetToDisplay = QuizHomPage();
//                    homeColorOnSelect = Colors.teal;
//                  });
//                },
//                color: homeColorOnSelect,
//              ),
//              IconButton(
//                icon: Icon(Icons.search),
//                onPressed: () {
//                  setState(() {
//                    widgetToDisplay = SearchPage();
//                    searchColorOnSelect = Colors.teal;
//                  });
//                },
//                color: searchColorOnSelect,
//              ),
//              IconButton(
//                icon: Icon(Icons.image),
//                onPressed: () {
//                  setState(() {
//                    widgetToDisplay = PostsPage();
//                    searchColorOnSelect = Colors.teal;
//                  });
//                },
//                color: searchColorOnSelect,
//              ),
//              IconButton(
//                icon: Icon(Icons.chat),
//                onPressed: () {
////                setState(() {
////                  widgetToDisplay = HomePage();
////                  homeColorOnSelect = Colors.teal;
////                });
//                },
//                color: chatColorOnSelect,
//              ),
//              IconButton(
//                icon: Icon(Icons.person),
//                onPressed: () {
//                  setState(() {
//                    widgetToDisplay = OwnerProfilePage();
//                    infoColorOnSelect = Colors.teal;
//                  });
//                },
//                color: infoColorOnSelect,
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
  }
}
