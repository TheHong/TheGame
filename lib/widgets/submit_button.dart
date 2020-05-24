import 'package:flutter/material.dart';
import 'package:game_app/models/game_info.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameInfo>(builder: (context, gameInfo, child) {
      return Visibility(
        visible: gameInfo.isGameDone,
        child: FlatButton(
          child: Text("End Game", style: TextStyle(fontSize: 25)),
          onPressed: () {
            Navigator.pushNamed(context, '/'); // TODO: Create result page
          },
        ),
      );
    });
  }
}
