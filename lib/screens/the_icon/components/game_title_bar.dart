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
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: !iconCore.isGameDone,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "  Round  ",
                          style: TextStyle(fontSize: 10.0),
                        ),
                        Text(
                          "${iconCore.score.toInt()}",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        !iconCore.isGameDone
                            ? !iconCore.isRoundDone ? "${iconCore.prompt}" : ""
                            : "Final Score: ${iconCore.score.toStringAsFixed(0)}",
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !iconCore.isGameDone,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Time Left",
                          style: TextStyle(fontSize: 10.0),
                        ),
                        Text(
                          "${iconCore.counter.currCount}",
                          style: TextStyle(
                              fontSize: 15.0, color: iconCore.counter.colour),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
