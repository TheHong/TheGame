import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';


class ResultsPage extends StatelessWidget {
  final GameCore gameCore;
  ResultsPage(this.gameCore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("${gameCore.score}"),
    );
  }
}
