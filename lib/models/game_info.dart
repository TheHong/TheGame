
import 'package:flutter/material.dart';

class GameInfo extends ChangeNotifier {
  int score;

  int currRound;
  String currNoteAsStr;
  bool isRoundActive;
  bool isSubmitted;

  GameInfo() {
    score = 0;
    isRoundActive = true;
    isSubmitted = false;
    currRound = 0;
    currNoteAsStr = "";
  }

  void setSubmit(bool newSubmit) {
    isSubmitted = newSubmit;
    notifyListeners();
  }

  void incrScore(int addor) {
    score += addor;
    notifyListeners();
  }
}