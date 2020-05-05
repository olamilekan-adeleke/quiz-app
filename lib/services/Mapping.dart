import 'package:flutter/material.dart';
import 'package:my_app_2_2/HomePages/HomePage.dart';
import 'package:my_app_2_2/services/Authenticate.dart';
import 'package:provider/provider.dart';

class Mapping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of(context);
    print(user);

    if (user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}
