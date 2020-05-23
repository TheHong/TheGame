import 'package:game_app/models/game_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameInfo>(
      builder: (context, gameInfo, child) {
        return Container(
            child: Column(
          children: <Widget>[
            Text(
              "Current score: ${gameInfo.score}",
              style: TextStyle(fontSize: 30.0),
            ),
            Text(
              "Chosen (${gameInfo.selectedNote}) | Current (${gameInfo.currNote})",
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              "Submitted (${gameInfo.isSubmitted})",
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ));
      },
    );
  }
}
