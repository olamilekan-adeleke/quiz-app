import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print(Timestamp.now().microsecondsSinceEpoch),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal,
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 25,
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}
