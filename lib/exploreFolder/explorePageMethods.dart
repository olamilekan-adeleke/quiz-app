import 'package:cloud_firestore/cloud_firestore.dart';

class ExplorePageMethods {
  final CollectionReference exploreCollectionRef =
      Firestore.instance.collection('explore');
}
