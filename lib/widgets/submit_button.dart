import 'package:flutter/material.dart';
import 'package:game_app/models/game_info.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameInfo>(builder: (context, gameInfo, child) {
      return Expanded(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.directions_run),
              iconSize: 50.0,
              color: Colors.greenAccent,
              onPressed: () {
                gameInfo.run();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              iconSize: 30.0,
              color: Colors.greenAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/waiting_page');
              },
            ),
            Visibility(
              visible: gameInfo.isGameDone,
              child: FlatButton(
                child: Text("End Game", style: TextStyle(fontSize: 25)),
                onPressed: () {
                  Navigator.pushNamed(context, '/'); // TODO: Create result page
                },
              ),
            ),
            Visibility(
              visible: gameInfo.isDebugMode,
              child: Text(
                "Chosen: ${gameInfo.selectedNote}\n" +
                    "Current: ${gameInfo.currNote}\n" +
                    "Submit Time: ${gameInfo.submitTime}\n" +
                    "Correct: ${gameInfo.isCorrect}\n" +
                    "Round Complete: ${gameInfo.isRoundDone}\n" +
                    "Game Complete: ${gameInfo.isGameDone}\n",
              ),
            ),
          ],
        ),
      );
    });
  }
}
