import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rise/Const/ConstCurrentUser.dart';
import 'package:the_rise/Home/MyDrawer.dart';
import 'package:the_rise/Home/MyHomeProfile.dart';
import 'package:the_rise/Home/MyHomeChat.dart';
import 'package:the_rise/Login/login_page.dart';

import 'MyHomeEvents.dart';
import 'chat.dart';
import 'dashboard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getConstantValue();
  }

  getConstantValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userMob = prefs.getString("myphone");
    final String userName = prefs.getString("mynamee");

    ConstCurrentUser.myName = userMob;
    ConstCurrentUser.myUserName = userName;
  }

  // to keep track of active tab index
  final List<Widget> screens = [
    Dashboard(),
    Chat(),
    MyHomeProfile(),
    MyHomeEvents(),
    MyHomeChat(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboard();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: SafeArea(
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: PageStorage(
              child: currentScreen,
              bucket: bucket,
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: ConvexAppBar(
//        style: TabStyle.fixedCircle,
//        style: TabStyle.textIn,
        style: TabStyle.reactCircle,
//        style: TabStyle.flip,
        backgroundColor: Colors.blue,
        activeColor: Colors.white,

        items: [
          TabItem(icon: Icons.message, title: 'Chat'),
          TabItem(icon: Icons.group, title: 'Group'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.person, title: 'Profile'),
          TabItem(icon: Icons.attach_file, title: 'Events'),
        ],
        initialActiveIndex: 2, //optional, default as 0
        onTap: (int i) {
          if (i == 0) {
            setState(() {
              currentScreen = MyHomeChat(
                  groupChat:
                      false); // if user taps on this dashboard tab will be active
              currentTab = 0;
            });
          } else if (i == 1) {
            setState(() {
              currentScreen =
                  Chat(); // if user taps on this dashboard tab will be active
              currentTab = 0;
            });
          } else if (i == 2) {
            setState(() {
              currentScreen =
                  Dashboard(); // if user taps on this dashboard tab will be active
              currentTab = 0;
            });
          } else if (i == 3) {
            setState(() {
              currentScreen =
                  MyHomeProfile(); // if user taps on this dashboard tab will be active
              currentTab = 0;
            });
          } else if (i == 4) {
            setState(() {
              currentScreen =
                  MyHomeEvents(); // if user taps on this dashboard tab will be active
              currentTab = 0;
            });
          }
        },
      ),
    );
  }
}
