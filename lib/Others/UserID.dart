import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class UserID extends StatefulWidget {
  @override
  _UserIDState createState() => _UserIDState();
}

class _UserIDState extends State<UserID> {
  String name = 'olamilekan';
  String faculty = 'education';
  String department = 'science edcation';
  String hobby = 'proggraming';
  int level = 100;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          'User ID',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 40.0,
              ),
            ),
            Divider(
              height: 60,
              color: Colors.grey[400],
            ),
            Text(
              'name:'.toUpperCase(),
              style: TextStyle(
                fontSize: 15.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 5.0,),
            Text(
              '$name'.toUpperCase(),
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.0),

            Text(
              'level:'.toUpperCase(),
              style: TextStyle(
                fontSize: 15.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              '$level'.toUpperCase(),
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.0),

            Text(
              'faculty:'.toUpperCase(),
              style: TextStyle(
                fontSize: 15.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              '$faculty'.toUpperCase(),
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.0),

            Text(
              'department:'.toUpperCase(),
              style: TextStyle(
                fontSize: 15.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              '$department'.toUpperCase(),
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15.0),

            Text(
              'hobby:'.toUpperCase(),
              style: TextStyle(
                fontSize: 15.0,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              '$hobby'.toUpperCase(),
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                letterSpacing: 1.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15.0),

            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                SizedBox(width: 10.0),
                Text(
                  'olamilekanly66@gmail.com',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 5.0),
                Text(
                  '08161261162',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
