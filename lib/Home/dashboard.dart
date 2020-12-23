import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:the_rise/Const/MyWidget.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double currentIndexPage = 0;

  List<String> imgList = [
    'https://neophron.in/images/banner1.jpeg',
    'https://neophron.in/images/banner2.jpeg',
    'https://neophron.in/images/banner3.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                  child: CarouselSlider(
                options: CarouselOptions(
                    aspectRatio: 2.0,
                    viewportFraction: 0.8,
                    enlargeCenterPage: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 1500),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                    autoPlay: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndexPage = index.toDouble();
                      });
                    }),
                items: imgList
                    .map((item) => Container(
                          height: 120,
                          child: Image.network(item, width: 1000.0),
                        ))
                    .toList(),
              )),
              DotsIndicator(
                  dotsCount: imgList.length,
                  position: currentIndexPage,
                  decorator: DotsDecorator(
                    size: const Size.square(5.0),
                    activeSize: const Size.square(8.0),
                    color: Colors.grey,
                    activeColor: Colors.blue,
                  )),
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) => Column(
                children: <Widget>[
                  Container(
                    height: 200.0,
                    width: 100,
                    margin: const EdgeInsets.all(5),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          width: 100.0,
                          margin: EdgeInsets.only(bottom: 55.0),
                          decoration:
                              boxDecoration(radius: 10, showShadow: true),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                                decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: ExactAssetImage('assets/card_bg.jpg'),
                                fit: BoxFit.fitHeight,
                              ),
                            )),
                          ),
                        ),
                        Container(
                          margin: new EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: FractionalOffset.bottomCenter,
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    "https://iqonic.design/themeforest-images/prokit/images/theme1/t1_ic_user1.png"),
                                radius: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            width: double.infinity,
            child: FittedBox(
              child: Image.asset('assets/offer.png'),
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}
