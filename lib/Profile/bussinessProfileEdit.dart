import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Profile/userProfile.dart';
import '../Const/Constants.dart' as Constants;

class BusnessProfileEdit extends StatefulWidget {
  String _idd, _bussName, _desc, _keywords, _products, _website, _imagee;
  String _notifySts;
  BusnessProfileEdit(this._idd, this._bussName, this._desc, this._keywords,
      this._products, this._website, this._imagee, this._notifySts,
      {Key key})
      : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<BusnessProfileEdit> {
  String _name = "";
  String _mob = "";
  String _Mobile = "";
  String _Address = "";
  String _Email = "";
  String _bussinessname = "";
  String _Website = "";
  String _Interests = "";
  bool notifySts;

  int selectedRadioTile;
  List datas;
  var group_id;
  ProgressDialog pr;

  final TextEditingController _controller_bname = TextEditingController();
  final TextEditingController _controller_desc = TextEditingController();
  final TextEditingController _controller_keyword = TextEditingController();
  final TextEditingController _controller_product = TextEditingController();
  final TextEditingController _controller_web = TextEditingController();

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
    _getUsers();
    selectedRadioTile = 0;

    if (widget._notifySts == "true") {
      notifySts = true;
    } else {
      notifySts = false;
    }

    if (widget._bussName.isEmpty || widget._bussName == "null") {
      _controller_bname.text = "";
    } else {
      _controller_bname.text = widget._bussName;
    }

    if (widget._desc.isEmpty || widget._desc == "null") {
      _controller_desc.text = "";
    } else {
      _controller_desc.text = widget._desc;
    }

    if (widget._keywords.isEmpty || widget._keywords == "null") {
      _controller_keyword.text = "";
    } else {
      _controller_keyword.text = widget._keywords;
    }

    if (widget._products.isEmpty || widget._products == "null") {
      _controller_product.text = "";
    } else {
      _controller_product.text = widget._products;
    }

    if (widget._website.isEmpty || widget._website == "null") {
      _controller_web.text = "";
    } else {
      _controller_web.text = widget._website;
    }
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    setState(() {
      _name = prefs.getString('mynamee');
      _mob = prefs.getString('myphone');
    });
  }

  Future<String> _getUsers() async {
    var response = await http.get(
        Uri.encodeFull(Constants.API_PROFILE_INTERESTS),
        headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      datas = json.decode(response.body);
      // datas = dataConvertedToJSON['response'];
    });

    return "Success";
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

    final orientation = MediaQuery.of(context).orientation;
    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(213),
      child: Container(
        color: Colors.blue,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: Image.asset(
                "assets/profile_bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 50, 30, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 57,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 55,
                          child: ClipOval(
                            child: Image.network(
                              widget._imagee,
                              height: 120,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return new Scaffold(
      appBar: customAppBar,
      body: Container(
        color: Colors.indigo,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.white, Colors.white])),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50.0,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _controller_bname,
                        decoration: InputDecoration(
                          labelText: "Business Name",
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50.0,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _controller_desc,
                        decoration: InputDecoration(
                          labelText: "Description",
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50.0,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _controller_keyword,
                        decoration: InputDecoration(
                          labelText: "Keywords",
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50.0,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _controller_product,
                        decoration: InputDecoration(
                          labelText: "Products",
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50.0,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _controller_web,
                        decoration: InputDecoration(
                          labelText: "Website",
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
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Row(
                      children: [
                        Text(
                          "Notifications".toUpperCase(),
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                          value: notifySts,
                          onChanged: (bool value) {
                            setState(() {
                              notifySts = value;
                            });
                          },
                        ),
                        Text(" News & Events"),
                      ],
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: ButtonTheme(
                        height: 50,
                        child: FlatButton(
                          onPressed: () {
                            sendData();
                          },
                          child: Center(
                              child: Text(
                            "SUBMIT".toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade500,
                              offset: Offset(1, -2),
                            ),
                            BoxShadow(
                              color: Colors.blue.shade500,
                              offset: Offset(-1, 2),
                            )
                          ]),
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "Interests".toUpperCase(),
                    //       style: TextStyle(
                    //           color: Colors.blue,
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 0,
                    // ),
                  ])),
                  // datas == null
                  //     ? SliverList(
                  //         delegate: SliverChildListDelegate([
                  //         Center(
                  //             child: Container(
                  //                 height: 40.0,
                  //                 width: 40.0,
                  //                 child: CircularProgressIndicator())),
                  //       ]))
                  //     : datas.length == 0
                  //         ? SliverList(
                  //             delegate: SliverChildListDelegate([
                  //             Text("No data found!"),
                  //           ]))
                  //         : SliverGrid(
                  //             gridDelegate:
                  //                 SliverGridDelegateWithMaxCrossAxisExtent(
                  //               maxCrossAxisExtent: 200.0,
                  //               mainAxisSpacing: 5.0,
                  //               crossAxisSpacing: 5.0,
                  //               childAspectRatio: 4.0,
                  //             ),
                  //             delegate: SliverChildBuilderDelegate(
                  //               (BuildContext context, int index) {
                  //                 return RadioListTile(
                  //                   value: datas[index]['_id'],
                  //                   groupValue: group_id,
                  //                   title: Text(datas[index]['Interests']),
                  //                   onChanged: (val) {
                  //                     print("Radio Tile pressed $val");
                  //                     setSelectedRadioTile(val);
                  //                   },
                  //                   activeColor: Colors.blue,
                  //                   selected: false,
                  //                 );
                  //               },
                  //               childCount: datas.length,
                  //             ),
                  //           ),
                  // SliverList(
                  //     delegate: SliverChildListDelegate([
                  //   Padding(
                  //     padding: const EdgeInsets.all(38.0),
                  //     child: Container(
                  //       height: 100,
                  //       color: Colors.red,
                  //     ),
                  //   )
                  // ])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future sendData() async {
    pr.show();
    final uri = Constants.API_UPDATE_VIEW + widget._idd;

    Map data = {
      'bussinessname': _controller_bname.text.toString(),
      'description': _controller_desc.text.toString(),
      'Keywords': _controller_keyword.text.toString(),
      'Products': _controller_product.text.toString(),
      'Website': _controller_web.text.toString(),
      'newseventnoti': notifySts.toString(),
    };
    String body = json.encode(data);

    http.Response response = await http.put(uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body);
    print("ytfyuugbwde" + response.body);
    var jsonData = jsonDecode(response.body);

    String sts = jsonData['status'];
    String msg = jsonData['msg'];

    if (sts == "success") {
      pr.hide();
      Fluttertoast.showToast(
          msg: "Profile Updated successfully.",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          backgroundColor: null,
          fontSize: 13.0);
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => UserProfile()));
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
}
