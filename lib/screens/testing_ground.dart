import 'package:flutter/material.dart';
import 'package:game_app/models/the_icon/icon_models.dart';

class TestingGround extends StatefulWidget {
  @override
  _TestingGroundState createState() => _TestingGroundState();
}

class _TestingGroundState extends State<TestingGround> {
  String state = "HELLO";
  IconList icList = IconList();
  IconGroup icGroup;
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
              icGroup =
                  IconGroup(codepoints: icList.getRandomCodepoints(n: 11));
              setState(() {
                state = "Ready";
              });
            },
          ),
          icGroup != null ? displayGroup(context, icGroup, true) : Container(),
        ],
      ),
      floatingActionButton: IconButton(
        icon: Icon(IconData(currCP, fontFamily: 'MaterialIcons')),
        onPressed: () {
          print("numicons: ${icList.length}");
          List<int> cc = icList.getRandomCodepoints(n: 3);
          print("${cc[0]}");
          setState(() {
            currCP = cc[0];
          });
        },
      ),
    );
  }
}
