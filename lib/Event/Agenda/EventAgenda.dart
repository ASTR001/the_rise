import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:calendar_strip/calendar_strip.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Const/Constants.dart' as Constants;
import 'package:the_rise/Event/ViewEvent/EventAgendaTrackModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class MyEventAgenda extends StatefulWidget {
  final String idd;
  const MyEventAgenda({Key key, this.idd}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MyEventAgenda> {
  DateTime startDate = DateTime(1990);
  DateTime endDate = DateTime(2050);
  DateTime selectedDates;
  List<DateTime> markedDates = [
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now().subtract(Duration(days: 2)),
    DateTime.now().add(Duration(days: 4))
  ];
  bool isLoading = false;
  List agendaDatas;
  String eventId;
  String trackID;

  static DateFormat dateFormatt = DateFormat("yyyy-MM-dd");
  String stringCurrentDate = dateFormatt.format(DateTime.now());

  @override
  void initState() {
    super.initState();
    selectedDates = DateTime.now();
    setState(() {
      eventId = widget.idd;
      print(eventId);
      print(widget.idd);
      print("CURRENT DATE:  " + stringCurrentDate);
      viewAgendaData(stringCurrentDate);
    });
  }

  Future<String> viewAgendaData(String datee) async {
    // var response = await http.get(
    //     Uri.encodeFull(Constants.API_EVENT_AGENDA_FIRST +
    //         widget.idd +
    //         "&FromDate=" +
    //         datee),
    var response = await http.get(
        Uri.encodeFull(
            Constants.API_EVENT_AGENDA_FIRST + widget.idd + "&date=" + datee),
        // Uri.encodeFull(
        //     "https://tamilrise.herokuapp.com/agenda/fetchByevendate?event=5fcb2085bb6dc4001792b58c&date=$datee"),
        headers: {"Accept": "application/json"});

    print(Constants.API_EVENT_AGENDA_FIRST + widget.idd + "&FromDate=" + datee);
    print(response.body);

    setState(() {
      var dataConvertedToJSON = json.decode(response.body);
      agendaDatas = dataConvertedToJSON['response'];
      isLoading = false;
    });

    return "Success";
  }

  onSelect(data) {
    print("Selected Date -> $data");
    setState(() {
      isLoading = true;
    });
    selectedDates = data;
    String selectDate = DateFormat("yyyy-MM-dd").format(data);
    viewAgendaData(selectDate);
  }

  onWeekSelect(data) {
    print("Selected week starting at -> $data");
  }

  _monthNameWidget(monthName) {
    return Container(
      child: Text(
        monthName,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontStyle: FontStyle.italic,
        ),
      ),
      padding: EdgeInsets.only(top: 8, bottom: 4),
    );
  }

  dateTileBuilder(
      date, selectedDate, rowIndex, dayName, isDateMarked, isDateOutOfRange) {
    bool isSelectedDate = date.compareTo(selectedDate) == 0;
    Color fontColor = isDateOutOfRange ? Colors.black26 : Colors.black87;
    TextStyle normalStyle =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: fontColor);
    TextStyle selectedStyle = TextStyle(
        fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black87);
    TextStyle dayNameStyle = TextStyle(fontSize: 14.5, color: fontColor);
    List<Widget> _children = [
      Text(dayName, style: dayNameStyle),
      Text(date.day.toString(),
          style: !isSelectedDate ? normalStyle : selectedStyle),
    ];

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 5),
      decoration: BoxDecoration(
        color: !isSelectedDate ? Colors.transparent : Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: _children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(5),
        ),
        // color: Colors.blue,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 40),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                    height: 40,
                    width: 200,
                    child: Center(
                      child: DropdownSearch<EventAgendaTrackModel>(
                        mode: Mode.DIALOG,
                        // maxHeight: 300,
                        label: "Select Track Type",
                        onFind: (String filter) async {
                          var response = await Dio().get(
                            Constants.API_EVENT_AGENDA_TRACK + widget.idd,
                            queryParameters: {"filter": filter},
                          );
                          var models = EventAgendaTrackModel.fromJsonList(
                              response.data['response']);
                          return models;
                        },
                        onChanged: (EventAgendaTrackModel data) {
                          print(data.id);
                          print(data.name);
                          trackID = data.id;
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
                              'Select Track Type',
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
                    )),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: customAppBar,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
                child: CalendarStrip(
              startDate: startDate,
              endDate: endDate,
              selectedDate: selectedDates,
              onDateSelected: onSelect,
              onWeekSelected: onWeekSelect,
              dateTileBuilder: dateTileBuilder,
              iconColor: Colors.black87,
              monthNameWidget: _monthNameWidget,
              containerDecoration: BoxDecoration(color: Colors.black12),
              addSwipeGesture: true,
            )),
          ),
          agendaDatas == null
              ? Expanded(
                  flex: 8,
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Expanded(
                  flex: 8,
                  child: isLoading == true
                      ? Center(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : agendaDatas.length == 0
                          ? Text("Not Found!")
                          : ListView.builder(
                              itemCount:
                                  agendaDatas == null ? 0 : agendaDatas.length,
                              itemBuilder: (BuildContext context, index) {
                                return Container(
                                  padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(22.0),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(children: <Widget>[
                                                    Icon(
                                                      Icons.person,
                                                      size: 12,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      agendaDatas[index]
                                                              ['agenda']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.purple),
                                                    ),
                                                  ]),
                                                  Row(children: <Widget>[
                                                    Icon(
                                                      Icons.mobile_screen_share,
                                                      size: 12,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      agendaDatas[index]['time']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blueAccent),
                                                    ),
                                                  ]),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(children: <Widget>[
                                                    Icon(
                                                      Icons.map_outlined,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      agendaDatas[index]
                                                              ['venue']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 18),
                                                    ),
                                                  ]),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Remarks : ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    agendaDatas[index]['date']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 18.0),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                ),
        ],
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
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        "https://iqonic.design/themeforest-images/prokit/images/theme3/t3_ic_profile.jpg"),
                    radius: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
