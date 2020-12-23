import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String url;
  final int type;
  final DateTime chatTime;

  MessageTile(
      {@required this.message,
      @required this.sendByMe,
      this.url,
      this.type,
      this.chatTime});

  @override
  Widget build(BuildContext context) {
    return type != 1
        ? Container(
            padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: sendByMe ? 0 : 24,
                right: sendByMe ? 24 : 0),
            alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              crossAxisAlignment:
                  sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: sendByMe
                      ? EdgeInsets.only(left: 60)
                      : EdgeInsets.only(right: 60),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: sendByMe
                          ? BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                              bottomLeft: Radius.circular(18))
                          : BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                              bottomRight: Radius.circular(18)),
                      color: sendByMe
                          ? Color.fromRGBO(94, 130, 241, 1)
                          : Color.fromRGBO(240, 243, 241, 1)),
                  child: Text(message,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: sendByMe ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ),
                Align(
                  alignment:
                      sendByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Text(
                    DateFormat('MMMd').add_jm().format(chatTime).toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          )
        : url != null
            ? Padding(
                padding: EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: sendByMe ? 0 : 24,
                    right: sendByMe ? 24 : 0),
                child: Column(
                  crossAxisAlignment: sendByMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      alignment: sendByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: sendByMe
                            ? EdgeInsets.only(left: 90)
                            : EdgeInsets.only(right: 90),
                        padding: EdgeInsets.only(
                            top: 4, bottom: 4, left: 4, right: 4),
                        decoration: BoxDecoration(
                            borderRadius: sendByMe
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(23),
                                    topRight: Radius.circular(23),
                                    bottomLeft: Radius.circular(23))
                                : BorderRadius.only(
                                    topLeft: Radius.circular(23),
                                    topRight: Radius.circular(23),
                                    bottomRight: Radius.circular(23)),
                            gradient: LinearGradient(
                              colors: sendByMe
                                  ? [
                                      const Color(0xff007EF4),
                                      const Color(0xff2A75BC)
                                    ]
                                  : [
                                      const Color(0x1AFFFFFF),
                                      const Color(0x1AFFFFFF)
                                    ],
                            )),
                        child: Container(
                          child: CachedNetworkImage(
                            placeholderFadeInDuration: Duration(milliseconds: 1000),
                            imageUrl: url,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url)=>CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: sendByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Text(
                        DateFormat('MMMd').add_jm().format(chatTime).toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                "hii",
                style: TextStyle(color: Colors.white),
              );
  }
}
