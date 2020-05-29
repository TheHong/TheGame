import 'package:flutter/material.dart';
import 'package:game_app/components/result_widgets.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/screens/results.dart';

Widget endgameWidget(BuildContext context, GameCore gameCore, Color buttonColor) => Visibility(
      visible: gameCore.isGameDone,
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
      child: RaisedButton(
        child: Text("End Game", style: TextStyle(fontSize: 25)),
        color: buttonColor,
        onPressed: () {
          gameCore.evaluateResult();
          if (gameCore.newRank != -1) {
            // If player gets onto the leaderboard
            processNewLeaderboardResult(context, gameCore);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsPage(gameCore),
              ),
            );
          }
        },
      ),
    );
