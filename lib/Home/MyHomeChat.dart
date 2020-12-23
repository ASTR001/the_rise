import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rise/Chat/ChatDatabase.dart';
import 'package:the_rise/Chat/ChatRoomsTile.dart';
import 'package:the_rise/Chat/SingleChat/CreateNewSingleChat.dart';
import 'package:the_rise/Const/ConstCurrentUser.dart';
import 'package:the_rise/Chat/ChatAppBar.dart';
import 'package:the_rise/Const/TopBar.dart';

class MyHomeChat extends StatefulWidget {
  final bool groupChat;
  const MyHomeChat({Key key, this.groupChat}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHomeChat> with WidgetsBindingObserver {
  Stream chatRooms;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    getConstantValue();
    getUserInfoGetChats();
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

  getConstantValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userMob = prefs.getString("myphone");
    final String userName = prefs.getString("mynamee");

    ConstCurrentUser.myName = userMob;
    ConstCurrentUser.myUserName = userName;
  }

  getUserInfoGetChats() async {
    MyChatDatabaseMethods()
        .getUserChats(ConstCurrentUser.myName)
        .then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${ConstCurrentUser.myName}");
      });
    });
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        var chatRoomList = [];
        var chatRoomList1 = [];
        if (snapshot.hasData) {
          chatRoomList1 = snapshot.data.docs.map((e) => e.data()).toList();
          chatRoomList = chatRoomList1
              .where((element) => element["groupChat"] == widget.groupChat)
              .toList();
        }
        return snapshot.hasData
            ? ListView.builder(
                itemCount: chatRoomList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  List userName;
                  if (widget.groupChat != true) {
                    List user = chatRoomList[index]['userNames'];
                    userName = user
                        .where(
                            (i) => i.toString() != ConstCurrentUser.myUserName)
                        .toList();
                  }
                  return ChatRoomsTile(
                    userName: chatRoomList[index]['groupChat'] != null &&
                            chatRoomList[index]['groupChat']
                        ? chatRoomList[index]['groupName']
                        : userName[0],
                    chatRoomId: chatRoomList[index]["chatRoomId"],
                    groupChat: chatRoomList[index]["groupChat"] ?? false,
                    url: chatRoomList[index]["groupPhotoUrl"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyCreateNewChat(
                        groupChat: widget.groupChat,
                      )));
        },
      ),
    );
  }
}
