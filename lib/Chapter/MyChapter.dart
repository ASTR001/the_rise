import 'package:flutter/material.dart';
import 'package:shape_of_view/shape_of_view.dart';

class MyChapter extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyChapter> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final PreferredSizeWidget customAppBar = PreferredSize(
      preferredSize: Size.fromHeight(300),
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                height: height,
              ),
              ShapeOfView(
                shape: ArcShape(
                  direction: ArcDirection.Outside,
                  height: 45,
                  position: ArcPosition.Bottom,
                ),
                child: Container(
                  height: height * 0.26,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/chapter/bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 110,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: height * 0.2,
                    width: width * 0.3,
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      backgroundImage: NetworkImage(
                          'https://iqonic.design/themeforest-images/prokit/images/theme2/theme2_profile.png'),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: height * 0.33,
                  ),
                  Center(
                    child: Text(
                      'My Chapter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Text(
                  //     'Some Name',
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontSize: 25,
                  //       fontFamily: 'Nunito',
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Row(
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
                              bottom: 2.0, top: 2.0, left: 8.0, right: 8.0),
                          child: new Card(
                            child: new ListTile(
                              leading: new Icon(Icons.search),
                              title: new TextField(
                                decoration: new InputDecoration(
                                    hintText: 'Search here',
                                    border: InputBorder.none),
                                onChanged: (string) {
                                  // _debouncer.run(() {
                                  //   setState(() {
                                  //     filteredUsers = users
                                  //         .where((u) => (u.ChapterName.toLowerCase()
                                  //                 .contains(string.toLowerCase()) ||
                                  //             u.CityName.toLowerCase()
                                  //                 .contains(string.toLowerCase()) ||
                                  //             u.Venue.toLowerCase()
                                  //                 .contains(string.toLowerCase())))
                                  //         .toList();
                                  //   });
                                  // });
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
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: customAppBar,
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Column(
              children: [
                Divider(
                  height: 0.9,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ItemCard(
                      height: height,
                      width: width,
                    );
                  },
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final double height;
  final double width;

  const ItemCard({Key key, this.height, this.width}) : super(key: key);
  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        elevation: 8,
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                height: widget.height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage('assets/img/bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Flutter Development Services',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Divider(),
                    // ReadMoreText(
                    //   'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                    //   textAlign: TextAlign.justify,
                    //   colorClickableText: Colors.blueAccent,
                    //   trimCollapsedText: '...Read More',
                    //   trimExpandedText: ' Show Less',
                    // ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date : 2020-08-01',
                              style: TextStyle(fontSize: 13),
                            ),
                            SizedBox(
                              height: 1.5,
                            ),
                            Text(
                              'End Date : 2020-10-01',
                              style: TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                        RaisedButton(
                          onPressed: () {},
                          color: Colors.blueAccent,
                          child: Text(
                            'APPLY',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
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
}
