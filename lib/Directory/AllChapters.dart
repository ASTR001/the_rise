import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_rise/Directory/ViewChapter.dart';
import 'package:http/http.dart' as http;
import 'package:the_rise/Const/Constants.dart' as Constants;
import 'dart:convert';

class AllChapter extends StatefulWidget {
  final String districtId;

  const AllChapter({Key key, this.districtId}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AllChapter> {
  List chapterListData;
  List chapterSearchData;

  @override
  void initState() {
    super.initState();
    getChaptersData();
  }

  Future<String> getChaptersData() async {
    var response = await http.get(
        Uri.encodeFull(Constants.API_GET_CHAPTER + widget.districtId),
        headers: {"Accept": "application/json"});
    print(response.body);

    setState(() {
      chapterListData = json.decode(response.body);
      chapterSearchData = chapterListData;
    });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get Device Width
    double width = MediaQuery.of(context).size.width * 0.6;

    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: SafeArea(
        child: Container(
          color: Colors.blue,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Container(
                    child: new Padding(
                      padding: const EdgeInsets.only(
                          bottom: 2.0, top: 0.0, left: 8.0, right: 8.0),
                      child: new Card(
                        child: new ListTile(
                          leading: new Icon(Icons.search),
                          title: new TextField(
                            decoration: new InputDecoration(
                                hintText: 'Search here',
                                border: InputBorder.none),
                            onChanged: (value) {
                              setState(() {
                                chapterSearchData = chapterListData
                                    .where((element) =>
                                        element["ChapterName"]
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        element["districtsDetails"][0]
                                                ["district"]
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                          ),
                          // trailing: new IconButton(
                          //   icon: new Icon(Icons.filter_list),
                          //   onPressed: () {
                          //   },
                          // ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar,
        body: chapterSearchData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: chapterSearchData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // This Will Call When User Click On ListView Item
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ViewChapter(
                                chapterId: chapterSearchData[index]["_id"],
                              )));
                    },
                    // Card Which Holds Layout Of ListView Item
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, top: 12.0),
                      child: Container(
                        child: new FittedBox(
                          child: Material(
                              shadowColor: Colors.transparent,
                              color: Color.fromRGBO(239, 242, 244, 0.9),
                              elevation: 14.0,
                              borderRadius: BorderRadius.circular(34.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    height: 150,
                                    width: 200,
                                    child: ClipRRect(
                                      borderRadius: new BorderRadius.only(
                                          topLeft: Radius.circular(24.0),
                                          bottomLeft: Radius.circular(24.0)),
                                      child: Image(
                                        fit: BoxFit.contain,
                                        alignment: Alignment.topLeft,
                                        image: NetworkImage(
                                            chapterSearchData[index]
                                                ["chapterlogo"]),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          chapterSearchData[index]
                                              ["ChapterName"],
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: width,
                                          child: Text(
                                            chapterSearchData[index]["Address"],
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: width,
                                          child: Text(
                                            chapterSearchData[index]
                                                        ["districtsDetails"][0]
                                                    ["district"] +
                                                "," +
                                                chapterSearchData[index]
                                                        ["StateDetails"][0]
                                                    ["StateName"] +
                                                "," +
                                                chapterSearchData[index]
                                                        ["CountryDetails"][0]
                                                    ["CountryName"],
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: ' 178 ',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Members',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  Container(
                                      child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SvgPicture.asset("assets/plus.svg",
                                            width: 38, height: 38)
                                      ],
                                    ),
                                  )),
                                ],
                              )),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
