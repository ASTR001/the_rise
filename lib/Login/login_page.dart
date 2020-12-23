import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rise/Forgot/forgot.dart';
import 'package:the_rise/Home/HomePage.dart';
import 'package:the_rise/Register/signup_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:the_rise/Login/myMobileLogin.dart';
import 'package:http/http.dart' as http;
import '../Const/Constants.dart' as Constants;
import 'package:progress_dialog/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  ProgressDialog pr;
  String deviceToken;

  final TextEditingController _controller_mob = TextEditingController();
  TextEditingController _controller_pass = TextEditingController();

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
  void initState() {
    // TODO: implement initState
    super.initState();
    myToken();
  }

  myToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      deviceToken = prefs.getString('deviceToken');
    });
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
    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "Hello",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 60,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Please sign in to continue",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
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
                              labelText: "Mobile Number",
                              labelStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade700),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black38,
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
                            height: 16,
                          ),
                          TextField(
                            controller: _controller_pass,
                            keyboardType: TextInputType.text,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade700),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black38,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  )),
                            ),
                          ),
                          // SizedBox(
                          //   height: 12,
                          // ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Navigator.push(context,
                          //           MaterialPageRoute(builder: (context) {
                          //         return MyForgot();
                          //       }));
                          //     },
                          //     child: Text(
                          //       "Forgot Password ?",
                          //       style: TextStyle(
                          //           fontSize: 14, fontWeight: FontWeight.w600),
                          //     ),
                          //   ),
                          // ),
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
                                } else if (_controller_pass.text == "") {
                                  bottomModel("Please Enter Password.");
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
                                    "Sign in",
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
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return HomePage();
                                  // }));
                                },
                                child: Text(
                                  "Sign In Using",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MyMobileLogin();
                                  }));
                                },
                                child: Text(
                                  " Mobile Number ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ],
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
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SignupPage();
              }));
            },
            child: Container(
              height: 40,
              color: Colors.indigo,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Click here to",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      " Register ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future sendLoginData() async {
    pr.show();
    final uri = Constants.API_LOGIN;
    Map data = {
      'Mobile': _controller_mob.text.toString(),
      'password': _controller_pass.text.toString(),
      'fcmtoken': deviceToken,
      'fcmstatus': "1",
    };
    String body = json.encode(data);

    http.Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body);
    print("ytfyuugbwde" + response.body);
    var jsonData = jsonDecode(response.body);

    print(jsonData);
    String status = jsonData['status'];
    String msg = jsonData['msg'];

    if (status == "1") {
      var result = jsonData['user'];
      String _id = result['_id'];
      String _username = result['Name'];
      String _phone = result['Mobile'];
      String _email = result['Email'];
      String _chapter = result['Chapter'];
      String _imgg = result['Photo'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('myidd', _id);
      prefs.setString('mynamee', _username);
      prefs.setString('myphone', _phone);
      prefs.setString('myemail', _email);
      prefs.setString('myimggg', _imgg);
      prefs.setString('mychapterId', _chapter);
      prefs.setBool('logSts', true);

      pr.hide();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      Fluttertoast.showToast(
          msg: "" + msg, toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
    } else {
      pr.hide();
      bottomModel("" + msg);
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to exit an App'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }
}
