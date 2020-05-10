import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedChatImage extends StatefulWidget {
  final String imageUrl;

  CachedChatImage({@required this.imageUrl});

  @override
  _CachedChatImageState createState() => _CachedChatImageState();
}

class _CachedChatImageState extends State<CachedChatImage> {
  Radius messageRadius = Radius.circular(10);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4, 4, 4, 2),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomRight: messageRadius,
          bottomLeft: messageRadius,
        ),
        child: SizedBox(
          height: 350,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            placeholder: (context, url) => Container(
              width: 50,
              height: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => IconButton(
              icon: Icon(
                Icons.refresh,
              ),
              onPressed: () {
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
