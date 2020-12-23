import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:the_rise/Login/login_page.dart';
import 'package:the_rise/Register/reg_otp_dialog.dart';
import 'package:http/http.dart' as http;
import '../Const/Constants.dart' as Constants;

class OTPScreen extends StatefulWidget {
  final String c_username, c_mob, c_mail, mType, mSpecify, c_pass, cntry_code;
  OTPScreen(this.c_username, this.c_mob, this.c_mail, this.mType, this.mSpecify,
      this.c_pass, this.cntry_code,
      {Key key})
      : super(key: key);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController textEditingController = TextEditingController();
  var onTapRecognizer;
  ProgressDialog pr;

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  bool isCodeSent = false;
  String _verificationId;

  @override
  void initState() {
    _onVerifyCode();
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
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
    print("isValid - $isCodeSent");
    // print("mobiel ${widget.mobileNumber}");
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 50),
              Container(
                height: 100,
                width: 200,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(height: 78),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Required OTP',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text:
                          "Enter enter code sent to your entered mobile number ",
                      children: [
                        TextSpan(
                            text: widget.cntry_code + " " + widget.c_mob,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 50),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v.length < 3) {
                          return "I'm from validator";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor:
                            hasError ? Colors.orange : Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please enter correct OTP!" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // RichText(
              //   textAlign: TextAlign.center,
              //   text: TextSpan(
              //       text: "Didn't receive the code? ",
              //       style: TextStyle(color: Colors.black54, fontSize: 15),
              //       children: [
              //         TextSpan(
              //             text: " RESEND",
              //             recognizer: onTapRecognizer,
              //             style: TextStyle(
              //                 color: Colors.indigo,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 16))
              //       ]),
              // ),
              // SizedBox(
              //   height: 14,
              // ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      if (textEditingController.text.length == 6) {
                        _onFormSubmitted();
                      } else {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                        showToast("Invalid OTP", Colors.red);
                      }
                    },
                    child: Center(
                        child: Text(
                      "VERIFY".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.blue.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth.signInWithCredential(phoneAuthCredential).then((value) {
        if (value.user != null) {
          // Handle loogged in state
          print(value.user.phoneNumber);
          RegisterData();
          pr.show();
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.red);
      });
    };
    final PhoneVerificationFailed verificationFailed = (authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: widget.cntry_code + widget.c_mob,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: textEditingController.text);

    _firebaseAuth.signInWithCredential(_authCredential).then((value) {
      if (value.user != null) {
        // Handle loogged in state
        print(value.user.phoneNumber);
        RegisterData();
        pr.show();

        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => HomePage(
        //         user: value.user,
        //       ),
        //     ),
        //     (Route<dynamic> route) => false);
      } else {
        showToast("Error validating OTP, try again", Colors.red);
      }
    }).catchError((error) {
      showToast("Something went wrong", Colors.red);
    });
  }

  Future RegisterData() async {
    final uri = Constants.API_REGISTER;

    Map data = {
      'Name': widget.c_username,
      'Mobile': widget.c_mob,
      'Email': widget.c_mail,
      'MembershipType': widget.mType,
      'Category': widget.mSpecify,
      'password': widget.c_pass,
      'Countrycode': widget.cntry_code,
    };
    String body = json.encode(data);

    http.Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body);
    print("ytfyuugbwde" + response.body);
    var jsonData = jsonDecode(response.body);

    String sts = jsonData['Status'];
    String msg = jsonData['msg'];

    if (sts == "true") {
      String amt = jsonData['Payment'];
      var result = jsonData['response'];
      String idd = result['_id'];

//        Navigator.pop(context);
      pr.hide();
      // Fluttertoast.showToast(
      //     msg: "" + msg,
      //     toastLength: Toast.LENGTH_SHORT,
      //     textColor: Colors.black,
      //     backgroundColor: null,
      //     fontSize: 13.0);

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return WillPopScope(
                onWillPop: () {},
                child: MyRegOtpDialog(widget.c_username, widget.c_mob,
                    widget.c_mail, widget.mType, widget.mSpecify, amt, idd));
          });
    } else {
      pr.hide();
      showToast(msg, Colors.red);
    }
  }
}
