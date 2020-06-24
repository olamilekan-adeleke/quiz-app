//class ProfileMethods {
//  Future getImage({@required String photoUrl}) async {
////    setState(() {
////      isLoadingPic = true;
////    });
//    await ImagePicker.pickImage(source: ImageSource.gallery)
//        .then((image) async {
//      print(image.path);
//      await ImageCropper.cropImage(
//        sourcePath: image.path,
//        maxWidth: 450,
//        maxHeight: 450,
//        aspectRatioPresets: [CropAspectRatioPreset.square],
//      ).then((imageCropped) {
//        if (imageCropped != null) {
//          File imageSelected = imageCropped;
//          print('image: $imageSelected');
////          if (mounted) {
////            setState(() {
////              imageSelected = imageCropped;
////              print('image: $imageSelected');
////              isLoadingPic = false;
////            });
////          }
////          Navigator.of(context).push(MaterialPageRoute(
////              builder: (context) => NewUpdateProfile(
////                imageSelected: imageSelected,
////                photoUrl: photoUrl,
////              )));
////          setState(() {
////            isLoadingPic = false;
////          });
//        }
//      });
//    });
////    setState(() {
////      isLoadingPic = false;
////    });
//  }
//}
