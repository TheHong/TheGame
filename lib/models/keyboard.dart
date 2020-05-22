import 'package:flutter/material.dart';

class SingleKey {
  String value;
  bool isSelected;
  bool isDisabled;

  SingleKey({this.value, this.isDisabled=false}) {
    isSelected = false;
  }
}

class Keyboard {
  List<SingleKey> whiteKeys;
  List<SingleKey> blackKeys;
  SingleKey currKey;
  SingleKey nullKey = SingleKey(value: "NULL");
  static const double keyPadding = 1.0;

  Keyboard() {
    // Define keys here
    whiteKeys = [
      SingleKey(value: "C"),
      SingleKey(value: "D"),
      SingleKey(value: "E"),
      SingleKey(value: "F"),
      SingleKey(value: "G"),
      SingleKey(value: "A"),
      SingleKey(value: "B"),
    ];

    blackKeys = [
      SingleKey(value: "C#"),
      SingleKey(value: "D#"),
      SingleKey(value: "E#", isDisabled: true),
      SingleKey(value: "F#"),
      SingleKey(value: "G#"),
      SingleKey(value: "A#"),
    ];

    // Set initial currKey
    currKey = nullKey;
  }

  void select(SingleKey key) {
    // Case 1: No key has been previously selected
    if (currKey == nullKey) {
      currKey = key;
      currKey.isSelected = true;

      // Case 2: A key has been selected
    } else {
      // Deselect if pressing on selected key
      if (currKey == key) {
        currKey.isSelected = false;
        currKey = nullKey;

        // Select if pressing on unselected key
      } else {
        currKey.isSelected = false;
        key.isSelected = true;
        currKey = key;
      }
    }
  }
}
