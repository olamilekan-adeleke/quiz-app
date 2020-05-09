import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app_2_2/provider/imageUploadProvider.dart';
import 'package:my_app_2_2/services/Auth.dart';
import 'package:my_app_2_2/services/Mapping.dart';
import 'package:provider/provider.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(value: AuthService().user),
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
