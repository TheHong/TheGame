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
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
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
                gameInfo.getDebugInfo(),
                style: TextStyle(
                  fontSize: 8,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
