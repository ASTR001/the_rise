import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_rise/Chat/GroupChat/GroupInfo.dart';

class EditGroupName extends StatefulWidget {
  final String chatRoomId;

  const EditGroupName({Key key, this.chatRoomId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditGroupNameState();
  }
}

class _EditGroupNameState extends State<EditGroupName> {
  TextEditingController _contrller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  changeName() async {
    if (formKey.currentState.validate()) {
      var snapshots = FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .get();
      await snapshots
          .then((value) => value.reference
              .update(<String, dynamic>{"groupName": _contrller.text}))
          .catchError((onError) {
        print(onError);
      });
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MyGroupInfo(
                    chatRoomId: widget.chatRoomId,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter new subject"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _contrller,
                  decoration: InputDecoration(hintText: "Enter subject"),
                  validator: (val) {
                    return val.isEmpty ? "Enter subject" : null;
                  },
                ),
                Row(
                  children: [
                    RaisedButton(
                      child: Text("Save"),
                      onPressed: changeName,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
