import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';

class InstructionsPage extends StatelessWidget {
  GameCore gameCore;
  InstructionsPage(this.gameCore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Instructions for ${gameCore.getGameName()}"),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Text(
          gameCore.getInstructions(),
        ),
      ),
    );
  }
}
