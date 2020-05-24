import 'package:flutter/material.dart';
import 'package:game_app/models/game_info.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameInfo>(builder: (context, gameInfo, child) {
      return Container(
        child: Row(
          children: <Widget>[
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
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
