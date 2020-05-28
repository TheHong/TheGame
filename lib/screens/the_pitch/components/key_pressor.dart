import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/models/the_pitch/keyboard.dart';
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
            // Text(
            //   gameInfo.keyboard.currKey.value,
            //   style: TextStyle(fontSize: 50.0),
            // ),
            createKeyRow(
              keys: pitchCore.keyboard.blackKeys,
              gameInfo: pitchCore,
              isPadLeft: true,
            ),
            createKeyRow(
              keys: pitchCore.keyboard.whiteKeys,
              gameInfo: pitchCore,
              isPadLeft: false,
            )
          ],
        ),
      );
    });
  }

  Widget createKeyRow(
      {List<SingleKey> keys, ThePitchCore gameInfo, bool isPadLeft}) {
    const double paddingLR = 10;
    const double paddingKey = 1;
    double keyDiameter = (MediaQuery.of(context).size.width - 2 * paddingLR) / 7; // 7 white keys
    return Padding(
      padding: const EdgeInsets.fromLTRB(paddingLR, 0, paddingLR, 0),
      child: Container(
        color: gameInfo.isDebugMode ? Colors.black12 : Colors.transparent,
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
                    color: key.isSelected
                        ? Colors.black
                        : Theme.of(context).accentColor,
                    padding: EdgeInsets.zero,
                    child: Text(
                      key.value,
                      style: TextStyle(
                        color: gameInfo.keyboard.isActive
                            ? Colors.white
                            : Colors.blueGrey,
                        fontSize: keyDiameter / 2.75,
                      ),
                    ),
                    onPressed: () {
                      // Submit the first key selected if not submitted yet
                      if (gameInfo.keyboard.isActive) {
                        gameInfo.setSubmitTime(
                            gameInfo.stopwatch.elapsedMicroseconds /
                                pow(10, 6));

                        setState(() {
                          gameInfo.keyboard.select(key);
                          gameInfo.keyboard.deactivate();
                          gameInfo.setSelected(key.isSelected ? key.value : "");
                        });
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
