import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:game_app/models/keyboard.dart';

class KeyPressor extends StatefulWidget {
  @override
  _KeyPressorState createState() => _KeyPressorState();
}

class _KeyPressorState extends State<KeyPressor> {
  Keyboard keyboard = Keyboard();

  Widget createKeyRow(List<SingleKey> keys, double leftPadding) {
    return Container(
        color: Colors.lightBlueAccent,
        height: 50.0,
        padding: EdgeInsets.only(left: leftPadding),
        // Iterating through keys
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: keys.length,
            itemBuilder: (context, index) {
              SingleKey key = keys[index];
              return Visibility(
                visible: !key.isDisabled,
                maintainSize: true,
                maintainState: true,
                maintainAnimation: true,
                child: Padding(
                  padding: const EdgeInsets.all(Keyboard.keyPadding),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        print("HI");
                        keyboard.select(key);
                      });
                    },
                    child: Text(key.value),
                    backgroundColor:
                        key.isSelected ? Colors.green : Colors.black,
                  ),
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          createKeyRow(keyboard.blackKeys, 30),
          createKeyRow(keyboard.whiteKeys, 0)
        ],
      ),
    );
  }
}
