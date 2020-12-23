import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rise/Home/HomePage.dart';
import 'dart:async';

import 'package:the_rise/Intro/intro_page.dart';
import 'package:the_rise/Login/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _mockCheckForSession();
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 3500), () {});

    checkSts();

    return true;
  }

  checkSts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // final bool firststs = prefs.getBool("firstSts");
    final bool loginsts = prefs.getBool("logSts");

    if (loginsts == false) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    } else if (loginsts == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
    // else if (firststs == true && loginsts == true) {
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    // }
    else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 100,
                    child: Opacity(
                        opacity: 1,
                        child: Image.asset('assets/logo_white.png')),
                  ),
                ),
              ),
              Positioned.fill(
                  child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 60),
                  child: Text(
                    'தமிழர் தலைநிமிர் காலம்',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: 'RobotoMono'),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
