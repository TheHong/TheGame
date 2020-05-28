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
            // Debug Info
            Visibility(
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              visible: trillCore.isDebugMode,
              child: Text(
                trillCore.getDebugInfo(),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            // Actual Submit button
            endgameWidget(context, trillCore),
          ],
        ),
      );
    });
  }
}
