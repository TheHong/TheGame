import 'package:flutter/material.dart';
import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/components/endgame_widget.dart';
import 'package:game_app/models/the_pitch/pitch_core.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThePitchCore>(builder: (context, pitchCore, child) {
      return Container(
        child: Column(
          children: <Widget>[
            // Start button
            Visibility(
              visible: !pitchCore.isGameStarted,
              child: OneShotButton(
                child: Text("Begin", style: TextStyle(fontSize: 25)),
                color: Colors.pinkAccent[100],
                onPressed: () {
                  pitchCore.run();
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
