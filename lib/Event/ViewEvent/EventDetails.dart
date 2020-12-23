import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_rise/Event/ViewEvent/SponsorProfile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:the_rise/Const/Constants.dart' as Constants;

import '../AllEvents.dart';

class MyEventDetails extends StatefulWidget {
  final String idd;
  final String FromDate;
  final String ToDate;
  final String Venue;
  final String Title;
  final String Description;
  final String bg_img;
  final String cost;

  const MyEventDetails(
      {Key key,
      this.idd,
      this.FromDate,
      this.ToDate,
      this.Venue,
      this.Title,
      this.Description,
      this.bg_img,
      this.cost})
      : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyEventDetails> {
  List sponserListData;
  @override
  void initState() {
    super.initState();
    print(widget.FromDate);
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

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(263),
      child: Container(
        color: Color(0XFFf8f8f8),
        child: Stack(children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.bg_img),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            height: 90,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0)),
            ),
          ),
          TopBar("Event Home"),
          Positioned(
            bottom: 50.0,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 75,
                    alignment: Alignment.center,
                    child: Container(
                      color: Colors.red[500],
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: 15.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                  DateFormat('MMMd').format(
                                          DateTime.parse(widget.FromDate)) +
                                      " to " +
                                      DateFormat("dd-MM-yyyy").format(
                                          DateTime.parse(widget.ToDate)),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13))
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Row(children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.location_on,
                                size: 15.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(widget.Venue,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13))
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Row(children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.monetization_on,
                                size: 15.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(widget.cost == null ? "" : widget.cost,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 13))
                            ])
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
    return Scaffold(
      appBar: customAppBar,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.Title,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(widget.Description,
                style: TextStyle(color: Colors.black38, fontSize: 14)),
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
                        height: 120,
                        child: Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sponserListData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     new MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             new MySponsorProfile(
                                  //               idd: sponserListData[index]
                                  //                   ["_id"],
                                  //               namee: sponserListData[index]
                                  //                   ["FromDate"],
                                  //             )));
                                },
                                // Card Which Holds Layout Of ListView Item
                                child: Card(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 6.0),
                                  child: Container(
                                    width: 300,
                                    height: 150,
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
                      color: Colors.white,
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

  @override
  State<StatefulWidget> createState() {
    return null;
  }
}
