import 'dart:async';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:my_app_2_2/Chat/chatUtils.dart';
import 'package:my_app_2_2/Chat/chatWidgets/ModalTile.dart';
import 'package:my_app_2_2/Chat/chatWidgets/cachedChatImage.dart';
import 'package:my_app_2_2/Models/UserDetailsModel.dart';
import 'package:my_app_2_2/Models/messageModel.dart';
import 'package:my_app_2_2/Models/user.dart';
import 'package:my_app_2_2/bloc/blocs/sendingImageBloc.dart';
import 'package:my_app_2_2/provider/imageUploadProvider.dart';
import 'package:my_app_2_2/services/newChatMethods.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserDataModel receiver;
  final String chatDocId;

  ChatScreen({@required this.receiver, @required this.chatDocId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Box<String> chatCheckBox;

  TextEditingController textEditingController = TextEditingController();
  String senderUid;
  String currentUserUid;
  ImageUploadProvider imageUploadProvider;

  static final Color senderColor = Color(0xff2b343b);
  static final Color receiverColor = Color(0xff1e2225);
  Radius messageRadius = Radius.circular(10);

  static final Color gradientColorStart = Colors.teal[300];
  static final Color gradientColorEnd = Colors.teal[500];
  static final Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  bool isWriting = false;

  Widget widgetToDisplay;
  String alternativeChatRef;

  List<Asset> imageList = List<Asset>();

  List<String> imageUrls = [];

  bool showImageStream = false;
  StorageUploadTask uploadTask;

  SendingImageBloc _sendingImageBloc;

  @override
  void initState() {
    showMessageList();
    chatCheckBox = Hive.box<String>('chatCheck');
    _sendingImageBloc = SendingImageBloc();
    super.initState();
  }

////

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: imageList.length,
      children: List.generate(imageList.length, (index) {
        Asset asset = imageList[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: imageList,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      imageList = resultList;
    });

    if (imageList.isNotEmpty && resultList.isNotEmpty) {
//      int randomId = Random().nextInt(999);
//
//      _sendingImageBloc.add(
//        SendingImageEvent.add(
//          sendingImage: SendingImageModel(imageType: 'multi'),
//          sendingImageId: randomId,
//        ),
//      );
      await postImage();
//      _sendingImageBloc.add(
//        SendingImageEvent.delete(randomId),
//      );
      print('done uploading');
    }
  }

  Future<dynamic> postImage() async {
    try {
      for (var i = 0; i < imageList.length; i++) {
        StorageReference reference = FirebaseStorage.instance
            .ref()
            .child('ChatImagePictures')
            .child(widget.receiver.uid)
            .child(senderUid)
            .child(Timestamp.now().toDate().toString());

        var image = (await imageList[i].getByteData()).buffer.asUint8List();

        StorageUploadTask uploadTask = reference.putData(image);

        final StreamSubscription<StorageTaskEvent> streamSubscription =
            uploadTask.events.listen((event) {
          // You can use this to notify yourself or your user in any kind of way.
          // For example: you could use the uploadTask.events stream in a StreamBuilder instead
          // to show your user what the current status is. In that case, you would not need to cancel any
          // subscription as StreamBuilder handles this automatically.

          // Here, every StorageTaskEvent concerning the upload is printed to the logs.
          print('EVENT ${event.type}');
          print(event.snapshot.bytesTransferred.toString() +
              ' / ' +
              event.snapshot.totalByteCount.toString());
        });

        StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
        streamSubscription.cancel();

        String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

        print(imageUrl);
        imageUrls.add(imageUrl);
      }

      Message message = Message.imageMessage(
        receiverUid: widget.receiver.uid,
        senderUid: senderUid,
        message: 'image',
        timestamp: Timestamp.now(),
        photoUrl: imageUrls,
        type: 'image',
        sent: true,
        read: false,
      );

      print(imageUrls.length);
      print('about to sent');
      NewChatMethods().uploadMultipleImage(
          message: message, imageUploadProvider: imageUploadProvider);
      print('sent doneeeeeeee');
      if (mounted) {
        setState(() {
          imageList = [];
          imageUrls = [];
        });
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Widget displayMultiPic({@required List imageList}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
        maxWidth: MediaQuery.of(context).size.width * .65,
      ),
      child: Carousel(
        images: imageList.map(
          (images) {
            return Container(
              child: ExtendedImage.network(
                images,
                fit: BoxFit.fill,
                handleLoadingProgress: true,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                cache: true,
                enableMemoryCache: true,
              ),
            );
          },
        ).toList(),
        autoplay: false,
        indicatorBgPadding: 0.0,
        dotPosition: DotPosition.bottomCenter,
        dotSpacing: 15.0,
        dotSize: 4,
        dotIncreaseSize: 2.5,
        dotIncreasedColor: Colors.teal,
        dotBgColor: Colors.transparent,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 2000),
      ),
    );
  }

//  Stream testStream() async* {
//    for (var i = 0; i <= 10; i++) {
//      await Future.delayed(Duration(seconds: 1));
//      yield i;
//    }
//
//    yield 'Done';
//  }

//  Widget isSendingImageStreamBox() {
//    print('got here');
//    return Container(
//      child: Container(
//        child: uploadTask != null
//            ? StreamBuilder<StorageTaskEvent>(
//                stream: uploadTask.events,
//                builder: (context, snapshot) {
//                  var event = snapshot?.data?.snapshot;
//
//                  double progressPercent = event != null
//                      ? event.bytesTransferred / event.totalByteCount
//                      : 0;
//
//                  if (snapshot.hasError) {
//                    return Center(
//                      child: Text('Error occur'),
//                    );
//                  }
////            else if (snapshot.hasData) {
////              setState(() {
////                showImageStream = true;
////              });
////            }
//                  else if (snapshot.connectionState ==
//                      ConnectionState.waiting) {
//                    return Container(
//                      decoration: BoxDecoration(
//                        color: Colors.teal,
//                        borderRadius: BorderRadius.circular(15),
//                      ),
//                      constraints: BoxConstraints(
//                        minWidth: 100,
//                        maxWidth: 150,
//                        minHeight: 100,
//                      ),
//                      child: Center(
//                        child: CircularProgressIndicator(
//                          backgroundColor: Colors.white,
//                        ),
//                      ),
//                    );
//                  } else if (snapshot.connectionState == ConnectionState.none) {
//                    return Container(
////                decoration: BoxDecoration(
////                  color: Colors.teal,
////                  borderRadius: BorderRadius.circular(15),
////                ),
////                constraints: BoxConstraints(
////                  minWidth: 100,
////                  maxWidth: 150,
////                  minHeight: 150,
////                ),
////                child: Center(
////                  child: Text('No Connection Found!!'),
////                ),
//                        );
//                  } else if (snapshot.connectionState == ConnectionState.done) {
//                    return Container(
//                      decoration: BoxDecoration(
//                        color: Colors.teal,
//                        borderRadius: BorderRadius.circular(15),
//                      ),
//                      constraints: BoxConstraints(
//                        minWidth: 100,
//                        maxWidth: 150,
//                        minHeight: 50,
//                      ),
//                      child: Center(
//                        child: Text('Stream Done!!'),
//                      ),
//                    );
//                  }
//                  return Container(
//                    decoration: BoxDecoration(
//                      color: Colors.teal,
//                      borderRadius: BorderRadius.circular(15),
//                    ),
//                    constraints: BoxConstraints(
//                      minWidth: 100,
//                      maxWidth: 150,
//                      minHeight: 150,
//                    ),
//                    child: Center(
//                      child: CircularProgressIndicator(
//                        value: progressPercent,
//                        backgroundColor: Colors.white,
//                      ),
//                    ),
//                  );
//                },
//              )
//            : Container(),
////            : Container(),
//      ),
//    );
//  }

////

  void sendMessage() {
    // get current text val
    var text = textEditingController.text.trim();

    // convert to message model
    Message message = Message(
      receiverUid: widget.receiver.uid,
      senderUid: senderUid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
      sent: true,
      read: false,
    );

    if (mounted) {
      setState(() {
        isWriting = false;
      });
    }
    alternativeChatRef = message.senderUid + message.receiverUid;
    widgetToDisplay = messageList();
    textEditingController.text = '';

    final key = message.timestamp.toString();
    final value = true;
    dowchatCheckBox.put('init', 'yes');
    chatCheckBox.put(key, value.toString()).then((_) => print('saved to box'));

    try {
      NewChatMethods().addMessageToDb(message: message).then((doc) {
        print('done');
        chatCheckBox
            .delete(message.timestamp.toString())
            .then((_) => print('remove from box'));
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }

    // add message to Db
    try {
//      ChatMethods().addMessageToDb(message: message).then((_) {
//        isSent = true;
//        ChatMethods().updateIsSent(message: message);
//      });
//          .timeout(Duration(seconds: 30));
    } catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }

  void getImageSelected({@required ImageSource source}) async {
    /// get/await image selected from device, required[image source]

    File selectedImage = await ChatUtils.pickImage(source: source);
    if (selectedImage != null) {
      print('uploading start');
      NewChatMethods().uploadImage(
        image: selectedImage,
        receiverUid: widget.receiver.uid,
        senderUId: currentUserUid,
        imageUploadProvider: imageUploadProvider,
      );
    }
  }

  void showMessageList() {
    if (widget.chatDocId != null) {
      if (mounted) {
        setState(() {
          widgetToDisplay = messageList();
        });
      }
    } else {
      if (mounted) {
        setState(() {
          widgetToDisplay = noChatBox();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // set image upload provider
    imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    // get user uid for user provider
    final user = Provider.of<User>(context);
    setState(() {
      senderUid = user.uid;
      currentUserUid = user.uid;
    });

    return BlocProvider<SendingImageBloc>(
      create: (context) => SendingImageBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: myAppBar(),
        body: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                child: widgetToDisplay,
              ),
            ),

//          imageUploadProvider.getViewState == ViewState.LOADING
//              ? isSendingImage()
//              : Container(),
            chatControlInputs(context),
          ],
        ),
      ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(widget.receiver.userName,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          )),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.more_horiz),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget isSendingImage() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.all(5),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 5),
            Text(
              'Sending Image, Please Wait',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageList() {
    String chatDocId =
        widget.chatDocId != null ? widget.chatDocId : alternativeChatRef;
    return StreamBuilder(
      stream: NewChatMethods().chatStream(docId: chatDocId),
//      stream: ChatMethods().chatStream(
//          currentUserUid: currentUserUid, receiverUid: widget.receiver.uid),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              padding: EdgeInsets.only(top: 10),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return chatMessageItem(
                    snapshot: snapshot.data.documents[index], index: index);
              },
            ),
          );
        }
      },
    );
  }

  Widget chatMessageItem({DocumentSnapshot snapshot, int index}) {
//    imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    Message message = Message.fromMap(snapshot.data);

    //
    if (message.senderUid != currentUserUid) {
      if (message.read == false) {
//        ChatMethods().updateIsRead(message: message);
      }
    }

    //

    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: Container(
        alignment: message.senderUid == currentUserUid
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: message.senderUid == currentUserUid
            ? GestureDetector(
                onTap: () {
                  print(index);
//                  print(_sendingImageBloc.);

//                  print(imageUploadProvider.getViewState);
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      senderMessageLayout(message: message, index: index),
                      getTimeFormat(timestamp: message.timestamp),
//                      index == 0 ? sendingImageBlocState() : Container(),
                    ],
                  ),
//                      : Column(
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>[
//                            senderMessageLayout(message: message, index: index),
//                            getTimeFormat(timestamp: message.timestamp),
//                            senderIsSendingImageLayout(),
//                          ],
//                        ),
                ),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    receiverMessageLayout(message),
                    getTimeFormat(timestamp: message.timestamp),
                  ],
                ),
              ), //senderMessageLayout(),
      ),
    );
  }

  Widget senderMessageLayout({Message message, int index}) {
    Radius messageRadius = Radius.circular(10);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        LimitedBox(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          child: Container(
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.only(
                topLeft: messageRadius,
                bottomLeft: messageRadius,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: getMessage(message: message),
                ),
                Container(
                  child: getIconIndicator(message: message),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

//  Widget testCountLoop(int times) {
//    if (times > 0) {
//      return Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          for (var i = 1; i <= times; i++)
//            Container(
//              padding: EdgeInsets.all(10),
//              child: Center(
//                child: CircularProgressIndicator(),
//              ),
//            ),
//        ],
//      );
//    } else {
//      return Container();
//    }
//  }

//  Widget sendingImageBlocState() {
//    return BlocConsumer<SendingImageBloc, List<SendingImageModel>>(
//      builder: (context, sendingImageList) {
//        if (sendingImageList.isEmpty) {
//          return Container();
//        } else {
//          return Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              for (var i = 1; i <= sendingImageList.length; i++)
//                Container(
//                  padding: EdgeInsets.all(10),
//                  child: Center(
//                    child: CircularProgressIndicator(),
//                  ),
//                ),
//            ],
//          );
//        }
//      },
//      listener: (BuildContext context, List state) {
//        return Container(
//          child: Text('loadin...........'),
//        );
//      },
//      buildWhen:
//          (List<SendingImageModel> previous, List<SendingImageModel> current) {
//        return true;
//      },
//      listenWhen:
//          (List<SendingImageModel> previous, List<SendingImageModel> current) {
//        return true;
//      },
//    );
//  }

//  Widget senderIsSendingImageLayout() {
//    Radius messageRadius = Radius.circular(10);
//
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.end,
//      children: <Widget>[
//        LimitedBox(
//          maxWidth: MediaQuery.of(context).size.width * 0.85,
//          child: Container(
//            margin: EdgeInsets.only(top: 12),
//            decoration: BoxDecoration(
//              color: Colors.teal[300],
//              borderRadius: BorderRadius.only(
//                topLeft: messageRadius,
//                topRight: messageRadius,
//                bottomLeft: messageRadius,
//              ),
//            ),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.end,
//              children: <Widget>[
//                Container(
//                  padding: EdgeInsets.only(top: 0, left: 10, right: 5),
////                  child: getMessage(message: message),
//                  child: Container(
//                    child: Center(child: CircularProgressIndicator()),
//                  ),
//                ),
//                Container(
////                  child: getIconIndicator(message: message),
//                    ),
//              ],
//            ),
//          ),
//        ),
//      ],
//    );
//  }

  Widget receiverMessageLayout(Message message) {
    Radius messageRadius = Radius.circular(10);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        LimitedBox(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.teal[400],
              borderRadius: BorderRadius.only(
                bottomRight: messageRadius,
                topRight: messageRadius,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(top: 0, left: 5, right: 10, bottom: 3),
                  child: getMessage(message: message),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getMessage({@required Message message}) {
    if (message.type == 'text') {
      return Padding(
        padding: EdgeInsets.fromLTRB(3, 3, 3, 2),
        child: Text(
          message.message,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
        ),
      );
    } else if (message.type == 'image') {
      return Container(
        constraints: BoxConstraints(
          minHeight: 350,
          minWidth: 100,
        ),
        child: message.photoUrl.length < 2
            ? LimitedBox(
                child: CachedChatImage(imageUrl: message.photoUrl[0]),
              )
            : displayMultiPic(imageList: message.photoUrl),
      );
    }
  }

  Widget getTimeFormat({@required Timestamp timestamp}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1, top: 2),
      child: Text(
//        DateFormat("MMM d, EEE HH:mm").format(timestamp.toDate()),
        DateFormat("MMM d, HH:mm").format(timestamp.toDate()),
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget getIconIndicator({@required Message message}) {
    return WatchBoxBuilder(
      box: chatCheckBox,
      watchKeys: [
        message.timestamp.toString(),
      ],
      builder: (context, box) {
        if (box.get(message.timestamp.toString()) == null) {
          return Icon(
            Icons.check,
            color: Colors.grey[600],
            size: 20,
            semanticLabel: 'Message has been Sent!',
          );
        } else {
          return Icon(
            Icons.access_time,
            color: Colors.grey[600],
            size: 20,
            semanticLabel: 'Message Was Not Sent!',
          );
        }
      },
    );
  }

  Widget chatControlInputs(context) {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
//          Container(
//            margin: EdgeInsets.all(2),
//            decoration: BoxDecoration(
//              gradient: fabGradient,
//              shape: BoxShape.circle,
//            ),
//            child: IconButton(
//              icon: Icon(Icons.attach_file),
//              onPressed: () {
//                showCustomBottomSheet(context);
//              },
//            ),
//          ),
          Expanded(
            child: LimitedBox(
              maxHeight: 70,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                controller: textEditingController,
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (val) {
                  (val.length > 0 && val.trim() != '')
                      ? setWritingTo(true)
                      : setWritingTo(false);
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {
                      showCustomBottomSheet(context);
                    },
                  ),
                  hintText: 'Type a Message...',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  filled: true,
                  fillColor: Colors.teal[300],
                ),
              ),
            ),
          ),
          isWriting
              ? Container()
              : Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[800],
                    ),
                    onPressed: () {
                      getImageSelected(source: ImageSource.camera);
                    },
                  ),
                ),
          isWriting
              ? Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.teal[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.grey[800],
                      ),
                      onPressed: () {
                        print('about to sent');
                        sendMessage();
                      },
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void showCustomBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Colors.black,
        builder: (context) {
          return Column(
            //
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ModalTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        getImageSelected(source: ImageSource.camera);
                      },
                      title: "Camera",
                      subtitle: "Share Photos From Device Camera",
                      icon: Icons.photo_camera,
                    ),
                    ModalTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        getImageSelected(source: ImageSource.gallery);
                      },
                      title: "Media",
                      subtitle: "Share Photos From Gallery",
                      icon: Icons.image,
                    ),
                    ModalTile(
                      onTap: () {
                        Navigator.of(context).pop();
//                        getImageSelected(source: ImageSource.gallery);
                        loadAssets();
                      },
                      title: "Multiple Media",
                      subtitle: "Share Multiple Photos From Gallery/Camera",
                      icon: Icons.photo_library,
                    ),
                    ModalTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        print('go to file');
                      },
                      title: "File",
                      subtitle: "Share files",
                      icon: Icons.tab,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  noChatBox() {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.person,
              size: 120,
              color: Colors.grey,
            ),
            Text(
              'Start A New Conversation With ${widget.receiver.userName}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
