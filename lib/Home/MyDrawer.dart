import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rise/Chapter/MyChapter.dart';
import 'package:the_rise/Const/colors.dart';
import 'package:the_rise/Login/login_page.dart';
import 'package:the_rise/Profile/userProfile.dart';
import 'package:the_rise/test.dart';
import 'package:the_rise/test2.dart';
import 'package:the_rise/Event/AllEvents.dart';
import 'package:the_rise/Chat/ChatList.dart';
import 'package:the_rise/Directory/MainDirectory.dart';
import 'package:the_rise/Directory/ViewChapter.dart';
import 'package:the_rise/Home/HomePage.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyDrawer> {
  String chapterId;
  String mobNo;
  String imggg;
  String nameee;
  SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myToken();
  }

  myToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      chapterId = prefs.getString('mychapterId');
      mobNo = prefs.getString('myphone');
      imggg = prefs.getString('myimggg');
      nameee = prefs.getString('mynamee');
    });
  }

  var selectedItem = -1;

  Widget text(var text,
      {var fontSize = 18.0,
      textColor = t2_textColorSecondary,
      var isCentered = false,
      var maxLine = 1,
      var latterSpacing = 0.5}) {
    return Text(text,
        textAlign: isCentered ? TextAlign.center : TextAlign.start,
        maxLines: maxLine,
        style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            height: 1.5,
            letterSpacing: latterSpacing));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height,
      child: Drawer(
        elevation: 8,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: t2_white,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 40, right: 20),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                      decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius: new BorderRadius.only(
                              bottomRight: const Radius.circular(24.0),
                              topRight: const Radius.circular(24.0))),
                      /*User Profile*/
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                              child: FadeInImage.assetNetwork(
                                fit: BoxFit.contain,
                                alignment: Alignment.topLeft,
                                placeholder: 'assets/Events/img_loader.gif',
                                image: imggg == null ? "" : imggg,
                              ),
                              radius: 40),
                          SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Welcome",
                                    style: TextStyle(
                                        color: t2_white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    nameee == null ? "" : nameee,
                                    style: TextStyle(
                                        color: t2_white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: 10),
                getDrawerItem("assets/home_icon.svg", "Home", 1),
                getDrawerItem("assets/about.svg", "About RISE", 2),
                getDrawerItem("assets/menu_icon.svg", "My Profile", 3),
                getDrawerItem("assets/chapter.svg", "Chapter", 4),
                getDrawerItem("assets/wall.svg", "The RISE Wall", 5),
                getDrawerItem("assets/news.svg", "The RISE News", 6),
                getDrawerItem("assets/events.svg", "Events", 7),
                getDrawerItem("assets/network.svg", "Networking", 8),
                getDrawerItem("assets/directory.svg", "RISE Directory", 9),
                getDrawerItem("assets/group.svg", "Groups", 10),
                getDrawerItem("assets/chat.svg", "Chat", 11),
                getDrawerItem("assets/market.svg", "RISE Market Place", 12),
                getDrawerItem("assets/assosiation.svg", "Assosiations", 13),
                getDrawerItem("assets/hallfame.svg", "Hall of Fame", 14),
                SizedBox(height: 15),
                Divider(color: t2_view_color, height: 1),
                SizedBox(height: 15),
                getDrawerItem("assets/changepass.svg", "Change Password", 15),
                getDrawerItem("assets/logout.svg", "Logout", 16),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerItem(String icon, String name, int pos) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = pos;
          if (selectedItem == 16) {
            logoutSts();
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new LoginPage()));
          } else if (selectedItem == 1) {
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => new HomePage()));
          } else if (selectedItem == 2) {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new MTest2()));
          } else if (selectedItem == 3) {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new UserProfile()));
          } else if (selectedItem == 4) {
            print("CHAPTER_ID: " + chapterId);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    ViewChapter(chapterId: chapterId)));
          } else if (selectedItem == 7) {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new AllEvents()));
          } else if (selectedItem == 9) {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MyMainDirectory()));
          } else if (selectedItem == 10) {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MyChatList(groupChat: true)));
          } else if (selectedItem == 11) {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new MyChatList(groupChat: false)));
          }
        });
      },
      child: Container(
        color: selectedItem == pos ? t2_colorPrimaryLight : t2_white,
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(icon, width: 18, height: 18),
            SizedBox(width: 20),
            text(
              name,
              textColor:
                  selectedItem == pos ? t2_colorPrimary : t2TextColorPrimary,
              fontSize: 16.0,
            )
          ],
        ),
      ),
    );
  }

  logoutSts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('logSts', false);
  }
}
