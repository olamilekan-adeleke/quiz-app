import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  searchByName({String searchField}) async {
    print('1');
//    print(
//        '${Firestore.instance.collection('PublicUserData').where('searchKey', isEqualTo: searchField.substring(0, 1).toLowerCase()).getDocuments()}');

    return Firestore.instance
        .collection('PublicUserData')
        .where('searchkey',
            isEqualTo: searchField.substring(0, 1).toLowerCase())
        .getDocuments();
  }
}
