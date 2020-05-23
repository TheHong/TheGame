import 'package:flutter/material.dart';
import 'package:game_app/models/game_info.dart';
import 'package:game_app/models/keyboard.dart';
import 'package:provider/provider.dart';

class KeyPressor extends StatefulWidget {
  @override
  _KeyPressorState createState() => _KeyPressorState();
}

class _KeyPressorState extends State<KeyPressor> {
  Keyboard keyboard = Keyboard();

  @override
  Widget build(BuildContext context) {
    /* Contains one column with the current key selected, and the two keyboard rows */
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            keyboard.currKey.value,
            style: TextStyle(fontSize: 50.0),
          ),
          createKeyRow(keys: keyboard.blackKeys, leftPadding: 30),
          createKeyRow(keys: keyboard.whiteKeys, leftPadding: 0)
        ],
      ),
    );
  }

  Widget createKeyRow({List<SingleKey> keys, double leftPadding}) {
    return Consumer<GameInfo>(
      builder: (context, gameInfo, child) {
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
                    child: Padding(
                      padding: const EdgeInsets.all(Keyboard.keyPadding),
                      child: FloatingActionButton(
                        onPressed: () {
                          gameInfo.incrScore(1);
                          setState(() {
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
      },
    );
  }
}
