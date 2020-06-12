import 'package:flutter/material.dart';
import 'package:game_app/models/the_trill/trill_core.dart';
import 'package:provider/provider.dart';

class TitleBar extends StatefulWidget {
  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Consumer<TheTrillCore>(builder: (context, trillCore, child) {
      return Row(
        children: <Widget>[
          SizedBox(width: screen.width / 25),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue[100], Colors.blue[200]]),
                borderRadius: BorderRadius.all(
                  Radius.circular(screen.height / 23),
                ),
              ),
              padding: EdgeInsets.all(screen.height / 120),
              child: Column(
                children: <Widget>[
                  Text("Time Left",
                      style: TextStyle(color: Colors.black45, fontSize: 20)),
                  Text(
                    "${trillCore.counter.currCount}",
                    style: TextStyle(fontSize: screen.height / 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: screen.width / 25),
        ],
      );
    });
  }
}
