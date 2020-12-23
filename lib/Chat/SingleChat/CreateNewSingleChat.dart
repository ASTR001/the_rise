import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rise/Chat/ChatList.dart';
import 'package:the_rise/Chat/GroupChat/CreateNewGroupChat.dart';
import 'package:the_rise/Chat/GroupChat/GroupInfo.dart';
import 'package:the_rise/Chat/SingleChat/SingleChatScreen.dart';
import 'package:the_rise/Const/ConstCurrentUser.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Const/Constants.dart' as Constants;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:the_rise/Chat/ChatAppBar.dart';
import 'package:uuid/uuid.dart';

import '../ChatDatabase.dart';

class MyCreateNewChat extends StatefulWidget {
  final bool groupChat;

  const MyCreateNewChat({Key key, this.groupChat}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyCreateNewChat> {
  MyChatDatabaseMethods databaseMethods = new MyChatDatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  List userListData;
  List userSearchData;
  List selectedUser = [];
  List<int> indexList = [];

  bool isLoading = false;
  bool haveUserSearched = false;

//group Chat
  List<Map<String, dynamic>> getGroup = [];
  List<String> usernames = [];
  bool longPress = false;

  @override
  void initState() {
    super.initState();
    getChatUsersData();
  }

  Future<String> getChatUsersData() async {
    var response = await http.get(Uri.encodeFull(Constants.API_GET_CHAT_USERS),
        headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      userListData = dataConvertedToJSON['response'];
      userSearchData = userListData
          .where((element) => element["Mobile"] != ConstCurrentUser.myName)
          .toList();
    });

    return "Success";
  }

  Widget userList() {
    var userList;
    if (haveUserSearched) {
      userList = searchResultSnapshot.docs.map((e) => e.data()).toList();
    }

    return userSearchData != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: userSearchData.length,
            itemBuilder: (context, index) {
              return userTile(
                  userSearchData[index]["Name"] ?? '',
                  userSearchData[index]["Mobile"] ?? '',
                  userSearchData[index]["fcmtoken"],
                  userSearchData[index],
                  index);
            })
        : Container(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget userTile(String userName, String userMobile, String token,
      var currentUser, int index) {
    var currentCheck = usernames.where((i) => i == userMobile).toList();
    var currentIndex = indexList.where((i) => i == index).toList();
    return GestureDetector(
      onTap: widget.groupChat
          ? () {
              if (currentIndex.length != 0) {
                setState(() {
                  indexList.remove(index);
                });
                var data = {
                  "userName": userMobile,
                  "photoUrl": '',
                  "admin": false,
                };
                usernames.remove(userMobile);
                selectedUser.remove(currentUser);
                List listGroup = getGroup;
                getGroup = listGroup
                    .where((i) => userMobile != i["userName"])
                    .toList();
                getGroup.remove(data);
              } else {
                setState(() {
                  indexList.add(index);
                });

                // setState(() {
                //   longPress = true;
                // });
                usernames.add(userMobile);
                var data = {
                  "userName": userMobile,
                  "photoUrl": '',
                  "admin": false,
                };
                // var getUser = userSearchData
                //     .where((element) => element["_id"].toString() == id)
                //     .toList();
                selectedUser.add(currentUser);
                getGroup.add(data);
              }
            }
          : () {
              sendMessage(userName, userMobile, token);
            },
      child: Card(
        child: Container(
          color: currentIndex.length != 0 ? Colors.blue : null,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color:
                          currentIndex.length != 0 ? Colors.white : Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                        userName != null && userName != ''
                            ? userName.substring(0, 1)
                            : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: currentIndex.length != 0
                                ? Colors.blue
                                : Colors.white,
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
                  Text(userName ?? "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: currentIndex.length != 0
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(userMobile ?? "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: currentIndex.length != 0
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  sendMessage(String userName, String userMobile, String token) async {
    List userList1 = [];
    QuerySnapshot room = await databaseMethods.alReadyRoomCheck(
        userMobile, ConstCurrentUser.myName);
    userList1 = room.docs.map((e) => e.data()).toList();
    String chatRoomId;
    if (userList1.length == 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String deviceToken = prefs.getString('deviceToken');
      List<String> users = [ConstCurrentUser.myName, userMobile];

      chatRoomId = getChatRoomId(ConstCurrentUser.myName, userName);
      List<Map<String, dynamic>> userToken = [
        {
          "userName": ConstCurrentUser.myName,
          "token": deviceToken,
        },
        {
          "userName": userMobile,
          "token": token,
        }
      ];
      List<String> setUserNames = [ConstCurrentUser.myUserName, userName];
      Map<String, dynamic> chatRoom = {
        "users": users,
        "userNames": setUserNames,
        "userToken": userToken,
        "groupChat": false,
        "chatRoomId": chatRoomId,
      };

      databaseMethods.addChatRoom(chatRoom, chatRoomId);
    } else {
      chatRoomId = userList1[0]['chatRoomId'];
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyChatScreen(
                  chatRoomId: chatRoomId,
                  chatName: userName,
                  groupChat: false,
                )));
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: MyChatAppBar(
        title: "Create New Chat",
      ),
    );
    return new Scaffold(
      appBar: customAppBar,
      floatingActionButton: widget.groupChat
          ? FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              onPressed: selectedUser.length == 0
                  ? () {
                      Fluttertoast.showToast(
                          msg: "Please Selecet User!",
                          toastLength: Toast.LENGTH_SHORT,
                          fontSize: 15.0);
                    }
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCreateNewGroupChat(
                                    userInfo: getGroup,
                                    usernameList: usernames,
                                    selectedUser: selectedUser,
                                  )));
                    },
            )
          : null,
      body: isLoading
          ? Container(
              height: 50,
              width: 50,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: searchEditingController,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                        suffixIcon: new GestureDetector(
                          child: new Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                        hintText: "search username ...",
                        hintStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                    onChanged: (value) {
                      setState(() {
                        userSearchData = userListData
                            .where((element) =>
                                element["Name"]
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase()) ||
                                element["Mobile"]
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(child: userList())
              ],
            ),
    );
  }
}
