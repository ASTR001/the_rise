import 'package:flutter/foundation.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyImgDialog extends StatefulWidget {
  @override
  final String _img, _id;
  MyImgDialog(this._img, this._id, {Key key}) : super(key: key);
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyImgDialog> {
  ProgressDialog pr;
  String msg;

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
          new Image.network(
            widget._img,
            fit: BoxFit.fill,
            height: 400,
            width: 350,
            alignment: Alignment.center,
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}
