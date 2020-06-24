import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/bloc/blocs/sendingImageBlocDelegate.dart';
import 'package:my_app_2_2/provider/imageUploadProvider.dart';
import 'package:my_app_2_2/services/Auth.dart';
import 'package:my_app_2_2/services/Mapping.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // to run bloc delegate
  BlocSupervisor.delegate = SendingImageBlocDelegate();

  // init hive
  WidgetsFlutterBinding.ensureInitialized();
  InitHive().startHive(boxName: 'chatCheck');

  //run app
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthService().user),
        ChangeNotifierProvider<ImageUploadProvider>(
          create: (context) => ImageUploadProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        debugShowCheckedModeBanner: false,
//      initialRoute: (context) => SplashScreen,
        home: Mapping(),
//      routes: {
//        '/': (context) => SplashScreen(),
//        '/loading': (context) => LoadingPage(),
//        '/homepage': (context) => HomePage(),
//        '/useridpage': (context) => UserID(),
//        '/settingpage': (context) => Setting(),
//        '/downloadpage': (context) => DownloadPage(),
//        '/quizpage': (context) => GetCbtJson(),
//        '/aboutpage': (context) => About(),
//        '/registerpage': (context) => MyHomePage(),
//        '/quizselectionpage': (context) => CbtQuizSelectionPage(),
//        '/germanpage': (context) => GermanQuestionPage(),
//        '/testingpage': (context) => DBTestPage(),
//        '/loginpage': (context) => LoginPage(),
//      },
      ),
    );
  }
}

class InitHive {
  void startHive({@required String boxName}) async {
    Directory documentDir = await getApplicationSupportDirectory();
    Hive.init(documentDir.path);
    await Hive.openBox<String>(boxName);
  }
}
