import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_rise/Const/MyWidget.dart';

class Chat extends StatelessWidget {
  static var tag = "/T1Cards";

  Widget counter(String counter, String counterName) {
    return Column(
      children: <Widget>[
        Text(counter,
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontFamily: 'Medium'),
            textAlign: TextAlign.center),
        Text(counterName,
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontFamily: 'Medium'),
            textAlign: TextAlign.center)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body: Column(
      //   children: <Widget>[
      //     Container(
      //       height: 230.0,
      //       width: 120.0,
      //       margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      //       child: Stack(
      //         children: <Widget>[
      //           Container(
      //             height: 230.0,
      //             width: 120.0,
      //             margin: EdgeInsets.only(bottom: 55.0),
      //             decoration: boxDecoration(radius: 5, showShadow: true),
      //             child: Padding(
      //               padding: const EdgeInsets.all(0.0),
      //               child: Container(
      //                 color: Colors.orange,
      //               ),
      //             ),
      //           ),
      //           Container(
      //               margin: new EdgeInsets.symmetric(horizontal: 26.0),
      //               alignment: FractionalOffset.bottomCenter,
      //               child: new CircleAvatar(
      //                 backgroundImage: CachedNetworkImageProvider(
      //                     "https://iqonic.design/themeforest-images/prokit/images/theme1/t1_ic_user1.png"),
      //                 radius: 50,
      //               ))
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
