import 'package:flutter/material.dart';
import 'package:game_app/components/endgame_widget.dart';
import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThePitchCore>(builder: (context, pitchCore, child) {
      return Container(
        child: Column(
          children: <Widget>[
            // Debug Info
            Visibility(
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              visible: pitchCore.isDebugMode,
              child: Text(
                pitchCore.getDebugInfo(),
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
            // Start button
            Visibility(
              visible: !pitchCore.isGameStarted,
              child: FlatButton(
                child: Text("Begin", style: TextStyle(fontSize: 25)),
                onPressed: () {
                  pitchCore.run();
                },
              ),
            ),
            endgameWidget(context, pitchCore),
          ],
        ),
      );
    });
  }
}
