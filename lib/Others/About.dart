import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final String title = 'About';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(title),
      ),

      body: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}
