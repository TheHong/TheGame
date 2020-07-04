import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TheIconCore>(
      builder: (context, iconCore, child) {
        return Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 16.0, top: 0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Theme.of(context).backgroundColor, Colors.white]),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                !iconCore.isGameDone
                    ? "ROUND ${iconCore.score.toInt()}"
                    : "Final Score: ${iconCore.score.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 20.0),
              ),
            ));
      },
    );
  }
}
