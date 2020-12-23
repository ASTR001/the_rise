import 'package:flutter/material.dart';
import 'package:the_rise/Chat/ChatDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_rise/Chat/ChatAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Chat/SingleChat/SingleChatScreen.dart';
import 'package:the_rise/Const/Constants.dart' as Constants;
import 'dart:convert';
import 'package:the_rise/Const/ConstCurrentUser.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyCreateNewGroupChat extends StatefulWidget {
  final String selection;
  final String chatRoomId;
  final List<dynamic> userInfo;
  final List<dynamic> usernameList;
  final List selectedUser;

  const MyCreateNewGroupChat(
      {Key key,
      this.selection,
      this.chatRoomId,
      this.userInfo,
      this.usernameList,
      this.selectedUser})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyCreateNewGroupChat> {
  QuerySnapshot chatRooms;
  MyChatDatabaseMethods databaseMethods = new MyChatDatabaseMethods();
  TextEditingController groupController = new TextEditingController();
  List<Map<String, dynamic>> getGroup = [];
  List<String> usernames = [];
  bool longPress = false;
  bool groupNameValidate = false;

  List userListData;
  List userSearchData;
  List selectedUserDetail = [];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
    getChatUsersData();
    selectedUserDetail = widget.selectedUser;
  }

  Future<String> getChatUsersData() async {
    var response = await http.get(Uri.encodeFull(Constants.API_GET_CHAT_USERS),
        headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      userListData = dataConvertedToJSON['response'];
      userSearchData = userListData;
    });

    return "Success";
  }

  getUserInfogetChats() async {
    MyChatDatabaseMethods().getUserList().then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print("we got the data + ${chatRooms.toString()} ");
      });
    });
  }

  Widget userList() {
    return selectedUserDetail != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: selectedUserDetail.length,
            itemBuilder: (context, index) {
              return userTile(
                selectedUserDetail[index]["Name"] ?? '',
                selectedUserDetail[index]["Mobile"] ?? '',
              );
            })
        : Container(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget userTile(String userName, String userMobile) {
    // var currentCheck = usernames.where((i) => i == userMobile).toList();
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Card(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text(userName.substring(0, 1),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'OverpassRegular',
                                fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(userMobile,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'OverpassRegular',
                                fontWeight: FontWeight.w300)),
                      ],
                    )
                  ],
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        selectedUserDetail = selectedUserDetail
                            .where((i) => i["Mobile"] != userMobile)
                            .toList();
                      });
                    },
                    child: Icon(
                      Icons.remove_circle,
                      size: 30,
                      color: Colors.red[400],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  getChatRoomId() {
    var uuid = Uuid();
    String id = uuid.v1();
    return id;
  }

  sendMessage() {
    if (formKey.currentState.validate()) {
      if (groupController.text.isNotEmpty) {
        Map<String, dynamic> users = {
          "userName": ConstCurrentUser.myName,
          "photoUrl": '',
          "admin": true,
        };
        widget.userInfo.insert(0, users);
        String chatRoomId = getChatRoomId();
        widget.usernameList.add(ConstCurrentUser.myName);
        Map<String, dynamic> chatRoom = {
          "users": widget.usernameList,
          "userInfo": widget.userInfo,
          "chatRoomId": chatRoomId,
          "groupChat": true,
          "groupName": groupController.text,
          "groupPhotoUrl": '',
        };

        databaseMethods.addChatRoom(chatRoom, chatRoomId);

        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyChatScreen(
                      chatRoomId: chatRoomId,
                      chatName: groupController.text,
                      groupChat: false,
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(90),
      child: MyChatAppBar(
        title: "Create New Group",
      ),
    );
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: customAppBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // if (widget.selection != "group")
          Container(
            height: 150,
            child: Stack(
              children: [
                Container(
                  height: 120,
                  color: Colors.white,
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                      child: TextFormField(
                        controller: groupController,
                        readOnly: selectedUserDetail.length == 0 ? true : false,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                            hintText: "Enter Group Name",
                            // hintStyle: TextStyle(color: Colors.balck),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Group Name!";
                          }
                        },
                        autovalidate: groupNameValidate,
                        onTap: () {
                          setState(() {
                            groupNameValidate = true;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        size: 30.0,
                      ),
                      onPressed: selectedUserDetail.length == 0
                          ? () {
                              Fluttertoast.showToast(
                                  msg: "Please select any one or more users!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  fontSize: 15.0);
                            }
                          : () {
                              sendMessage();
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Text("Participants:"),
          ),

          Expanded(child: userList()),
        ],
      ),
    );
  }
}
