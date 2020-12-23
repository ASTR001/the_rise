import 'package:flutter/material.dart';
import 'package:the_rise/Chat/SingleChat/SingleChatScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final bool groupChat;
  final String url;

  ChatRoomsTile(
      {this.userName, @required this.chatRoomId, this.groupChat, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MyChatScreen(
            chatRoomId: chatRoomId,
            chatName: userName ?? '',
            groupChat: groupChat,
          );
        }));
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            children: [
              url != null
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: CachedNetworkImage(
                        fadeInCurve: Curves.easeIn,
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
                        placeholder: (context, url) {
                          // setState((){});
                          return Container();
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.fill,
                      ),
                    )
                  : Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                            userName != null ? userName.substring(0, 1) : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'OverpassRegular',
                                fontWeight: FontWeight.bold)),
                      )),
              SizedBox(
                width: 20,
              ),
              Text(userName ?? '',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300))
            ],
          ),
        ),
      ),
    );
  }
}
