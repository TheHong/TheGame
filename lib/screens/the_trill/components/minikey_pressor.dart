import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';

class MiniKeyPressor extends StatefulWidget {
  @override
  _MiniKeyPressorState createState() => _MiniKeyPressorState();
}

class _MiniKeyPressorState extends State<MiniKeyPressor> {
  int count = 0;
  BoolInterrupt _isRunPressed = BoolInterrupt(); // Need to use object to pass bool as reference
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
                  getSwipeableButton(0, trillCore, _isRunPressed, screen),
                  SizedBox(
                    width: screen.width / 12,
                  ),
                  getSwipeableButton(1, trillCore, _isRunPressed, screen),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

void _onTrill(TheTrillCore trillCore, BoolInterrupt _isRunPressed, int keyID) {
  print("${trillCore.keyboard.isActive}");
  if (!_isRunPressed.val) {
    _isRunPressed.raise();
    trillCore.run();
  }
  trillCore.score += trillCore.keyboard.press(keyID) ? 1 : 0;
  trillCore.notifyListeners();
}

Widget getSwipeableButton(int keyID,
    TheTrillCore trillCore, BoolInterrupt _isRunPressed, Size screen) {
  return GestureDetector(
    onPanStart: (details) {
      _onTrill(trillCore, _isRunPressed, keyID);
    },
    child: RaisedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screen.height / 11, horizontal: screen.width / 10),
        child: Text(""),
      ),
      onPressed: trillCore.keyboard.isActive
          ? () {
              _onTrill(trillCore, _isRunPressed, keyID);
            }
          : null,
    ),
  );
}
