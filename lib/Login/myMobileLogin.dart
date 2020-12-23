import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rise/Home/HomePage.dart';
import 'package:the_rise/Login/OTPScreenLogin.dart';
import 'package:http/http.dart' as http;
import '../Const/Constants.dart' as Constants;

class MyMobileLogin extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<MyMobileLogin> {
  final TextEditingController _controller_mob = TextEditingController();
  ProgressDialog pr;

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

  Future sendLoginData() async {
    pr.show();
    final uri = Constants.API_MOBILE_LOGIN + _controller_mob.text.toString();
    ;
    var response = await http.get(uri);
    var jsonData = json.decode(response.body);
    print(jsonData);
    String status = jsonData['status'];
    String msg = jsonData['msg'];

    if (status == "1") {
      var result = jsonData['user'];
      String _id = result['_id'];
      String _username = result['Name'];
      String _phone = result['Mobile'];
      String _email = result['Email'];
      String _code = result['Countrycode'];
      String _chapter = result['Chapter'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('myidd', _id);
      prefs.setString('mynamee', _username);
      prefs.setString('myphone', _phone);
      prefs.setString('myemail', _email);
      prefs.setString('mychapterId', _chapter);
      // prefs.setBool('logSts', true);

      pr.hide();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OTPScreenLogin(_phone, _code);
      }));
      // Fluttertoast.showToast(
      //     msg: "" + msg, toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
    } else {
      pr.hide();
      bottomModel("" + msg);
    }
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 200,
                          child: Image.asset(
                            "assets/logo.png",
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 68),
                    Text(
                      "Login Using Your Mobile Number",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Please enter mobile number to search your account.",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: _controller_mob,
                          decoration: InputDecoration(
                            labelText: " Mobile Number",
                            labelStyle: TextStyle(
                                fontSize: 14, color: Colors.grey.shade400),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: FlatButton(
                            onPressed: () async {
                              if (_controller_mob.text == "") {
                                bottomModel("Please Enter Mobile Number.");
                              } else {
                                sendLoginData();
                              }
                            },
                            padding: EdgeInsets.all(0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.blue),
                              child: Container(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(
                                    maxWidth: double.infinity, minHeight: 50),
                                child: Text(
                                  "Find",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
