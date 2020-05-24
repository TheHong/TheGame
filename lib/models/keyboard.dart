class SingleKey {
  String value; // Music note value
  int noteID;
  bool isSelected; // Whether or not selected by user
  bool isDisabled; // Whether or not to not display the key

  SingleKey({this.value, this.noteID, this.isDisabled = false}) {
    isSelected = false;
  }
}

class Keyboard {
  List<SingleKey> whiteKeys;
  List<SingleKey> blackKeys;
  SingleKey currKey;
  SingleKey nullKey =
      SingleKey(value: ""); // Key that indicates no music key is selected
  // static const double keyPadding = 0.0; // Padding between keys
  bool _isActive = true;

  Keyboard() {
    // Define keys here
    whiteKeys = [
      SingleKey(value: "C", noteID: 60),
      SingleKey(value: "D", noteID: 62),
      SingleKey(value: "E", noteID: 64),
      SingleKey(value: "F", noteID: 65),
      SingleKey(value: "G", noteID: 67),
      SingleKey(value: "A", noteID: 69),
      SingleKey(value: "B", noteID: 71),
    ];
    blackKeys = [
      SingleKey(value: "C#", noteID: 61),
      SingleKey(value: "D#", noteID: 63),
      SingleKey(value: "E#", noteID: 65, isDisabled: true),
      SingleKey(value: "F#", noteID: 66),
      SingleKey(value: "G#", noteID: 68),
      SingleKey(value: "A#", noteID: 70),
    ];

    // Set initial currKey
    currKey = nullKey;
  }

  void select(SingleKey key) {
    /* Updates SingleKey states based on which key is selected.
    On the keyboard, at most one key is selected. Furthermore, a key can be deselected */

    if (_isActive) {
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

  void reset() {
    currKey.isSelected = false;
    currKey = nullKey;
  }

  void activate() {
    _isActive = true;
  }

  void deactivate() {
    _isActive = false;
  }
}
