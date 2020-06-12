import 'package:flutter/material.dart';
import 'package:game_app/models/the_icon/icon_list.dart';

class TestingGround extends StatefulWidget {
  @override
  _TestingGroundState createState() => _TestingGroundState();
}

class _TestingGroundState extends State<TestingGround> {
  String state = "HELLO";
  IconList icList = IconList();
  int currCP = 59692;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Testing")),
      body: Column(
        children: <Widget>[
          Text(
            state,
            style: TextStyle(fontSize: 50),
          ),
          IconButton(
            icon: Icon(Icons.disc_full),
            onPressed: () async {
              await icList.loadIconInfo();
              setState(() {
                state = "Ready";
              });
            },
          )
        ],
      ),
      floatingActionButton: IconButton(
        icon: Icon(IconData(currCP, fontFamily: 'MaterialIcons')),
        onPressed: () {
          print("numicons: ${icList.length}");
          List<int> cc = icList.getRandomCodepoints(n: 2);
          print("${cc[0]}");
          setState(() {
            currCP = cc[0];
          });
        },
      ),
    );
  }
}
