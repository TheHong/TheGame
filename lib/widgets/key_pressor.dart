import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_app/models/game_info.dart';
import 'package:game_app/models/keyboard.dart';
import 'package:provider/provider.dart';

class KeyPressor extends StatefulWidget {
  @override
  _KeyPressorState createState() => _KeyPressorState();
}

class _KeyPressorState extends State<KeyPressor> {
  @override
  Widget build(BuildContext context) {
    print("Created keypressor");
    /* Contains one column with the current key selected, and the two keyboard rows */
    return Consumer<GameInfo>(builder: (context, gameInfo, child) {
      return Container(
        child: Column(
          children: <Widget>[
            Text(
              gameInfo.keyboard.currKey.value,
              style: TextStyle(fontSize: 50.0),
            ),
            createKeyRow(
                keys: gameInfo.keyboard.blackKeys,
                gameInfo: gameInfo,
                leftPadding: 30),
            createKeyRow(
                keys: gameInfo.keyboard.whiteKeys,
                gameInfo: gameInfo,
                leftPadding: 0)
          ],
        ),
      );
    });
  }

  Widget createKeyRow(
      {List<SingleKey> keys, GameInfo gameInfo, double leftPadding}) {
    return Container(
      color: Colors.lightBlueAccent,
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
                width: 60.0, // TODO: Change this so that not hardcoded
                child: FlatButton(
                  onPressed: () {
                    // Submit the first key selected if not submitted yet
                    if (gameInfo.submitTime < 0) {
                      gameInfo.setSubmitTime(
                          gameInfo.stopwatch.elapsedMicroseconds / pow(10, 6));
                      // Navigator.pushNamed(context, '/waiting_page');

                      setState(() {
                        gameInfo.keyboard.select(key);
                        gameInfo.keyboard.deactivate();
                        gameInfo.setSelected(key.isSelected ? key.value : "");
                      });
                    }
                  },
                  child: Text(
                    key.value,
                    style: TextStyle(
                      color: gameInfo.keyboard.isActive ? Colors.blueGrey : Colors.white,
                    ),
                  ),
                  shape: CircleBorder(),
                  color: key.isSelected ? Colors.green : Colors.black,
                ),
              ),
            );
          }),
    );
  }
}
