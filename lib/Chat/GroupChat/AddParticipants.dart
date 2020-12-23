import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_rise/Chat/ChatAppBar.dart';
import 'package:the_rise/Chat/ChatDatabase.dart';
import 'package:the_rise/Chat/GroupChat/GroupInfo.dart';
import 'package:the_rise/Const/ConstCurrentUser.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Const/Constants.dart' as Constants;

class AddParticipant extends StatefulWidget {
  final String selection;
  final String chatRoomId;
  final List<dynamic> userInfo;
  final List<dynamic> userList;

  const AddParticipant(
      {Key key, this.selection, this.chatRoomId, this.userInfo, this.userList})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddParticipantsState();
  }
}

class _AddParticipantsState extends State<AddParticipant> {
  QuerySnapshot chatRooms;
  MyChatDatabaseMethods databaseMethods = new MyChatDatabaseMethods();
  TextEditingController groupController = new TextEditingController();
  List<Map<String, dynamic>> getGroup = [];
  List<String> usernames = [];
  bool longPress = false;
  List userListData;
  List userSearchData;
  List<int> indexList = [];

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
      userSearchData = userListData;
    });

    return "Success";
  }

  Widget userList() {
    var userList;
    if (chatRooms != null) {
      userList = chatRooms.docs.map((e) => e.data()).toList();
    }

    return userSearchData != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: userSearchData.length,
            itemBuilder: (context, index) {
              return userTile(
                userSearchData[index]["Name"],
                userSearchData[index]["Mobile"],
                index,
              );
            })
        : Container();
  }

  Widget userTile(String userName, String userMobile, int index) {
    var currentCheck = usernames.where((i) => i == userMobile).toList();
    var currentIndex = indexList.where((i) => i == index).toList();
    return GestureDetector(
      onTap: () {
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
          List listGroup = getGroup;
          getGroup =
              listGroup.where((i) => userMobile != i["userName"]).toList();
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
          getGroup.add(data);
        }
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

  add() async {
    var snapshots = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .get();
    var names = widget.userList;
    var group = widget.userInfo;
    names.addAll(usernames);
    group.addAll(getGroup);
    await snapshots
        .then((value) => value.reference
            .update(<String, dynamic>{"users": names, "userInfo": group}))
        .catchError((onError) {
      print(onError);
    });
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyGroupInfo(
                  chatRoomId: widget.chatRoomId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(90),
      child: MyChatAppBar(
        title: "Add Participants",
      ),
    );
    return Scaffold(
      appBar: customAppBar,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: add,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: groupController,
              style: TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
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
          Expanded(child: userList()),
        ],
      ),
    );
  }
}
