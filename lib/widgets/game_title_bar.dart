import 'package:game_app/models/game_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameInfo>(
      builder: (context, gameInfo, child) {
        return Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    "Round ${gameInfo.currRound} of ${gameInfo.numRounds}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    "Score: ${(gameInfo.score).toStringAsFixed(3)}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    gameInfo.prompt,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    "${gameInfo.counter.currCount}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
            ),
          ],
        ));
      },
    );
  }
}
