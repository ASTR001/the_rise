import 'package:flutter/material.dart';
import 'package:shape_of_view/shape_of_view.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Const/Constants.dart' as Constants;
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:the_rise/Chapter/ChapterUserProfile.dart';
import 'package:the_rise/Const/ConstCurrentUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_rise/Chat/ChatDatabase.dart';
import 'package:the_rise/Chat/SingleChat/SingleChatScreen.dart';

class ViewChapter extends StatefulWidget {
  final String chapterId;

  const ViewChapter({Key key, this.chapterId}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ViewChapter> {
  MyChatDatabaseMethods databaseMethods = new MyChatDatabaseMethods();
  List chapterMemberListData;
  List chapterMemberSearchData;
  String chapterName = "";

  @override
  void initState() {
    super.initState();
    getChaptersData();
  }

  Future<String> getChaptersData() async {
    var response = await http.get(
        Uri.encodeFull(Constants.API_CHAPTER_MEMBER + widget.chapterId),
        headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      chapterMemberListData = json.decode(response.body) ?? [];
      // if(chapterMemberListData == )
      List arr = chapterMemberListData[0]["ChapterNameDetails"];
      if (arr.length != 0) {
        chapterName =
            chapterMemberListData[0]["ChapterNameDetails"][0]["ChapterName"];
      }
      chapterMemberSearchData = chapterMemberListData
          .where((element) => element["Mobile"] != ConstCurrentUser.myName)
          .toList();
    });

    return "Success";
  }

  sendMessage(String userName, String userMobile, String token) async {
    List userList1 = [];
    QuerySnapshot room = await databaseMethods.alReadyRoomCheck(
        userName, ConstCurrentUser.myUserName);
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(height / 2.6),
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                height: height,
              ),
              ShapeOfView(
                shape: ArcShape(
                  direction: ArcDirection.Outside,
                  height: 45,
                  position: ArcPosition.Bottom,
                ),
                child: Container(
                  height: height * 0.26,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/chapter/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 110,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: height * 0.2,
                    width: width * 0.3,
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      backgroundImage: NetworkImage(
                          'https://iqonic.design/themeforest-images/prokit/images/theme2/theme2_profile.png'),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: height * 0.33,
                  ),
                  Center(
                    child: Text(
                      chapterName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Text(
                  //     widget.chapterName,
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontSize: 25,
                  //       fontFamily: 'Nunito',
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Container(
                        child: new Padding(
                          padding: const EdgeInsets.only(
                              bottom: 2.0, top: 2.0, left: 8.0, right: 8.0),
                          child: new Card(
                            child: new ListTile(
                              leading: new Icon(Icons.search),
                              title: new TextField(
                                decoration: new InputDecoration(
                                    hintText: 'Search here',
                                    border: InputBorder.none),
                                onChanged: (string) {
                                  // _debouncer.run(() {
                                  //   setState(() {
                                  //     filteredUsers = users
                                  //         .where((u) => (u.ChapterName.toLowerCase()
                                  //                 .contains(string.toLowerCase()) ||
                                  //             u.CityName.toLowerCase()
                                  //                 .contains(string.toLowerCase()) ||
                                  //             u.Venue.toLowerCase()
                                  //                 .contains(string.toLowerCase())))
                                  //         .toList();
                                  //   });
                                  // });
                                },
                              ),
                              // trailing: new IconButton(
                              //   icon: new Icon(Icons.filter_list),
                              //   onPressed: () {
                              //   },
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: customAppBar,
      body: chapterMemberSearchData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : chapterMemberSearchData.length == 0
              ? Center(
                  child: Text("Data Not Found!"),
                )
              : ListView.builder(
                  itemCount: chapterMemberSearchData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new ChapterUserProfile(
                                      mobNo: chapterMemberSearchData[index]
                                          ["Mobile"],
                                    )));
                      },
                      // Card Which Holds Layout Of ListView Item
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18.0, top: 12.0),
                        child: Container(
                          child: new FittedBox(
                            child: Material(
                                shadowColor: Colors.transparent,
                                color: Color.fromRGBO(239, 242, 244, 0.9),
                                elevation: 14.0,
                                borderRadius: BorderRadius.circular(34.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 150,
                                      child: ClipRRect(
                                        borderRadius: new BorderRadius.only(
                                            topLeft: Radius.circular(24.0),
                                            bottomLeft: Radius.circular(24.0)),
                                        child: Image(
                                          fit: BoxFit.contain,
                                          alignment: Alignment.topLeft,
                                          image: NetworkImage(
                                              chapterMemberSearchData[index]
                                                  ["Photo"]),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            chapterMemberSearchData[index]
                                                ["Name"],
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: width,
                                            child: Text(
                                              "Member",
                                              maxLines: 3,
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  color: Colors.grey[800]),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    )),
                                    InkWell(
                                      onTap: () {
                                        sendMessage(
                                            chapterMemberSearchData[index]
                                                ["Name"],
                                            chapterMemberSearchData[index]
                                                ["Mobile"],
                                            chapterMemberSearchData[index]
                                                ["fcmtoken"]);
                                      },
                                      child: Container(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            SvgPicture.asset("assets/chat.svg",
                                                width: 38, height: 38)
                                          ],
                                        ),
                                      )),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
