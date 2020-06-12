import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_app/models/the_pitch/keyboard.dart';
import 'package:game_app/models/the_pitch/pitch_core.dart';
import 'package:provider/provider.dart';

class KeyPressor extends StatefulWidget {
  @override
  _KeyPressorState createState() => _KeyPressorState();
}

class _KeyPressorState extends State<KeyPressor> {
  @override
  Widget build(BuildContext context) {
    /* Contains one column with the current key selected, and the two keyboard rows */
    return Consumer<ThePitchCore>(builder: (context, pitchCore, child) {
      return Container(
        child: Column(
          children: <Widget>[
            createKeyRow(
              keys: pitchCore.keyboard.blackKeys,
              pitchCore: pitchCore,
              isPadLeft: true,
            ),
            createKeyRow(
              keys: pitchCore.keyboard.whiteKeys,
              pitchCore: pitchCore,
              isPadLeft: false,
            )
          ],
        ),
      );
    });
  }

  Widget createKeyRow(
      {List<SingleKey> keys, ThePitchCore pitchCore, bool isPadLeft}) {
    const double paddingLR = 10; // Does not adapt with screen size
    const double paddingKey = 1; // Does not adapt with screen size
    double keyDiameter =
        (MediaQuery.of(context).size.width - 2 * paddingLR) / 7; // 7 white keys
    return Padding(
      padding: const EdgeInsets.fromLTRB(paddingLR, 0, paddingLR, 0),
      child: Container(
        color: pitchCore.isDebugMode ? Colors.black12 : Colors.transparent,
        height: 50.0,
        padding: EdgeInsets.only(left: isPadLeft ? keyDiameter / 2 : 0),
        // Iterating through keys and building the buttons
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: keys.length,
            itemBuilder: (context, index) {
              SingleKey key = keys[index];
              return Visibility(
                // To hide the disabled keys (e.g. E# key)
                visible: !key.isDisabled,
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                child: Container(
                  width: keyDiameter,
                  padding: EdgeInsets.all(paddingKey),
                  child: FlatButton(
                    shape: CircleBorder(),
                    color: key.specialColor != -1
                        ? key.specialColor
                        : (key.isSelected
                            ? Colors.black
                            : Theme.of(context).accentColor),
                    padding: EdgeInsets.zero,
                    child: Text(
                      key.value,
                      style: TextStyle(
                        // User can play notes before game starts and during game
                        color: pitchCore.keyboard.isActive ||
                                !pitchCore.isGameStarted
                            ? Colors.white
                            : Colors.blueGrey,
                        fontSize: keyDiameter / 2.75,
                      ),
                    ),
                    onPressed: () {
                      // Submit the first key selected if not submitted yet
                      if (pitchCore.keyboard.isActive) {
                        pitchCore.setSubmitTime(
                            pitchCore.stopwatch.elapsedMicroseconds /
                                pow(10, 6));

                        setState(() {
                          pitchCore.keyboard.select(key);
                          pitchCore.keyboard.deactivate();
                          pitchCore
                              .setSelected(key.isSelected ? key.value : "");
                          pitchCore.boolInterrupt.raise(); // To stop the counter
                        });
                      } else if (!pitchCore.isGameStarted) {
                        // User can play notes before game starts
                        pitchCore.notePlayer.playNote(key.noteID);
                      }
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}
