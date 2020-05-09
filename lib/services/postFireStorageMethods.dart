import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageDatabaseService {
  final StorageReference postStorageReference =
      FirebaseStorage.instance.ref().child('PostsPictures');

  Future<String> uploadImageToFirebaseStorage(
      {File imageFile, String postId, String uid}) async {
    /// upload post image to storage and return url. required[File imageFile, String postId, String uid]

    print('started uploading');
    StorageUploadTask storageUploadTask =
    postStorageReference.child(uid).child('post_$postId').putFile(imageFile);

    StorageTaskSnapshot storageTaskSnapshot =
        await storageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}
