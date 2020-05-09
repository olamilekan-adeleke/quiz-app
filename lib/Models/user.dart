class User {
  String uid;

  User({this.uid});

  User.fromMap(Map<dynamic, dynamic> mapData) {
    this.uid = mapData['uid'];
  }

}
