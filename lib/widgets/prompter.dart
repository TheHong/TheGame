import 'package:game_app/models/game_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Prompter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameInfo>(builder: (context, gameInfo, child) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          gameInfo.prompt,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
    });
  }
}
