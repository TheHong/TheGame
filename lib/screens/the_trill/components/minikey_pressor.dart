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
    Size screen = MediaQuery.of(context).size;
    return Consumer<TheTrillCore>(builder: (context, trillCore, child) {
      return Padding(
        padding:
            EdgeInsets.symmetric(vertical: 0, horizontal: screen.width / 10),
        child: Container(
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.brown[500], Colors.brown[200]]),
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.all(screen.height / 60),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screen.height / 11,
                          horizontal: screen.width / 10),
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
                    width: screen.width / 12,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screen.height / 11,
                          horizontal: screen.width / 10),
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
            ],
          ),
        ),
      );
    });
  }
}
