import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Const/Constants.dart' as Constants;
import 'package:the_rise/Const/ViewImgDialog.dart';
import 'dart:convert';

import '../AllEvents.dart';

class MySponsorProfile extends StatefulWidget {
  final String idd;
  final String namee;

  const MySponsorProfile({Key key, this.idd, this.namee}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MySponsorProfile> {
  List sponserListData;
  @override
  void initState() {
    super.initState();
    getSponsersData();
  }

  Future<String> getSponsersData() async {
    var response = await http.get(Uri.encodeFull(Constants.API_EVENTS_VIEW),
        headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      sponserListData = json.decode(response.body);
    });

    return "Success";
  }

  final PreferredSizeWidget customAppBar = PreferredSize(
    preferredSize: Size.fromHeight(206),
    child: Container(
      color: Color(0XFFf8f8f8),
      child: Stack(children: <Widget>[
        Container(
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0)),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(1, 16, 1, 0),
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 55.0),
                    decoration: boxDecoration(radius: 10, showShadow: true),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 50),
                          text("Rajuuu",
                              textColor: materialColor(0XFF212121),
                              fontSize: 20.0,
                              fontFamily: 'Medium'),
                          text("Test@gmail.com",
                              textColor: Color(0XFFff8080),
                              fontSize: 18.0,
                              fontFamily: 'Medium'),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 16, right: 16),
                            child: Divider(
                              color: Color(0XFFDADADA),
                              height: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: new EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: FractionalOffset.center,
                      child: new CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            "https://iqonic.design/themeforest-images/prokit/images/theme1/t1_ic_user1.png"),
                        radius: 50,
                      ))
                ],
              ),
            ),
          ],
        ),
        TopBar(" "),
      ]),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar,
      body: Card(
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("About",
                      style: TextStyle(color: Colors.black87, fontSize: 16)),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                  "In Harry’s world fate works not only through powers and objects such as prophecies, the Sorting Hat, wands, and the Goblet of Fire, but also through people. Repeatedly, other characters decide Harry’s future for him, depriving him of freedom and choice. For example, before his eleventh birthday, the Dursleys control Harry’s life, keeping from him knowledge of his past and understanding of his identity (Sorcerer’s 49).",
                  style: TextStyle(color: Colors.black38, fontSize: 14)),
              SizedBox(
                height: 10.0,
              ),
              Row(children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.calendar_today,
                  size: 15.0,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Oct15-25,2021",
                    style: TextStyle(color: Colors.black54, fontSize: 14))
              ]),
              SizedBox(
                height: 10.0,
              ),
              Row(children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.calendar_today,
                  size: 15.0,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Oct15-25,2021",
                    style: TextStyle(color: Colors.black54, fontSize: 14))
              ]),
              SizedBox(
                height: 10.0,
              ),
              Row(children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.calendar_today,
                  size: 15.0,
                  color: Colors.black54,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Oct15-25,2021",
                    style: TextStyle(color: Colors.black54, fontSize: 14))
              ]),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Color(0XFFDADADA),
                height: 0.5,
              ),
              SizedBox(
                height: 15.0,
              ),
              sponserListData == null
                  ? Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : sponserListData.length == 0
                      ? Center(
                          child: Container(
                            child: Text("Data Not Found!"),
                          ),
                        )
                      : Container(
                          height: 100,
                          child: Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sponserListData.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    return MyImgDialog(
                                      sponserListData[index]["_id"],
                                      sponserListData[index]["FromDate"],
                                    );
                                  },
                                  // Card Which Holds Layout Of ListView Item
                                  child: Card(
                                    margin: new EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 6.0),
                                    child: Container(
                                      width: 80,
                                      child: new Image.network(
                                          sponserListData[index]["banner"]),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatefulWidget {
  var titleName;

  TopBar(var this.titleName);

  @override
  State<StatefulWidget> createState() {
    return TopBarState();
  }
}

class TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Color(0XFFffffff),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Center(
                        child: Text(
                          widget.titleName,
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor materialColor(colorHax) {
  return MaterialColor(colorHax, color);
}

Widget text(var text,
    {var fontSize = 18.0,
    textColor = const Color(0XFF747474),
    var fontFamily = 'Regular',
    var isCentered = false,
    var maxLine = 1,
    var latterSpacing = 0.5}) {
  return Text(
    text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: maxLine,
    style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: textColor,
        height: 1.5,
        letterSpacing: latterSpacing),
  );
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color bgColor = const Color(0XFFffffff),
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow
        ? [BoxShadow(color: Color(0X95E9EBF0), blurRadius: 2, spreadRadius: 2)]
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}
