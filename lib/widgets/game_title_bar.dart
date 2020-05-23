import 'package:game_app/models/game_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameInfo>(
      builder: (context, gameInfo, child) {
        print("Current score = ${gameInfo.score}");
        return Container(
            child: Text(
          "Current score: ${gameInfo.score}",
          style: TextStyle(fontSize: 30.0),
        ));
      },
    );
  }
}
