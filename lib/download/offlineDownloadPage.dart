import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app_2_2/classes/QuestionDbNew.dart';

class OfflineDownloadPage extends StatefulWidget {
  @override
  _OfflineDownloadPageState createState() => _OfflineDownloadPageState();
}

class _OfflineDownloadPageState extends State<OfflineDownloadPage> {
  final DbQuestionManager dbQuestionManager = DbQuestionManager();
  Question question;
  List<Question> questionList;
  List<String> myList;

  void printType() {
    var data = json.decode(question.questionFile);
    print('type = ${data.runtimeType}');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved Questions',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: dbQuestionManager.getQuestionList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: Text(
                    'No Data Found!!',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              );
            } else {
              if (snapshot.hasData) {
                questionList = snapshot.data;
                print(questionList);

                if (questionList.length == 0) {
                  return Container(
                    child: Center(
                      child: Text(
                        'No Data Found!!',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, int) => Divider(thickness: 1),
                    itemCount:
                        questionList.length, //= null ? 0 : questionList.length,
                    itemBuilder: (context, index) {
                      Question question = questionList[index];
                      return ListTile(
                        onTap: () {
                        },
                        leading: Text('${index + 1}'),
                        title: Text('${question.questionName}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            dbQuestionManager.deleteQuestion(question.id);
                            setState(() {
                              questionList.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  );
                }
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Please Wait....',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
