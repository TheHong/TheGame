import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';

class MiniKeyPressor extends StatefulWidget {
  @override
  _MiniKeyPressorState createState() => _MiniKeyPressorState();
}

class _MiniKeyPressorState extends State<MiniKeyPressor> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TheTrillCore>(builder: (context, trillCore, child) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.purpleAccent[100], Colors.purple[200]]),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 60.0, horizontal: 40),
                      child: Text(""),
                    ),
                    onPressed: trillCore.keyboard.isActive
                        ? () {
                            if (!trillCore.isGameStarted) trillCore.run();
                            trillCore.score +=
                                trillCore.keyboard.press(0) ? 1 : 0;
                            trillCore.notifyListeners();
                          }
                        : null,
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 60.0, horizontal: 40),
                      child: Text(""),
                    ),
                    onPressed: trillCore.keyboard.isActive
                        ? () {
                            if (!trillCore.isGameStarted) trillCore.run();
                            trillCore.score +=
                                trillCore.keyboard.press(1) ? 1 : 0;
                            trillCore.notifyListeners();
                          }
                        : null,
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
