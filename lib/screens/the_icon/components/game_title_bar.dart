import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Consumer<TheIconCore>(
      builder: (context, iconCore, child) {
        return Padding(
            padding: EdgeInsets.only(
              left: screen.width / 22.5,
              right: screen.width / 22.5,
              bottom: screen.height / 40,
              top: 0,
            ),
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
                  padding: EdgeInsets.symmetric(
                    vertical: screen.height / 49,
                    horizontal: screen.width / 18,
                  ),
                  child: !iconCore.isGameDone
                      ? Column(
                          children: <Widget>[
                            Text(
                              "Round ${iconCore.currRound}",
                              style: TextStyle(
                                fontSize: screen.height / 29.6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screen.height / 74),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  addPointPad(
                                    "${iconCore.rememberTime}s Rem.",
                                    iconCore.phase == Phase.REMEMBER,
                                    iconCore.phase,
                                  ),
                                  style: TextStyle(
                                    fontSize: screen.height / 47.4,
                                    color: iconCore.phase == Phase.REMEMBER
                                        ? Colors.blueGrey[800]
                                        : Colors.blueGrey[200],
                                  ),
                                ),
                                Text(
                                  iconCore.bonusTime > 0
                                      ? "+${iconCore.bonusTime.toStringAsFixed(1)}s"
                                      : "",
                                  style: TextStyle(
                                    fontSize: screen.height / 47.4,
                                    color: iconCore.phase == Phase.REMEMBER
                                        ? Colors.green
                                        : Colors.blueGrey[200],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              addPointPad(
                                "${iconCore.recallTime}s Rec.",
                                iconCore.phase == Phase.RECALL,
                                iconCore.phase,
                              ),
                              style: TextStyle(
                                fontSize: screen.height / 47.4,
                                color: iconCore.phase == Phase.RECALL
                                    ? Colors.blueGrey[800]
                                    : Colors.blueGrey[200],
                              ),
                            ),
                          ],
                        )
                      : Text(
                          "Final Score: ${iconCore.score.toStringAsFixed(0)}",
                          style: TextStyle(fontSize: screen.height / 19.7)),
                ),
                SizedBox(
                  height: screen.height / 40,
                ),
                Visibility(
                  visible: [
                    Phase.PRE_ROUND,
                    Phase.REMEMBER,
                    Phase.RECALL,
                    Phase.EVALUATE
                  ].contains(iconCore.phase) && !iconCore.isGameDone,
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
                          style: TextStyle(fontSize: screen.height / 23.7),
                        ),
                        Text(
                          "${iconCore.buttonPrompt}",
                          style: TextStyle(
                            fontSize: screen.height / 59.2,
                            color: Colors.black26,
                          ),
                        )
                      ],
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: screen.height / 118),
                    color: Colors.deepPurple[200],
                    disabledColor: Colors.deepPurple[200],
                    disabledTextColor: Colors.black,
                    onPressed: iconCore.phase == Phase.PRE_ROUND
                        ? null
                        : () {
                            iconCore.counter.stop();
                          },
                  ),
                ),
              ],
            ));
      },
    );
  }
}

String addPointPad(String text, bool isAdd, Phase phase) =>
    [Phase.PRE_GAME].contains(phase) ? "" : isAdd ? "> " + text + "  " : text;
