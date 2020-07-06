import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';

class TestingGround extends StatefulWidget {
  @override
  _TestingGroundState createState() => _TestingGroundState();
}

class _TestingGroundState extends State<TestingGround> {
  String state = "HELLO";
  final Counter counter = Counter();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Testing")),
      body: Column(
        children: <Widget>[
          Text(
            "$state",
            style: TextStyle(fontSize: 50),
          ),
          IconButton(
              onPressed: () {
                counter.stop();
                setState(() {
                  state = "${counter.timeElapsed}s";
                });
              },
              icon: Icon(
                Icons.filter_vintage,
              ))
        ],
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.fingerprint),
        onPressed: () {
          counter.run(10);
        },
      ),
    );
  }
}
