import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MTest2 extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<MTest2> {
  var userStatus = List<bool>();

  Future<List<User>> _getUsers() async {
    var data = await http
        .get("https://www.json-generator.com/api/json/get/cdjVKlMEde?indent=2");

    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u["index"], u["favoriteFruit"]);

      users.add(user);
      userStatus.add(false);
    }

    print(users.length);

    return users;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select City'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 8),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              userStatus[index] = !userStatus[index];
                            });
                          },
                          child: userStatus[index]
                              ? Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.blue,
                                  size: 20,
                                )
                              : Icon(
                                  Icons.radio_button_unchecked,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                        ),
                        SizedBox(width: 5),
                        Text(snapshot.data[index].name),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class User {
  final int index;
  final String name;

  User(this.index, this.name);
}
