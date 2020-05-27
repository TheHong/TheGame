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
              leftPadding: 30,
            ),
            createKeyRow(
              keys: pitchCore.keyboard.whiteKeys,
              gameInfo: pitchCore,
              leftPadding: 0,
            )
          ],
        ),
      );
    });
  }

  Widget createKeyRow(
      {List<SingleKey> keys, ThePitchCore gameInfo, double leftPadding}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        color: gameInfo.isDebugMode ? Colors.black12 : Colors.transparent,
        height: 50.0,
        padding: EdgeInsets.only(left: leftPadding),
        // Iterating through keys and building the buttons
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: keys.length,
            itemBuilder: (context, index) {
              SingleKey key = keys[index];
              return Visibility(
                // To deactivate the disabled keys (e.g. E# key)
                visible: !key.isDisabled,
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                child: Container(
                  width: 55.0, // TODO: Change this so that not hardcoded (use MediaQuery)
                  child: FlatButton(
                    shape: CircleBorder(),
                    color: key.isSelected
                        ? Colors.black
                        : Theme.of(context).accentColor,
                    child: Text(
                      key.value,
                      style: TextStyle(
                        color: gameInfo.keyboard.isActive
                            ? Colors.white
                            : Colors.blueGrey,
                      ),
                    ),
                    onPressed: () {
                      // Submit the first key selected if not submitted yet
                      if (gameInfo.keyboard.isActive) {
                        gameInfo.setSubmitTime(
                            gameInfo.stopwatch.elapsedMicroseconds / pow(10, 6));

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

