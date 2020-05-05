import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageDatabaseService {
  final StorageReference storageReference =
      FirebaseStorage.instance.ref().child('PostsPictures');

  Future<String> uploadImageToFirebaseStorage(
      {File imageFile, String postId, String uid}) async {
    print('started uploading');
    StorageUploadTask storageUploadTask =
        storageReference.child(uid).child('post_$postId').putFile(imageFile);

    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}
