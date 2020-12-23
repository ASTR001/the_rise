import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_rise/Home/HomePage.dart';
import 'package:the_rise/Register/otp.dart';
import 'package:the_rise/Register/signup_page.dart';
import 'package:http/http.dart' as http;
import '../Const/Constants.dart' as Constants;

import 'membershipClassifyModel.dart';
import 'membershipTypeModel.dart';

class SignupPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<SignupPage> {
  bool _passwordVisible = false;

  final TextEditingController _controller_mob = TextEditingController();
  TextEditingController _controller_username = TextEditingController();
  TextEditingController _controller_mail = TextEditingController();
  TextEditingController _controller_pass = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String memberType = "";
  String memberSpecify = "";
  String cntry_code = "";

  String verificationId;
  bool errorMessage;

  PhoneNumber number = PhoneNumber(isoCode: 'IN');

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
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: RichText(
                    text: TextSpan(
                      text: ' Global ',
                      style:
                          TextStyle(fontSize: 30, color: Colors.grey.shade100),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Organization',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' of ',
                          style: TextStyle(
                              fontSize: 30, color: Colors.grey.shade100),
                        ),
                        TextSpan(
                          text: 'Tamil',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' Entrepreneurs & Professionals ',
                          style: TextStyle(
                            color: Colors.grey.shade100,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Membership",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Get started today.",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: _controller_username,
                              decoration: InputDecoration(
                                labelText: "Name",
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
                            InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                print(number.phoneNumber);
                                print(number.dialCode);
                                cntry_code = number.dialCode;
                                print(_controller_mob.toString());
                              },
                              searchBoxDecoration: InputDecoration(
                                labelText: "Mobile number",
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade400),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    )),
                              ),
                              onInputValidated: (bool value) {
                                print(value);
                                errorMessage = value;
                              },
                              selectorConfig: SelectorConfig(
                                selectorType:
                                    PhoneInputSelectorType.BOTTOM_SHEET,
                                backgroundColor: Colors.white,
                                showFlags: true,
                                useEmoji: false,
                              ),
                              ignoreBlank: true,
                              autoValidateMode: AutovalidateMode.always,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: number,
                              textFieldController: _controller_mob,
                              inputBorder: OutlineInputBorder(),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _controller_mail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
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
                              validator: validateEmail,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            DropdownSearch<MembershipTypeModel>(
                              mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                              label: "Select Membership Type",
                              onFind: (String filter) async {
                                var response = await Dio().get(
                                  Constants.API_MEMBERSHIP_TYPE,
                                  queryParameters: {"filter": filter},
                                );
                                var models = MembershipTypeModel.fromJsonList(
                                    response.data['response']);
                                return models;
                              },
                              onChanged: (MembershipTypeModel data) {
                                print(data.id);
                                print(data.name);
                                memberType = data.id;
                              },
                              showSearchBox: true,
                              searchBoxDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 8, 0),
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
                                    'Select Membership Type',
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
                            SizedBox(
                              height: 16,
                            ),
                            DropdownSearch<MembershipClassifyModel>(
                              mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                              label: "Select Membership Classification",
                              onFind: (String filter) async {
                                var response = await Dio().get(
                                  Constants.API_MEMBERSHIP_CLASSIFICATION,
                                  queryParameters: {"filter": filter},
                                );
                                var models =
                                    MembershipClassifyModel.fromJsonList(
                                        response.data['response']);
                                return models;
                              },
                              onChanged: (MembershipClassifyModel data) {
                                print(data.id);
                                memberSpecify = data.id;
                              },
                              showSearchBox: true,
                              searchBoxDecoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 12, 8, 0),
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
                                    'Select Membership Classification',
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
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _controller_pass,
                              keyboardType: TextInputType.text,
                              validator: validatePassword,
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
                            SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: FlatButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    if (_controller_username.text == "") {
                                      bottomModel("Please Enter Name");
                                    } else if (_controller_mob.text == "") {
                                      bottomModel("Please Enter Mobile No");
                                    } else if (!errorMessage) {
                                      bottomModel(
                                          "Please Enter Correct Mobile No");
                                    } else if (_controller_mail.text == "") {
                                      bottomModel("Please Enter Email");
                                    } else if (memberType == "") {
                                      bottomModel(
                                          "Please Select Membership Type");
                                    } else if (memberSpecify == "") {
                                      bottomModel(
                                          "Please Select Membership Classification");
                                    } else if (_controller_pass.text == "") {
                                      bottomModel("Please Enter Password");
                                    } else {
                                      String mob = _controller_mob.text
                                          .toString()
                                          .trim();
                                      // mob.split(" ").join("");
                                      // print(mob);
                                      // print(mob.trim());
                                      print(mob.split(" ").join(""));
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return OTPScreen(
                                            _controller_username.text
                                                .toString(),
                                            mob.split(" ").join(""),
                                            _controller_mail.text.toString(),
                                            memberType,
                                            memberSpecify,
                                            _controller_pass.text.toString(),
                                            cntry_code);
                                      }));
                                    }
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
                                        maxWidth: double.infinity,
                                        minHeight: 50),
                                    child: Text(
                                      "Sign up",
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "I'm already a member. ",
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Sign in",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              )
            ],
          ),
        ));
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }

  String validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.length < 7) {
      return 'Must be more than 6 charater';
    }
    if (!regex.hasMatch(value))
      return 'Enter valid password (Ex: Demo@123)';
    else
      return null;
  }
}
