import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:my_app_2_2/enum/userState.dart';
import 'package:path_provider/path_provider.dart';

class ChatUtils {
  static Future<File> compressImage({@required File imageToCompress}) async {
    /// compress image picked/selected from device. Required[File imageToCompress]

//    print('compressedimagesize be4: ${imageToCompress.lengthSync()}');
//    File compressedImage = await FlutterImageCompress.compressAndGetFile(
//      imageToCompress.path,
//      imageToCompress.path,
//      quality: 85,
//    );
//    print('compressedimagesize after: ${imageToCompress.lengthSync()}');
//    return compressedImage;

    if (imageToCompress != null) {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;
      int randomNumber = Random().nextInt(10000);

      Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());

      File compressedImage = new File('$path/img_$randomNumber.jgp')
        ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

      return compressedImage;
    }
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    /// select image from device. Required[ImageSource source]
    File selectedImage = await ImagePicker.pickImage(
      source: source,
      imageQuality: 70,
    );
    return selectedImage;
  }

  static int stateToNumber({@required UserState userState}) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numbetToStae({@required int number}) {
    switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }
}
