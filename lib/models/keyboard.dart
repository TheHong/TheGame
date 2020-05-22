import 'package:flutter/material.dart';

class Key {
  String value;
  bool isSelected;

  Key({this.value}) {
    isSelected = false;
  }

  Widget getWidget() {
    return FloatingActionButton(
      onPressed: () {},
      child: Text(value),
    );
  }
}

class Keyboard {
  List<Key> keys;
  Key currKey;

  Keyboard() {
    // Define keys here
    keys = [
      Key(value: "A"),
      Key(value: "B"),
    ];
  }

  void select(Key key) {
    // Unselect currently selected key
    currKey.isSelected = false;

    // Select new key
    currKey = key;
    currKey.isSelected = true;
  }
}
