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
              "Current score: ${(gameInfo.score).toStringAsFixed(3)}",
              style: TextStyle(fontSize: 30.0),
            ),
            Text(
              gameInfo.prompt,
              style: TextStyle(fontSize: 30.0),
            ),
          ],
        ));
      },
    );
  }
}
