import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:the_rise/Login/login_page.dart';
import '../Const/Constants.dart' as Constants;

class MyRegOtpDialog extends StatefulWidget {
  @override
  final String name, mob, mail, mtype, mspcify, amt, idd;
  MyRegOtpDialog(this.name, this.mob, this.mail, this.mtype, this.mspcify,
      this.amt, this.idd,
      {Key key})
      : super(key: key);
  _MyDialogState createState() => new _MyDialogState();
}

enum ConfirmAction { CANCEL, ACCEPT }

class _MyDialogState extends State<MyRegOtpDialog> {
  Razorpay _razorpay;
  ProgressDialog pr;

  @override
  void initState() {
    // TODO: implement initState
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }

  void openPayment() async {
    var options = {
      "key": "rzp_test_1DP5mmOlF5G5ag",
      "amount": num.parse(widget.amt) * 100,
      "name": "The RISE",
      'currency': 'USD',
      "image": "https://neophrontech.com/rise/logo_white.png",
      "theme": {"color": "#3399cc"},
      "description": "Payment for the some random product",
      "prefill": {"contact": widget.mob, "email": widget.mail},
      // 'payment_capture': '0',
      // "receipt": "frazile_13",
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    pr.show();
    sendPaymentData(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
      timeInSecForIosWeb: 4,
    );
  }

  Future sendPaymentData(String pay_id) async {
    final uri = Constants.API_REGISTER_PAYMENT;

    Map data = {
      'memberid': widget.idd,
      'razorpayid': pay_id,
    };
    String body = json.encode(data);

    http.Response response = await http.post(uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body);
    print("ytfyuugbwde" + response.body);
    var jsonData = jsonDecode(response.body);
//      var result = jsonData['login'];

    String sts = jsonData['status'];
    String msg = jsonData['msg'];

    if (sts == "success") {
//        Navigator.pop(context);
      pr.hide();
      Fluttertoast.showToast(
        msg: "Your Subscription Added Successfully.",
        timeInSecForIosWeb: 4,
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    } else {
      pr.hide();
      Fluttertoast.showToast(
          msg: "" + msg,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.red,
          backgroundColor: null,
          fontSize: 13.0);
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
    return AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SvgPicture.asset(
                'assets/success.svg',
                height: 60.0,
                width: 60.0,
                allowDrawingOutsideViewBox: true,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                RichText(
                  text: TextSpan(
                    text: ' Dear ',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.name,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ', You have been Successfully Registered.',
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // FittedBox(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "Membership Type : ",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 16.0,
          //         ),
          //       ),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Text(
          //         widget.mtype,
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.blue,
          //           fontWeight: FontWeight.normal,
          //           fontSize: 14.0,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // FittedBox(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "Membership Specification : ",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 16.0,
          //         ),
          //       ),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Text(
          //         widget.mspcify,
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.blue,
          //           fontWeight: FontWeight.normal,
          //           fontSize: 14.0,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Subscription Amount : ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "\$" + widget.amt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: const Text(
            'SKIP',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          textColor: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(ConfirmAction.CANCEL);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginPage()));
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        ),
        FlatButton(
          child: const Text(
            'PROCED TO PAYMENT',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          textColor: Colors.green,
          onPressed: () {
            openPayment();
          },
        )
      ],
    );
  }
}
