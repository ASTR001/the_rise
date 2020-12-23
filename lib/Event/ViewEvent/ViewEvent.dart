import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_rise/Event/Agenda/EventAgenda.dart';

import '../AllEvents.dart';
import 'package:the_rise/Event/ViewEvent/EventDetails.dart';

class MyViewEvent extends StatefulWidget {
  final String idd;
  final String FromDate;
  final String ToDate;
  final String Venue;
  final String Title;
  final String Description;
  final String bg_img;
  final String cost;

  const MyViewEvent(
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

class _MyAppState extends State<MyViewEvent> {
  int _selectedIndex = 0;
  String eventIdd;

  @override
  void initState() {
    super.initState();
    setState(() {
      print("VIEW_EVENT:  " + widget.idd);
      eventIdd = widget.idd;
      print("VIEW_EVENTTTT:  " + eventIdd);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MyEventDetails(
        idd: widget.idd,
        FromDate: widget.FromDate,
        ToDate: widget.ToDate,
        Venue: widget.Venue,
        Title: widget.Title,
        Description: widget.Description,
        bg_img: widget.bg_img,
        cost: widget.cost,
      ),
      MyEventAgenda(idd: widget.idd),
      Text('Attendance'),
      Text('Community'),
      Text('Messages'),
    ];

    void _onItemTap(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              'Home',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
            ),
            title: Text(
              'Agenda',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group,
            ),
            title: Text(
              'Attendance',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.comment_bank_rounded,
            ),
            title: Text(
              'Community',
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.mail,
            ),
            title: Text(
              'Message',
            ),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}
