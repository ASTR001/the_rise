import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Profile/bussinessProfileEdit.dart';
import '../Const/Constants.dart' as Constants;
import 'package:the_rise/Profile/aboutProfileEdit.dart';

class ChapterUserProfile extends StatefulWidget {
  final String mobNo;

  const ChapterUserProfile({Key key, this.mobNo}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ChapterUserProfile>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;
  String _idd = "";
  String _name = "";
  String _mob = "";
  String _Mobile = "";
  String _Address = "";
  String _Email = "";
  String _imgg = "";
  String _bussinessname = "";
  String _Website = "";
  String _Interests = "";
  String _cntryId = "";
  String _stateId = "";
  String _regionId = "";
  String _districtId = "";
  String _cityId = "";
  String _cntryName = "";
  String _stateName = "";
  String _regionName = "";
  String _districtName = "";
  String _cityName = "";

  ProgressDialog pr;

  List<Widget> list = [
    Tab(text: "About"),
    Tab(
      text: "Business",
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
    getStringValuesSF();
  }

  getStringValuesSF() async {
    //Return String
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    setState(() {
      _mob = prefs.getString('myphone');
      print(_mob);
      // _mob = widget.mobNo;
      // _branchId = prefs.getString('mylogid');
      getProfile();
    });
  }

  Future<String> getProfile() async {
    pr.show();
    var response = await http.get(
        Uri.encodeFull(Constants.API_PROFILE_VIEW + widget.mobNo),
        headers: {"Accept": "application/json"});
    print("ytfyuugb" + response.body);

    setState(() {
      var jsonData = json.decode(response.body);
      _idd = jsonData[0]["_id"].toString();
      _name = jsonData[0]["Name"].toString();
      _Mobile = jsonData[0]["Mobile"].toString();
      _Address = jsonData[0]["Address"].toString();
      _Email = jsonData[0]["Email"].toString();
      _imgg = jsonData[0]["Photo"].toString();
      _bussinessname = jsonData[0]["bussinessname"].toString();
      _Website = jsonData[0]["Website"].toString();
      _Interests = jsonData[0]["Interests"].toString();
      _cntryId = jsonData[0]["Country"].toString();
      _cntryName = jsonData[0]["CountryDetails"][0]["CountryName"].toString();
      _stateId = jsonData[0]["State"].toString();
      _stateName = jsonData[0]["StateDetails"][0]["StateName"].toString();
      _regionId = jsonData[0]["region"].toString();
      _regionName = jsonData[0]["regionsDetails"][0]["region"].toString();
      _districtId = jsonData[0]["district"].toString();
      _districtName = jsonData[0]["districtsDetails"][0]["district"].toString();
      _cityId = jsonData[0]["CityName"].toString();
      _cityName = jsonData[0]["CityNamesDetails"][0]["CityName"].toString();
    });

    pr.hide();
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
      borderRadius: 1.0,
//        backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 1.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
    );
    return new Scaffold(
        body:
            profileView() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Widget profileView() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.blue,
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/profile_bg.jpg"),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 50, 30, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 60,
                              child: ClipOval(
                                child: Image.network(
                                  _imgg,
                                  // 'assets/logo_white.png',
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25.0),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       'Android Developer',
                    //       textAlign: TextAlign.center,
                    //       overflow: TextOverflow.ellipsis,
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.white,
                    //           fontSize: 18.0),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
              color: Colors.indigo,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.white, Colors.white])),
                child: Column(
                  children: <Widget>[
                    TabBar(
                        onTap: (index) {
                          // Should not used it as it only called when tab options are clicked,
                          // not when user swapped
                        },
                        indicatorColor: Colors.grey,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        controller: _controller,
                        tabs: list),
                  ],
                ),
              ),
            )),
        Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              Icon(
                                Icons.call,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(_Mobile,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 16.0))
                            ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              Icon(
                                Icons.home,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(_Address == "null" ? "" : _Address,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 16.0))
                            ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              Icon(
                                Icons.mail,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(_Email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 16.0))
                            ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              Icon(
                                Icons.card_giftcard,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                  _bussinessname == "null"
                                      ? ""
                                      : _bussinessname,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 16.0))
                            ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              SvgPicture.asset(
                                'assets/global.svg',
                                width: 18.0,
                                height: 18.0,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(_Website == "null" ? "" : _Website,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 16.0))
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              Icon(
                                Icons.card_giftcard,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                  _bussinessname == "null"
                                      ? ""
                                      : _bussinessname,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 16.0))
                            ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              Icon(
                                Icons.mail,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(_Email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 16.0))
                            ]),
                            SizedBox(
                              height: 20,
                            ),
                            Row(children: <Widget>[
                              SvgPicture.asset(
                                'assets/global.svg',
                                width: 18.0,
                                height: 18.0,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(_Website == "null" ? "" : _Website,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 16.0))
                            ]),
                            SizedBox(
                              height: 40,
                            ),
                            // Row(
                            //   children: [
                            //     Text("Skills :",
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.bold,
                            //             color: Colors.black54,
                            //             fontSize: 16.0)),
                            //   ],
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Row(
                            //   children: [
                            //     Text(_Interests,
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.normal,
                            //             color: Colors.black54,
                            //             fontSize: 16.0)),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
