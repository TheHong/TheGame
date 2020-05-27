import 'package:flutter/material.dart';
import 'package:game_app/components/result_widgets.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/screens/results.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
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
            // Actual Submit button
            Visibility(
              visible: pitchCore.isGameDone,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: FlatButton(
                child: Text("End Game", style: TextStyle(fontSize: 25)),
                onPressed: () {
                  pitchCore.evaluateResult();
                  if (pitchCore.newRank != -1) {
                    // If player gets onto the leaderboard
                    processNewLeaderboardResult(context, pitchCore);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsPage(pitchCore),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
