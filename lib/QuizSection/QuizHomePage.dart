import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/Others/About.dart';
import 'package:my_app_2_2/Others/selectQuizType.dart';
import 'package:my_app_2_2/Profile/ProfilePage.dart';
import 'package:my_app_2_2/constants/loadingWidget.dart';
import 'package:my_app_2_2/download/DownloadPage.dart';
import 'package:my_app_2_2/loginAndRegisteration/loginPage.dart';
import 'package:my_app_2_2/services/Auth.dart';
import 'package:my_app_2_2/services/admobmethods.dart';

const String testDevice = 'Mobile_id';

class QuizHomPage extends StatefulWidget {
  @override
  _QuizHomPageState createState() => _QuizHomPageState();
}

class _QuizHomPageState extends State<QuizHomPage> {
  final AuthService auth = AuthService();

  final String name = 'Olamilekan Yusuf';
  final String email = 'Olamilekanly66@gmail.com';

  final AdMobMethods adMobMethod = AdMobMethods();

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>[
      'Game',
    ],
  );

  BannerAd bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print('bannerAd: $event');
      },
    );
  }

  Widget startQuizButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 5.0,
      ),
      child: MaterialButton(
        height: 40.0,
        minWidth: double.infinity,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SelectQuizType()));
        },
        color: Colors.green[500],
        child: Text(
          'Select Quiz',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        splashColor: Colors.green[900],
      ),
    );
  }

  Widget homePageBody() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
//          child: AdmobBanner(
//            adUnitId: adMobMethod.getBannerAdId(),
//            adSize: AdmobBannerSize.FULL_BANNER,
//            listener: (AdmobAdEvent event, Map<String, dynamic> map) {
//              print('ads says:  $event');
//              print('ads says:  $map');
//            },
//          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'welcome Page',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  startQuizButton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void logOut() async {
    await auth.signOut();
    print('sign out');
  }

  @override
  void initState() {
    bannerAd = createBannerAd()..load();

    WidgetsFlutterBinding.ensureInitialized().addPersistentFrameCallback((_) {
      bannerAd..show();
//      Admob.initialize(adMobMethod.getAdMobAppId());
    });
//    super.initState();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              logOut();
            },
          )
        ],
      ),
      drawer: Container(
        child: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                accountName: Text('$name'),
                accountEmail: Text('$email'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    '${name[0]}'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                ),
                onDetailsPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OwnerProfilePage()));
                },
              ),
              ListTile(
                title: Text(
                  'close meun',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                trailing: Icon(
                  Icons.close,
                  size: 40.0,
                  color: Colors.black,
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              SizedBox(height: 50.0),
              Divider(),
              ListTile(
                title: Text('Register'),
                trailing: Icon(Icons.account_circle),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoadingWidget()),
                  );
                },
              ),
              ListTile(
                title: Text('Download Pages'),
                trailing: Icon(Icons.file_download),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DownloadPage()));
                },
              ),
              Divider(),
              ListTile(
                title: Text('Testing'),
                trailing: Icon(Icons.settings_applications),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/testingpage');
                },
              ),
              Divider(),
              ListTile(
                title: Text('About'),
                trailing: Icon(Icons.info),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ExploreTestPage()));
                },
              ),
              Divider(),
              ListTile(
                title: Text('login'),
                trailing: Icon(Icons.info),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
      body: Container(
        child: homePageBody(),
      ),
    );
  }
}
