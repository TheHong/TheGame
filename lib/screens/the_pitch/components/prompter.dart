import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Prompter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThePitchCore>(builder: (context, pitchCore, child) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 22.0, top: 22.0),
        child: Text(
          pitchCore.prompt,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      );
    });
  }
}
