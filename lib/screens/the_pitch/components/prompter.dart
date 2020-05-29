import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Prompter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double paddingTB = MediaQuery.of(context).size.height / 23;
    return Consumer<ThePitchCore>(builder: (context, pitchCore, child) {
      return Padding(
        padding: EdgeInsets.only(bottom: paddingTB, top: paddingTB),
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
