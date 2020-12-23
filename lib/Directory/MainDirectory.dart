import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:the_rise/Chat/ChatAppBar.dart';
import 'package:the_rise/Profile/CountryModel.dart';
import 'package:the_rise/Profile/DistrictModel.dart';
import 'package:the_rise/Profile/RegionModel.dart';
import 'package:the_rise/Profile/StateModel.dart';
import 'package:the_rise/Profile/CityModel.dart';
import 'package:the_rise/Directory/AllChapters.dart';
import 'package:http/http.dart' as http;
import '../Const/Constants.dart' as Constants;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyMainDirectory extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyMainDirectory> {
  String _country = "";
  String _state = "";
  String _region = "";
  String _district = "";

  bottomModel(String msg) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(color: Colors.pink),
              child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0))));
        });
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: SafeArea(
        child: MyChatAppBar(
          title: "RISE Directory",
        ),
      ),
    );

    return new Scaffold(
      appBar: customAppBar,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 180.00,
            height: 100.00,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
            child: new Card(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 45,
                    child: DropdownSearch<CountryModel>(
                      mode: Mode.DIALOG,
//              maxHeight: 300,
                      label: "Select Country",
                      onFind: (String filter) async {
                        var response = await Dio().get(
                          Constants.API_PROFILE_COUNTRY,
                          queryParameters: {"filter": filter},
                        );
                        var models = CountryModel.fromJsonList(
                            response.data['response']);
                        return models;
                      },
                      onChanged: (CountryModel data) {
                        print(data.id);
                        _country = data.id;
                      },
                      showSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        labelText: "Search here...",
                      ),
                      popupTitle: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Select Country',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      popupShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 45,
                    child: DropdownSearch<StateModel>(
                      mode: Mode.DIALOG,
//              maxHeight: 300,
                      label: "Select State",
                      onFind: (String filter) async {
                        var response = await Dio().get(
                          Constants.API_PROFILE_STATE + _country,
                          queryParameters: {"filter": filter},
                        );
                        var models =
                            StateModel.fromJsonList(response.data['response']);
                        return models;
                      },
                      onChanged: (StateModel data) {
                        print(data.id);
                        _state = data.id;
                      },
                      showSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        labelText: "Search here...",
                      ),
                      popupTitle: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Select State',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      popupShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 45,
                    child: DropdownSearch<RegionModel>(
                      mode: Mode.DIALOG,
//              maxHeight: 300,
                      label: "Select Region",
                      onFind: (String filter) async {
                        var response = await Dio().get(
                          Constants.API_PROFILE_REGION + _state,
                          queryParameters: {"filter": filter},
                        );
                        var models =
                            RegionModel.fromJsonList(response.data['response']);
                        return models;
                      },
                      onChanged: (RegionModel data) {
                        print(data.id);
                        _region = data.id;
                      },
                      showSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        labelText: "Search here...",
                      ),
                      popupTitle: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Select Region',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      popupShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 45,
                    child: DropdownSearch<DistrictModel>(
                      mode: Mode.DIALOG,
//              maxHeight: 300,
                      label: "Select District",
                      onFind: (String filter) async {
                        var response = await Dio().get(
                          Constants.API_PROFILE_DISTRICT + _region,
                          queryParameters: {"filter": filter},
                        );
                        var models = DistrictModel.fromJsonList(
                            response.data['response']);
                        return models;
                      },
                      onChanged: (DistrictModel data) {
                        print(data.id);
                        _district = data.id;
                      },
                      showSearchBox: true,
                      searchBoxDecoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                        labelText: "Search here...",
                      ),
                      popupTitle: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Select District',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      popupShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 30),
                    child: ButtonTheme(
                      height: 50,
                      child: FlatButton(
                        onPressed: () {
                          if (_country == "") {
                            bottomModel("Please Select Country");
                          } else if (_state == "") {
                            bottomModel("Please Select State");
                          } else if (_region == "") {
                            bottomModel("Please Select Region");
                          } else if (_district == "") {
                            bottomModel("Please Select District");
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AllChapter(districtId: _district)));
                            print("DIRECTORY_DISTRICT:  " + _district);
                          }
                        },
                        child: Center(
                            child: Text(
                          "SUBMIT".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade500,
                            offset: Offset(1, -2),
                          ),
                          BoxShadow(
                            color: Colors.blue.shade500,
                            offset: Offset(-1, 2),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
