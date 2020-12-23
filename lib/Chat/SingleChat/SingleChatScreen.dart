import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_rise/Chat/GroupChat/GroupChatScreen.dart';
import 'package:the_rise/Chat/GroupChat/GroupInfo.dart';
import 'package:the_rise/Const/ConstCurrentUser.dart';

import '../ChatDatabase.dart';
import '../MessageTile.dart';

class MyChatScreen extends StatefulWidget {
  final String chatRoomId, chatName;
  final bool groupChat;

  const MyChatScreen({Key key, this.chatRoomId, this.chatName, this.groupChat})
      : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyChatScreen> with WidgetsBindingObserver {
  var _storageReference;
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  FocusNode textField = FocusNode();
  ScrollController _controllerChatList = ScrollController();
  File _image;
  final picker = ImagePicker();
  QuerySnapshot chatRooms;
  String picUrl;
  String groupName = '';
  List tokenList;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    MyChatDatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    getUserInfoGetChats();
    Timer(
        Duration(milliseconds: 300),
        () => _controllerChatList
            .jumpTo(_controllerChatList.position.maxScrollExtent));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    state = state;
    switch (state) {
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
        getUserInfoGetChats();
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  getUserInfoGetChats() async {
    MyChatDatabaseMethods().getGroupInfo(widget.chatRoomId).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print("we got the data + ${chatRooms.toString()} ");
      });
      if (chatRooms != null) {
        var userList1 = chatRooms.docs.map((e) => e.data()).toList();

        setState(() {
          picUrl = userList1[0]["groupPhotoUrl"] as String;
          groupName = userList1[0]["groupName"];
        });
        List tokenList1 = userList1[0]["userToken"];
        tokenList = tokenList1
            .where((i) => i["userName"] != ConstCurrentUser.myName)
            .toList();
        print("object");
      }
    });
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        var chatMessages = [];
        if (snapshot.hasData) {
          chatMessages = snapshot.data.docs.map((e) => e.data()).toList();
          Timer(
              Duration(milliseconds: 0),
              () => _controllerChatList
                  .jumpTo(_controllerChatList.position.maxScrollExtent));
        }
        return snapshot.hasData
            ? Container(
                height: MediaQuery.of(context).size.height * 0.74,
                child: ListView.builder(
                    controller: _controllerChatList,
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      DateTime date = new DateTime.fromMillisecondsSinceEpoch(
                          chatMessages[index]["time"]);
                      return widget.groupChat
                          ? MyGroupChatTile(
                              message: chatMessages[index]["message"],
                              sendByMe: ConstCurrentUser.myName ==
                                  chatMessages[index]["sendBy"],
                              url: chatMessages[index]["photoUrl"],
                              type: chatMessages[index]["type"],
                              chatTime: date,
                              sendName: chatMessages[index]["sendByName"],
                            )
                          : MessageTile(
                              message: chatMessages[index]["message"],
                              sendByMe: ConstCurrentUser.myName ==
                                  chatMessages[index]["sendBy"],
                              url: chatMessages[index]["photoUrl"],
                              type: chatMessages[index]["type"],
                              chatTime: date,
                            );
                    }),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.76,
              );
      },
    );
  }

  void addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": ConstCurrentUser.myName,
        "sendByName":  ConstCurrentUser.myUserName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        "photoUrl": '',
        "type": 0
      };

      MyChatDatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      sendAndRetrieveMessage(messageEditingController.text);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  bool isLoadingImage = false;
  Future getImage() async {
    final pickedFile = await picker.getImage(
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 80,
        source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
      isLoadingImage = true;
    });
    if (_image != null) {
      compressImage(_image);
    }
  }

  compressImage(File imageToCompress) async {
    String url = await uploadImageToStorage(imageToCompress);
  }

  uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    final storageUploadTask = await _storageReference.putFile(imageFile);
    String url = await _storageReference.getDownloadURL();
    print(url);
    addPhotoMessage(url);
  }

  addPhotoMessage(String url) {
    if (url.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": ConstCurrentUser.myName,
        "message": 'Imgae',
        'time': DateTime.now().millisecondsSinceEpoch,
        "photoUrl": url,
        "type": 1
      };
      MyChatDatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        isLoadingImage = false;
      });
    }
  }

  final String serverToken =
      'AAAARCvdqFQ:APA91bGOiOxhVYKcYz3HW438PzYfENRPVxWYJDmyaqMMbl9eU6gQ8iO-IhA4hiV71OfuDSvGW7vS_Ly1BzDiW8XNxk92MXAgG_ZdVvKD1cHpg39Fw_VqFE-3BlNEZPIPMozpIkO6k6rs';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String msg) async {
    String token = tokenList[0]["token"];
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': msg,
            'title': ConstCurrentUser.myName
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(90),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        // color: Colors.blue,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 40),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                picUrl != null
                    ? Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: picUrl,
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
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      )
                    : Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text(widget.chatName.substring(0, 1),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontFamily: 'OverpassRegular',
                                  fontWeight: FontWeight.bold)),
                        )),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyGroupInfo(
                                  chatRoomId: widget.chatRoomId,
                                )));
                  },
                  child: Container(
                    //color: Colors.red,
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.chatName,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        // Text(
                        //   "Chairma, Thiruppur",
                        //   style: TextStyle(color: Colors.white, fontSize: 15),
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    return new Scaffold(
      appBar: customAppBar,
      body: new Container(
        child: ListView(
          children: [
            chatMessages(),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 65,
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              color: Color.fromRGBO(240, 243, 241, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                        iconSize: 30,
                        color: Colors.black54,
                        icon: Icon(Icons.camera_alt),
                        onPressed: getImage),
                  ),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    width: MediaQuery.of(context).size.width * 0.68,
                    child: TextFormField(
                      controller: messageEditingController,
                      focusNode: textField,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 8),
                        hintText: "Type a message",
                        hintStyle: TextStyle(color: Colors.black26),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                        iconSize: 27,
                        color: Colors.blue,
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Transform.rotate(
                              angle: 320 * pi / 180, child: Icon(Icons.send)),
                        ),
                        onPressed: () {
                          addMessage();
                        }),
                  ),
                ],
              ),
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
