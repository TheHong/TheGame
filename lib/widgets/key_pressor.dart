import 'package:flutter/material.dart';
import 'package:game_app/models/keyboard.dart';

class KeyPressor extends StatefulWidget {
  @override
  _KeyPressorState createState() => _KeyPressorState();
}

class _KeyPressorState extends State<KeyPressor> {
  Keyboard keyboard = Keyboard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      child: ListView.builder(
          itemCount: keyboard.keys.length,
          itemBuilder: (context, index) {
            return Text(keyboard.keys[index].value);
          }),
    );
    // return Row(
    //   children: <Widget>[
    //     IconButton(
    //       icon: Icon(Icons.face),
    //       onPressed: () {},
    //     ),
    //     IconButton(
    //       icon: Icon(Icons.airline_seat_recline_extra),
    //       onPressed: () {},
    //     ),
    //   ],
    // );
  }
}
