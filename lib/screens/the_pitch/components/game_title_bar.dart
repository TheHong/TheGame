import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThePitchCore>(
      builder: (context, gameInfo, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Theme.of(context).backgroundColor, Colors.white]),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: !gameInfo.isGameDone,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Round",
                          style: TextStyle(fontSize: 10.0),
                        ),
                        Text(
                          "${gameInfo.currRound} of ${gameInfo.numRounds}",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        !gameInfo.isGameDone
                            ? "${gameInfo.counter.currCount}"
                            : "Final Score: ${gameInfo.score.toStringAsFixed(3)}",
                        style: TextStyle(fontSize: 30.0, color: gameInfo.counter.colour),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !gameInfo.isGameDone,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Score",
                          style: TextStyle(fontSize: 10.0),
                        ),
                        Text(
                          "${gameInfo.score.toStringAsFixed(3)}",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
