import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExploreTestPage extends StatefulWidget {
  @override
  _ExploreTestPageState createState() => _ExploreTestPageState();
}

class _ExploreTestPageState extends State<ExploreTestPage> {
  final CollectionReference testCollection =
      Firestore.instance.collection('tsetDb');

  Future savePostInfoToFireStore() async {
    print('saving');
    testCollection.document('one').collection('AllTest').document('A').setData({
      'timeCreated': Timestamp.now(),
      'likes': {},
      'userName': 'ola',
    });
    print('done');
  }

  Future savePostInfoToFireStore0() async {
    print('saving');
    testCollection.document('one').collection('AllTest').document('B').setData({
      'timeCreated': Timestamp.now(),
      'likes': {},
      'userName': 'ola',
    });
    print('done');
  }

  addMessgaToDb() async {
    print('sending started');
    var db = Firestore.instance;
    WriteBatch batch = db.batch();

    DocumentReference docRef0 =
        testCollection.document('one').collection('AllTest').document('A');
    DocumentReference docRef1 =
        testCollection.document('one').collection('AllTest').document('B');

    batch.setData(
      docRef0,
      {
        'timeCreated': Timestamp.now(),
        'likes': {},
        'userName': 'ola',
      },
    );
    batch.setData(
      docRef1,
      {
        'timeCreated': Timestamp.now(),
        'likes': {},
        'userName': 'ola',
      },
    );

    await batch.commit();
    print('sending done');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Text('this is a test page'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addMessgaToDb();
        },
      ),
    );
  }
}
