import 'package:game_app/components/custom_buttons.dart';
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
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).backgroundColor,
                      Colors.white
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: !iconCore.isGameDone
                      ? Column(
                          children: <Widget>[
                            Text(
                              "Round ${iconCore.score.toInt()}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${iconCore.rememberTime}s Rem.",
                              style: TextStyle(
                                fontSize: 12.5,
                                color: iconCore.phase == Phase.REMEMBER
                                    ? Colors.blueGrey[800]
                                    : Colors.blueGrey,
                              ),
                            ),
                            Text(
                              "${iconCore.recallTime}s Rec.",
                              style: TextStyle(
                                fontSize: 12.5,
                                color: iconCore.phase == Phase.RECALL
                                    ? Colors.blueGrey[800]
                                    : Colors.blueGrey,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "Final Score: ${iconCore.score.toStringAsFixed(0)}",
                          style: TextStyle(fontSize: 30.0)),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible:
                      [Phase.REMEMBER, Phase.RECALL].contains(iconCore.phase),
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: OneShotButton(
                    child: Column(
                      children: <Widget>[
                        Text("${iconCore.prompt}"),
                        Text(
                          iconCore.counter.isShow
                              ? "${iconCore.counter.currCount}"
                              : "",
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          "${iconCore.buttonPrompt}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black26,
                          ),
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    color: Colors.deepPurple[200],
                    onPressed: iconCore.phase == Phase.REMEMBER
                        ? () {
                            iconCore.boolInterrupt.raise();
                          }
                        : null,
                  ),
                ),
              ],
            ));
      },
    );
  }
}
