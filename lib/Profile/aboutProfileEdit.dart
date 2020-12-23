import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Register/membershipClassifyModel.dart';
import '../Const/Constants.dart' as Constants;
import 'package:the_rise/Profile/userProfile.dart';
import 'CityModel.dart';
import 'CountryModel.dart';
import 'DistrictModel.dart';
import 'RegionModel.dart';
import 'StateModel.dart';

class AboutProfileEdit extends StatefulWidget {
  String idd,
      name,
      mobile,
      image,
      email,
      address,
      cntryId,
      cntryName,
      stateId,
      stateName,
      regionId,
      regionName,
      districtId,
      districtName,
      cityId,
      cityName;

  AboutProfileEdit(
      this.idd,
      this.name,
      this.mobile,
      this.image,
      this.email,
      this.address,
      this.cntryId,
      this.cntryName,
      this.stateId,
      this.stateName,
      this.regionId,
      this.regionName,
      this.districtId,
      this.districtName,
      this.cityId,
      this.cityName,
      {Key key})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AboutProfileEdit> {
  String _name = "";
  String _mob = "";
  String _Mobile = "";
  String _Address = "";
  String _Email = "";
  String _bussinessname = "";
  String _Website = "";
  String _Interests = "";
  String url = "";

  final TextEditingController _controller_name = TextEditingController();
  final TextEditingController _controller_mail = TextEditingController();
  final TextEditingController _controller_mob = TextEditingController();
  final TextEditingController _controller_add = TextEditingController();

  ProgressDialog pr;

  String _country = "";
  String _state = "";
  String _region = "";
  String _district = "";
  String _city = "";

  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  @override
  void initState() {
    super.initState();
    _controller_name.text = widget.name;
    _controller_mail.text = widget.email;
    _controller_mob.text = widget.mobile;
    if (widget.address.isEmpty || widget.address == "null") {
      _controller_add.text = "";
    } else {
      _controller_add.text = widget.address;
    }

    if (widget.cntryId == "null" || widget.cntryId.isEmpty) {
      _country = "";
    } else {
      _country = widget.cntryId;
    }
    if (widget.stateId == "null" || widget.stateId.isEmpty) {
      _state = "";
    } else {
      _state = widget.stateId;
    }
    if (widget.regionId == "null" || widget.regionId.isEmpty) {
      _region = "";
    } else {
      _region = widget.regionId;
    }
    if (widget.districtId == "null" || widget.districtId.isEmpty) {
      _district = "";
    } else {
      _district = widget.districtId;
    }
    if (widget.cityId == "null" || widget.cityId.isEmpty) {
      _city = "";
    } else {
      _city = widget.cityId;
    }

    getStringValuesSF();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    setState(() {
      _name = prefs.getString('mynamee');
      _mob = prefs.getString('myphone');
    });
  }

  //========================= Gellary / Camera AlerBox
  void _onAlertPress() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/galleryicon.png',
                      width: 50,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/cameraicon.png',
                      width: 50,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage,
              ),
            ],
          );
        });
  }

  File _image1;
  final picker = ImagePicker();
  // ================================= Image from camera
  getCameraImage() async {
    File _image;
    final pickedFile = await picker.getImage(
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 80,
        source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _image1 = _image;
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
    if (_image != null) {
      compressImage(_image);
    }
    setStatus('');
  }

  //============================== Image from gallery
  getGalleryImage() async {
    File _image;
    final pickedFile = await picker.getImage(
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 80,
        source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _image1 = _image;
      } else {
        print('No image selected.');
      }
    });
    Navigator.pop(context);
    if (_image != null) {
      compressImage(_image);
    }
    setStatus('');
  }

  compressImage(File imageToCompress) async {
    pr.show();
    String url = await uploadImageToStorage(imageToCompress);
  }

  var _storageReference;
  uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    final storageUploadTask = await _storageReference.putFile(imageFile);
    url = await _storageReference.getDownloadURL();
    print(url);
    pr.hide();
    Fluttertoast.showToast(
        msg: "" + url, toastLength: Toast.LENGTH_SHORT, fontSize: 15.0);
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Widget showImage() {
    // return FutureBuilder<File>(
    //   future: file,
    //   builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
    if (_image1 != null) {
      return CircleAvatar(
        radius: 57,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 55,
          child: ClipOval(
            child: Image.file(
              _image1,
              height: 120,
              width: 120,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 57,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 55,
          child: ClipOval(
            child: Image.network(
              widget.image,
              height: 120,
              width: 120,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    }
    //   },
    // );
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
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Container(
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
                          showImage(),
                          Positioned(
                              bottom: 1,
                              right: 1,
                              child: GestureDetector(
                                  onTap: _onAlertPress,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                  )))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.indigo,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.white, Colors.white])),
                child: SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: _controller_name,
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
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _controller_mail,
                              decoration: InputDecoration(
                                labelText: "Email Id",
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
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            child: TextField(
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
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            child: TextField(
                              keyboardType: TextInputType.streetAddress,
                              controller: _controller_add,
                              decoration: InputDecoration(
                                labelText: "Address",
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
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            child: DropdownSearch<CountryModel>(
                              mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                              label: "Select Country",
                              onFind: (String filter) async {
                                var response = await Dio().get(
                                  Constants.API_PROFILE_COUNTRY,
                                  queryParameters: {"filter": filter},
                                );
                                var models = CountryModel.fromJsonList(
                                    response.data['response']);
                                return models;
                              },
                              selectedItem: widget.cntryName.isEmpty ||
                                      widget.cntryName == "null"
                                  ? null
                                  : CountryModel(
                                      id: widget.cntryId,
                                      name: widget.cntryName),
                              onChanged: (CountryModel data) {
                                print(data.id);
                                _country = data.id;
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
                                    'Select Country',
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
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            child: DropdownSearch<StateModel>(
                              mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                              label: "Select State",
                              onFind: (String filter) async {
                                var response = await Dio().get(
                                  Constants.API_PROFILE_STATE + _country,
                                  queryParameters: {"filter": filter},
                                );
                                var models = StateModel.fromJsonList(
                                    response.data['response']);
                                return models;
                              },
                              selectedItem: widget.stateName.isEmpty ||
                                      widget.stateName == ""
                                  ? null
                                  : StateModel(
                                      id: widget.stateId,
                                      name: widget.stateName),
                              onChanged: (StateModel data) {
                                print(data.id);
                                _state = data.id;
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
                                    'Select State',
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
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            child: DropdownSearch<RegionModel>(
                              mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                              label: "Select Region",
                              onFind: (String filter) async {
                                var response = await Dio().get(
                                  Constants.API_PROFILE_REGION + _state,
                                  queryParameters: {"filter": filter},
                                );
                                var models = RegionModel.fromJsonList(
                                    response.data['response']);
                                return models;
                              },
                              selectedItem: widget.regionName.isEmpty ||
                                      widget.regionName == ""
                                  ? null
                                  : RegionModel(
                                      id: widget.regionId,
                                      name: widget.regionName),
                              onChanged: (RegionModel data) {
                                print(data.id);
                                _region = data.id;
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
                                    'Select Region',
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
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            child: DropdownSearch<DistrictModel>(
                              mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                              label: "Select District",
                              onFind: (String filter) async {
                                var response = await Dio().get(
                                  Constants.API_PROFILE_DISTRICT + _region,
                                  queryParameters: {"filter": filter},
                                );
                                var models = DistrictModel.fromJsonList(
                                    response.data['response']);
                                return models;
                              },
                              selectedItem: widget.districtName.isEmpty ||
                                      widget.districtName == ""
                                  ? null
                                  : DistrictModel(
                                      id: widget.districtId,
                                      name: widget.districtName),
                              onChanged: (DistrictModel data) {
                                print(data.id);
                                _district = data.id;
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
                                    'Select District',
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
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            height: 50,
                            child: DropdownSearch<CityModel>(
                              mode: Mode.BOTTOM_SHEET,
//              maxHeight: 300,
                              label: "Select City",
                              onFind: (String filter) async {
                                var response = await Dio().get(
                                  Constants.API_PROFILE_CITY + _district,
                                  queryParameters: {"filter": filter},
                                );
                                var models = CityModel.fromJsonList(
                                    response.data['response']);
                                return models;
                              },
                              selectedItem: widget.cityName.isEmpty ||
                                      widget.cityName == ""
                                  ? null
                                  : CityModel(
                                      id: widget.cityId, name: widget.cityName),
                              onChanged: (CityModel data) {
                                print(data.id);
                                _city = data.id;
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
                                    'Select City',
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future sendData() async {
    pr.show();
    final uri = Constants.API_UPDATE_VIEW + widget.idd;

    Map data = {
      'Name': _controller_name.text.toString(),
      'Email': _controller_mail.text.toString(),
      'Mobile': _controller_mob.text.toString(),
      'Address': _controller_add.text.toString(),
      'Country': _country,
      'State': _state,
      'region': _region,
      'district': _district,
      'CityName': _city,
      'Photo': url,
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
