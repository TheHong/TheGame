import 'package:flutter/material.dart';
import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/components/endgame_widget.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:provider/provider.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TheIconCore>(builder: (context, iconCore, child) {
      return Container(
        child: Column(
          children: <Widget>[
            // Start button
            Visibility(
              visible: iconCore.phase == Phase.PRE_GAME,
              child: OneShotButton(
                child: Text("Begin", style: TextStyle(fontSize: 25)),
                color: Colors.pinkAccent[100],
                onPressed: () {
                  iconCore.game();
                },
              ),
            ),
            Visibility(
              visible: [Phase.REMEMBER, Phase.RECALL].contains(iconCore.phase),
              child: OneShotButton(
                child: Column(
                  children: <Widget>[
                    Text("${iconCore.prompt}"),
                    Text("${iconCore.counter.currCount}",
                        style: TextStyle(fontSize: 25)),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 5.0),
                color: Colors.pinkAccent[100],
                onPressed: () {
                  iconCore.boolInterrupt.raise();
                },
              ),
            ),
            // End game button
            endgameWidget(context, iconCore, Colors.pinkAccent[100]),
          ],
        ),
      );
    });
  }
}