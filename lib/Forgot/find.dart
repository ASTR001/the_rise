import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_rise/Forgot/change_success.dart';

class GroupModel {
  String text;
  int index;
  bool selected;
  String icon;

  GroupModel({this.text, this.index, this.selected, this.icon});
}

class MyFind extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<MyFind> {
  int _value2 = 0;
  List<GroupModel> _group = [
    GroupModel(
        text: " 9998765167",
        index: 1,
        selected: false,
        icon: "assets/mobile.svg"),
    GroupModel(
        text: " testrise@gmail.com",
        index: 2,
        selected: false,
        icon: "assets/gmail.svg"),
  ];

  Widget makeRadioTiles() {
    List<Widget> list = new List<Widget>();

    for (int i = 0; i < _group.length; i++) {
      list.add(Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            color: _group[i].selected ? Colors.blue : Colors.grey.shade300,
            borderRadius: BorderRadius.all(
                Radius.circular(10.0) //         <--- border radius here
                )),
        child: RadioListTile(
          value: _group[i].index,
          groupValue: _value2,
          selected: _group[i].selected,
          onChanged: (val) {
            setState(() {
              for (int i = 0; i < _group.length; i++) {
                _group[i].selected = false;
              }
              _value2 = val;
              _group[i].selected = true;
            });
          },
          activeColor: Colors.white,
          controlAffinity: ListTileControlAffinity.trailing,
          title: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: SvgPicture.asset('${_group[i].icon}',
                      width: 18, height: 18),
                ),
                TextSpan(
                  text: ' ${_group[i].text}',
                  style: TextStyle(
                      color: _group[i].selected ? Colors.white : Colors.black,
                      fontWeight: _group[i].selected
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
      ));
    }

    Column column = Column(
      children: list,
    );
    return column;
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
                      "Recover Password",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Select one of any creadentials which should we use for recover your password.",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: <Widget>[
                        makeRadioTiles(),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: FlatButton(
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChangeSuccess();
                              }));
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
                                  "Next",
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
