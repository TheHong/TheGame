import 'package:flutter/material.dart';
import 'package:game_app/components/endgame_widget.dart';
import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TheTrillCore>(builder: (context, trillCore, child) {
      return Container(
        child: Column(
          children: <Widget>[
            endgameWidget(context, trillCore, Colors.pinkAccent[100]),
          ],
        ),
      );
    });
  }
}
