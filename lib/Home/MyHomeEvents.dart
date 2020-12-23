import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:the_rise/Event/ViewEvent/ViewEvent.dart';
import 'package:http/http.dart' as http;
import '../Const/Constants.dart' as Constants;

class MyHomeEvents extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHomeEvents> {
  List eventListData;
  List eventSearchData;

  @override
  void initState() {
    super.initState();
    getChaptersData();
  }

  Future<String> getChaptersData() async {
    var response = await http.get(Uri.encodeFull(Constants.API_EVENTS_VIEW),
        headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      eventListData = json.decode(response.body);
      eventSearchData = eventListData;
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Container(
        color: Colors.blue,
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                // width: MediaQuery.of(context).size.width,
                height: 60,
                child: Container(
                  child: new Padding(
                    padding: const EdgeInsets.only(
                        bottom: 2.0, top: 0.0, left: 8.0, right: 8.0),
                    child: new Card(
                      child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          decoration: new InputDecoration(
                              hintText: 'Search here',
                              border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              eventSearchData = eventListData
                                  .where((element) =>
                                      element["Title"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element["Venue"]
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                  .toList();
                            });
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
      ),
    );
    return Scaffold(
      appBar: customAppBar,
      body: eventSearchData == null
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                child: LiquidCircularProgressIndicator(
                  value: 0.25, // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Colors
                      .pink), // Defaults to the current Theme's accentColor.
                  backgroundColor: Colors
                      .white, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.red,
                  borderWidth: 5.0,
                  direction: Axis
                      .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                  center: Text("Loading..."),
                ),
              ),
            )
          : eventSearchData.length == 0
              ? Center(
                  child: Container(
                    child: Text("Data Not Found!"),
                  ),
                )
              : ListView.builder(
                  itemCount: eventSearchData.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // print(eventSearchData[index].id);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new MyViewEvent(
                                      idd: eventSearchData[index]["_id"],
                                      FromDate: eventSearchData[index]
                                          ["FromDate"],
                                      ToDate: eventSearchData[index]["ToDate"],
                                      Venue: eventSearchData[index]["Venue"],
                                      Title: eventSearchData[index]["Title"],
                                      Description: eventSearchData[index]
                                          ["Description"],
                                      bg_img: eventSearchData[index]["banner"],
                                      cost: eventSearchData[index]["cost"],
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 150,
                                      width: 200,
                                      child: ClipRRect(
                                        borderRadius: new BorderRadius.only(
                                            topLeft: Radius.circular(24.0),
                                            bottomLeft: Radius.circular(24.0)),
                                        child: FadeInImage.assetNetwork(
                                          fit: BoxFit.contain,
                                          alignment: Alignment.topLeft,
                                          placeholder:
                                              'assets/Events/img_loader.gif',
                                          image: eventSearchData[index]
                                              ["Image"],
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
                                            eventSearchData[index]["Title"],
                                            style: TextStyle(
                                              fontSize: 16,
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
                                              eventSearchData[index]
                                                  ["Description"],
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              size: 15.0,
                                              color: Colors.green,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              DateFormat("dd-MM-yyyy").format(
                                                  DateTime.parse(
                                                      eventSearchData[index]
                                                          ["FromDate"])),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green),
                                            ),
                                          ]),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              size: 15.0,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              DateFormat("dd-MM-yyyy").format(
                                                  DateTime.parse(
                                                      eventSearchData[index]
                                                          ["ToDate"])),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red),
                                            )
                                          ]),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(children: <Widget>[
                                            Icon(
                                              Icons.location_on,
                                              size: 18.0,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                                eventSearchData[index]["Venue"])
                                          ]),
                                        ],
                                      ),
                                    )),
                                    // Container(
                                    //     child: Padding(
                                    //   padding: const EdgeInsets.all(2.0),
                                    //   child: Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     children: <Widget>[
                                    //       SvgPicture.asset("",
                                    //           width: 38, height: 38)
                                    //     ],
                                    //   ),
                                    // )),
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
