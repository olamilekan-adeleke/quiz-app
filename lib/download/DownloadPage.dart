import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:my_app_2_2/classes/QuestionDbNew.dart';
import 'package:my_app_2_2/download/offlineDownloadPage.dart';

class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with TickerProviderStateMixin {
  final String title = 'Download Page';
  TabController tb;
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  bool performOnlineActivity;
  bool toDisplayList;
  String downloadMessage;

//  DatabaseHelper databaseHelper = DatabaseHelper();
  final DbQuestionManager dbQuestionManager = DbQuestionManager();
  Question question;
  List<Question> questionList;
  String questionName;
  String questionFile;
  String numberOfOffLineQuestionsMessage = 'Loading...';
  int numberOfOffLineQuestions;

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        performOnlineActivity = true;
        toDisplayList = true;
        setState(() {});
      } else if (result == ConnectivityResult.none) {
        performOnlineActivity = false;
      }
    });
    getDownloadsFromFirebase();
    print(toDisplayList);
//    dbHelper = DBHelper();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future getDownloadsFromFirebase() async {
    if (performOnlineActivity == true) {
      var fireStore = Firestore.instance;
      QuerySnapshot querySnapshot =
          await fireStore.collection('Downloads').getDocuments();
      print(querySnapshot.documents);
      toDisplayList = true;
      return querySnapshot.documents;
    }
  }

  Future showMyToast(
      {String message, Color color, int timeInSec, Toast length}) {
    return Fluttertoast.showToast(
        msg: '$message', timeInSecForIos: timeInSec, toastLength: length);
  }

  void downloadQuestion() async {
    try {
      if (performOnlineActivity == true) {
        Response apiResponse =
            await get('https://olamilekan.pythonanywhere.com/edu211');

        showMyToast(message: 'Downloading Done');

        var unencodedFile = json.decode(apiResponse.body);
        questionName = jsonDecode(apiResponse.body)[4]['title'];
        questionFile = json.encode(unencodedFile);

        saveToDb(context);
      } else {
        showMyToast(
            message:
                'Unable To Connect To Serve \nCheck Your Internet And Try Again',
            timeInSec: 2,
            color: Colors.black);
      }
    } on SocketException catch (e) {
      print(e.toString());
      showMyToast(message: 'Invaild URL Given', length: Toast.LENGTH_SHORT);
    }
  }

  void downloadingPopup() {
    showMyToast(message: 'Downloading Started', timeInSec: 1);
    downloadQuestion();
//    testDownload();
  }

  void testDownload() {
    questionName = 'Edu211';
    questionFile = json.encode([
      {'1': 'one'},
      {'2': 'two'},
      {'3': 'three'}
    ]);
    saveToDb(context);
  }

  void saveToDb(BuildContext context) {
    Question q =
        Question(questionName: questionName, questionFile: questionFile);
    dbQuestionManager.insertQuestion(q);
    showMyToast(message: 'Question Saved Offline!');
  }

  // TODO: widget start here
  Widget onlinePage() {
    print(toDisplayList);
    if (toDisplayList == true) {
      return Container(
        child: FutureBuilder(
            future: getDownloadsFromFirebase(),
            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.data == null) {
                return Container(
                  child: Text('be sure your conneccted to the internet'),
                );
              } else {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
//                      child: Image()
                            ),
                        title: Text('${snapshot.data[index].data['Name']}'),
                        subtitle: Text('Tap On Icon To Downlaod'),
                        trailing: IconButton(
                          icon: Icon(Icons.file_download),
                          onPressed: () {
                            print(performOnlineActivity.toString());
                            downloadingPopup();
                          },
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                  );
                }
              }
            }),
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Text(
                'image palce holder',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                'You Are OffLine',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget showOfflineInfo() {
    return ListTile(
      leading: Icon(Icons.file_download),
      title: Text(
        'Downloads',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.check_circle_outline,
          color: Colors.blue,
        ),
        onPressed: testDownload,
      ),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => OfflineDownloadPage()));
      },
    );
  }

  Widget savedQuestionsPage() {
    return Container(
//      child: FutureBuilder(
//        future: question,
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            return ListView.builder(
//              itemBuilder: (context, index) {
//                return ListTile(
//                  leading: Text('${snapshot.data[index].id}'),
//                  title: Text('${snapshot.data[index].questionFile}'),
//                  trailing: IconButton(
//                    icon: Icon(Icons.delete),
//                    onPressed: () {
//                      printFile();
//                    },
//                  ),
//                );
//              },
//              itemCount: snapshot.data.length,
//            );
//          } else if (null == snapshot.data || snapshot.data.length == 0) {
//            return Center(
//              child: Text('No Data Found'),
//            );
//          }
//          return CircularProgressIndicator();
//        },
//      ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          showOfflineInfo(),
          Divider(thickness: 1),
          Expanded(
            child: Container(
              child: onlinePage(),
            ),
          ),
        ],
      ),
    );
  }
}
