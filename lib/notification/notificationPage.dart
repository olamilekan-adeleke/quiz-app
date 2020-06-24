import 'package:flutter/material.dart';
import 'package:my_app_2_2/services/notificationMethods.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: Container(
//        color: Colors.black,
        child: FutureBuilder(
          future: NotificationMethods()
              .retrieveNotifications(currentUserUid: user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView(children: snapshot.data);
            }
          },
        ),
      ),
    );
  }
}
