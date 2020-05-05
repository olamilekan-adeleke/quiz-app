import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileLoadingPage extends StatefulWidget {
  @override
  _ProfileLoadingPageState createState() => _ProfileLoadingPageState();
}

class _ProfileLoadingPageState extends State<ProfileLoadingPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SpinKitWave(
              color: Colors.white,
              itemCount: 10,
              size: 80,
            ),
            Text(
              'Loading....',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
