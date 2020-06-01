import 'package:flutter/material.dart';
import 'package:game_app/components/result_widgets.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/screens/results_screen.dart';

Widget endgameWidget(
        BuildContext context, GameCore gameCore, Color buttonColor) =>
    Visibility(
      visible: gameCore.isGameDone,
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("End Game", style: TextStyle(fontSize: 25)),
            color: buttonColor,
            onPressed: () {
              if (gameCore.isResultsActivated) {
                gameCore.evaluateResult();
                if (!gameCore.isStatsUpdated) {
                  gameCore.databaseService.updateStats(gameCore.getGameName());
                  gameCore.isStatsUpdated = true;
                }
              } else {
                print("Results not updated");
              }
              if (gameCore.newRank != -1 && gameCore.isResultsActivated) {
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
          Visibility(
            visible: !gameCore.isResultsActivated,
            child: Text("Result Updates are Currently Unavailable",
                style: TextStyle(fontSize: 10, color: Colors.black38)),
          )
        ],
      ),
    );
