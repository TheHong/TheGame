import 'package:game_app/models/the_pitch/pitch_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTitleBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThePitchCore>(
      builder: (context, pitchCore, child) {
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
                    visible: !pitchCore.isGameDone,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Round",
                          style: TextStyle(fontSize: 10.0),
                        ),
                        Text(
                          "${pitchCore.currRound} of ${pitchCore.numRounds}",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        !pitchCore.isGameDone
                            ? !pitchCore.isRoundDone
                                ? "${pitchCore.counter.currCount}"
                                : ""
                            : "Final Score: ${pitchCore.score.toStringAsFixed(3)}",
                        style: TextStyle(
                            fontSize: 30.0, color: pitchCore.counter.colour),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !pitchCore.isGameDone,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Score",
                          style: TextStyle(fontSize: 10.0),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              !pitchCore.isRoundDone
                                  ? "${pitchCore.score.toStringAsFixed(3)}"
                                  : "${(pitchCore.score - pitchCore.scoreChange).toStringAsFixed(3)}",
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Visibility(
                              visible: pitchCore.isRoundDone,
                              child: Text(
                                  " + ${pitchCore.scoreChange.toStringAsFixed(pitchCore.getNumDecPlaces())}",
                                  style: TextStyle(
                                    color: pitchCore.isCorrect
                                        ? Colors.lightGreenAccent[700]
                                        : Colors.redAccent[700],
                                  )),
                            )
                          ],
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
