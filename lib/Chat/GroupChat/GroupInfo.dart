import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_rise/Chat/ChatDatabase.dart';
import 'package:the_rise/Chat/GroupChat/AddParticipants.dart';
import 'package:the_rise/Chat/GroupChat/EditGroupChatName.dart';
import 'package:the_rise/Const/ConstCurrentUser.dart';

class MyGroupInfo extends StatefulWidget {
  final String chatRoomId;

  const MyGroupInfo({Key key, this.chatRoomId}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyGroupInfo> {
  QuerySnapshot chatRooms;
  List userList;
  var userList1;
  String picUrl;
  String groupName = '';
  File _image;
  final picker = ImagePicker();
  bool isLoading = false;
  List currentUser;
  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    MyChatDatabaseMethods().getGroupInfo(widget.chatRoomId).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print("we got the data + ${chatRooms.toString()} ");
      });
      if (chatRooms != null) {
        userList1 = chatRooms.docs.map((e) => e.data()).toList();
        userList = userList1[0]["userInfo"];
        picUrl = userList1[0]["groupPhotoUrl"] as String;
        groupName = userList1[0]["groupName"];
        currentUser = userList
            .where((i) => i["Mobile"].toString() == ConstCurrentUser.myName)
            .toList();
        print("object");
      }
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 80,
        source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
      isLoading = true;
    });
    getImageInfo(_image);
  }

  var _storageReference;
  Future<String> uploadImageToStorage(File imageFile) async {
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');
    final storageUploadTask = await _storageReference.putFile(imageFile);
    String url = await _storageReference.getDownloadURL();
    print(url);
    return url;
  }

  getImageInfo(File _image) async {
    String url = await uploadImageToStorage(_image);
    print(url);
    setState(() {
      picUrl = url as String;
      isLoading = false;
    });
    var snapshots = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.chatRoomId)
        .get();
    await snapshots
        .then((value) =>
            value.reference.update(<String, dynamic>{"groupPhotoUrl": url}))
        .catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // backgroundColor: Colors.amber,
      body: Container(
        child: CustomScrollView(
          // primary: true,
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 300,
              floating: false,
              elevation: 0.0,
              pinned: true,
              primary: true,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => EditGroupName(
                                  chatRoomId: widget.chatRoomId,
                                )));
                  },
                ),
              ],
              title: Text(groupName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: "pinfon",
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0)),
              backgroundColor: Colors.blue,
              brightness: Brightness.light,
              // bottom: PreferredSize(
              //     preferredSize: Size.fromHeight(15.0),
              //     child: Text(''),
              //   ),
              flexibleSpace: InkWell(
                onTap: getImage,
                child: Stack(
                  children: [
                    new FlexibleSpaceBar(
                      background: Opacity(
                        opacity: 1.0,
                        child: new Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            if (picUrl != null)
                              CachedNetworkImage(
                                imageUrl: picUrl,
                                placeholder: (context, url) => Container(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.fill,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isLoading == true)
                      Positioned(
                        top: 150,
                        left: 150,
                        child: Container(
                          height: 50,
                          width: 50,
                          child: new CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      userList != null
                          ? "${userList.length}" + " Participants"
                          : "0 Participants",
                      style: TextStyle(fontSize: 15, color: Colors.green),
                    ),
                  ),
                )
              ]),
            ),
            if (currentUser != null && currentUser.length != 0)
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AddParticipant(
                                        selection: "group",
                                        chatRoomId: widget.chatRoomId,
                                        userList: userList1[0]["users"],
                                        userInfo: userList,
                                      )));
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                child: CircleAvatar(
                                  child: Icon(
                                      Icons.supervised_user_circle_rounded),
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                "Add Participants",
                                style: TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8, left: 16, right: 16),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                  ),
                ]),
              ),
            Container(
              child: userList == null
                  ? SliverList(
                      delegate: SliverChildListDelegate([]),
                    )
                  : SliverList(
                      delegate: SliverChildListDelegate(userList
                          .map((
                            e,
                          ) =>
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, right: 8, left: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    'https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Text(
                                              e["userName"],
                                              style: TextStyle(fontSize: 20),
                                            )
                                          ],
                                        ),
                                        if (e["admin"])
                                          Container(
                                            // height: 20,
                                            // width: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                "Group Admin",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList()),
                    ),
            ),
            if (currentUser != null)
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 20,
                  color: Colors.grey[200],
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          icon: Icon(
                            currentUser != null && currentUser.length != 0
                                ? Icons.delete
                                : Icons.logout,
                            color: Colors.red,
                          ),
                          onPressed:
                              currentUser != null && currentUser.length != 0
                                  ? () {
                                      FirebaseFirestore.instance
                                          .collection("chatRoom")
                                          .doc(widget.chatRoomId)
                                          .delete();
                                    }
                                  : () async {
                                      var snapshots = FirebaseFirestore.instance
                                          .collection('chatRoom')
                                          .doc(widget.chatRoomId)
                                          .get();
                                      var userInfoList = userList
                                          .where((i) =>
                                              i["userName"] !=
                                              ConstCurrentUser.myName)
                                          .toList();
                                      await snapshots
                                          .then((value) => value.reference
                                                  .update(<String, dynamic>{
                                                'users': FieldValue.arrayRemove(
                                                    [ConstCurrentUser.myName]),
                                                "userInfo": userInfoList
                                              }))
                                          .catchError((onError) {
                                        print(onError);
                                      });
                                    },
                        ),
                        Text(
                          currentUser != null && currentUser.length != 0
                              ? "Delete Group"
                              : "Exit Group",
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 20,
                  color: Colors.grey[200],
                  width: MediaQuery.of(context).size.width,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
