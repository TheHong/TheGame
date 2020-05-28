import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';

class TitleBar extends StatefulWidget {
  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TheTrillCore>(builder: (context, trillCore, child) {
      return Row(
        children: <Widget>[
          SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue[100], Colors.blue[200]]),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Text("Time Left",
                      style: TextStyle(color: Colors.black45, fontSize: 20)),
                  Text(
                    "${trillCore.counter.currCount}",
                    style: TextStyle(fontSize: 50),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      );
    });
  }
}
