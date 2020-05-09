import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_app_2_2/Chat/chatHomePage.dart';
import 'package:my_app_2_2/Post/UploadNewPost.dart';
import 'package:my_app_2_2/Profile/ProfilePage.dart';
import 'package:my_app_2_2/QuizSection/QuizHomePage.dart';
import 'package:my_app_2_2/enum/userState.dart';
import 'package:my_app_2_2/provider/userProvider.dart';
import 'package:my_app_2_2/searchPageFolder/searchPage.dart';
import 'package:my_app_2_2/services/Auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final AuthService auth = AuthService();

  Widget widgetToDisplay;
  UserProvider userProvider;

  PageController pageController;
  int getPageIndex = 0;
  String currentUserUid;

  @override
  void initState() {
    getUid();
    pageController = PageController();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      String currentUserUid = await getUid();
      print(currentUserUid);
//      userProvider = Provider.of<UserProvider>(context, listen: false);
//      await UserProvider().getUser;

      auth.setUserState(
        userUid:
            currentUserUid, //'nrQG6SPgCKXQ5yMeqQRiMBv4SIg1', //userProvider.getUser,
        userState: UserState.Online,
      );
    });

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    String currentUserUid = await getUid();
//        (userProvider != null && userProvider.getUser != null
//            ? userProvider.getUser
//            : '');
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        currentUserUid != null
            ? auth.setUserState(
                userUid: currentUserUid, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserUid != null
            ? auth.setUserState(
                userUid: currentUserUid, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserUid != null
            ? auth.setUserState(
                userUid: currentUserUid, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserUid != null
            ? auth.setUserState(
                userUid: currentUserUid, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  Future<String> getUid() async {
    final FirebaseUser currentUser = await auth.getCurrentUser();
    final uid = currentUser.uid;
    setState(() {
      currentUserUid = uid;
    });
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
  }
}
