import 'package:flutter/material.dart';
import 'package:game_app/models/keyboard.dart';

import 'note_player.dart';

class GameInfo extends ChangeNotifier {
  int _numRounds = 3;
  Duration timePerRound = Duration(seconds: 5);
  bool _isRoundActive;

  int score;

  int currRound;
  String currNote;
  String selectedNote;
  bool isSubmitted;

  final notePlayer = NotePlayer();
  final keyboard = Keyboard();

  GameInfo() {
    print("GameInfo initialized!");
    score = 0;
    currRound = 0;
    // run();
  }

  void resetRound() {
    notePlayer.randomizeNote();
    currNote = notePlayer.currNoteAsStr;
    keyboard.reset();
    isSubmitted = false;
    selectedNote = "";
    currRound += 1;
    notifyListeners();
  }

  void incrScore(int addor) {
    score += addor;
    notifyListeners();
  }

  void setSubmitted(bool newSubmit) {
    isSubmitted = newSubmit;
    notifyListeners();
  }

  void setSelected(String newNote) {
    selectedNote = newNote;
    notifyListeners();
  }

  void run() async {
    bool correct;
    for (int i = 0; i < _numRounds; i++) {
      // Prepare for the round
      resetRound();
      _isRoundActive = true;
      print("Round $currRound commencing");
      await Future.delayed(timePerRound, () {
        _isRoundActive = false;
      });

      // Check answer
      correct = currNote == selectedNote;
      print(correct);
    }
    print("Done");
  }
}
