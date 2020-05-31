import 'package:flutter/material.dart';
import 'package:game_app/components/endgame_widget.dart';
import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _isRunPressed = false;
    return Consumer<ThePitchCore>(builder: (context, pitchCore, child) {
      return Container(
        child: Column(
          children: <Widget>[
            // Start button
            Visibility(
              visible: !pitchCore.isGameStarted,
              child: RaisedButton(
                child: Text("Begin", style: TextStyle(fontSize: 25)),
                color: Colors.pinkAccent[100],
                onPressed: () {
                  if (!_isRunPressed) {
                    _isRunPressed = true;
                    pitchCore.run();
                  } else {
                    print("Detected double press");
                  }
                },
              ),
            ),
            // End game button
            endgameWidget(context, pitchCore, Colors.pinkAccent[100]),
          ],
        ),
      );
    });
  }
}
