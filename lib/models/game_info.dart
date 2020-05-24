import 'package:flutter/material.dart';
import 'package:game_app/models/keyboard.dart';

import 'note_player.dart';

class GameInfo extends ChangeNotifier {
  static int _numRounds = 3;
  static int _timePerRound = 5; // Duration of each round
  static int _timePerPreparation =
      3; // Duration of the countdown to the start of the round
  static int _timePerEnd =
      3; // Duration at the end of each round before the countdown of next round
  static Map _prompts = {
    "prep": "Get Ready!",
    "game": "GO!",
    "correct": "Correct!",
    "incorrect": "Incorrect!",
  };

  int get numRounds => _numRounds;

  // TODO: Privatize if needed
  double score = 0.0;
  int currRound = 0;
  String currNote = ""; // Current note to be identified
  String selectedNote = ""; // Note selected by player

  double submitTime = -1; // Point in the COUNTDOWN that answer was submitted
  String prompt =
      _prompts["prep"]; // Prompt to inform player of the current game status

  bool isCorrect = false; // Is the submitted answer correct
  bool isRoundDone = false; // Is the round completed
  bool isGameDone = false; // Are all the rounds completed

  bool isDebugMode = false;

  final notePlayer = NotePlayer(); // To play the tones
  final keyboard = Keyboard(); // Contains the information of the keys
  final counter = Counter(); // To get time to be displayed
  final stopwatch = Stopwatch(); // To measure time

  GameInfo() {
    print("GameInfo initialized!");
  }

  void run() async {
    for (int i = 0; i < _numRounds; i++) {
      // Prepare for the round ------------------------------------------------
      // Prevent user from guessing before round even begins
      keyboard.deactivate();

      // Reset variables
      isRoundDone = false;
      keyboard.reset();
      selectedNote = "";
      submitTime = -1;

      // Update variables
      prompt = _prompts["prep"];
      currRound += 1;

      // Get new note
      notePlayer.randomizeNote();
      currNote = notePlayer.currNoteAsStr;
      keyboard.reset();
      notifyListeners();

      // Counts down for the user right before round begins
      // The above changes are updated in the widgets using notifyLIsteners
      await counter.run(_timePerPreparation, notifyListeners);

      // Round ----------------------------------------------------------------
      // Start Round
      print("Round $currRound commencing");
      prompt = _prompts["game"];
      notifyListeners();

      // Play the note for player automatically
      notePlayer.play();

      // Give user time to choose
      keyboard.activate();
      stopwatch
          .start(); // Used in another widget to get the exact time user submits
      await counter.run(_timePerRound, notifyListeners);
      print(stopwatch.elapsedMicroseconds);
      stopwatch.stop();
      stopwatch.reset();
      keyboard.deactivate();

      // Evaluation -----------------------------------------------------------
      // No answer was submitted or the answer is incorrect
      if (submitTime == -1 || currNote != selectedNote) {
        score += 0;
        isCorrect = false;
        prompt = "Incorrect!";
      } else {
        score += _timePerRound - submitTime;
        isCorrect = true;
        prompt = "Correct!";
      }
      isRoundDone = true;
      isGameDone = i + 1 == _numRounds;
      notifyListeners();

      // Pause for user to get result feedback --------------------------------
      await counter.run(_timePerEnd, false);
    }
    print("Done");
  }

  // void incrScore(int addor) {
  //   score += addor;
  //   notifyListeners();
  // }

  void setSubmitTime(double newSubmit) {
    submitTime = newSubmit;
    notifyListeners();
  }

  void setSelected(String newNote) {
    selectedNote = newNote;
    notifyListeners();
  }

  String getDebugInfo() {
    return "Chosen: $selectedNote\n" +
        "Current: $currNote\n" +
        "Keyboard Active: ${keyboard.isActive}\n" +
        "Submit Time: $submitTime\n" +
        "Correct: $isCorrect\n" +
        "Round Complete: $isRoundDone}\n" +
        "Game Complete: $isGameDone\n";
  }
}

class Counter {
  /* Starts counting down at startCount - 1 */
  int _currCount = 0;
  int get currCount => _currCount;
  set currCount(int num) => num;

  Future run(int startCount, dynamic notifier) async {
    for (int i = startCount - 1; i >= 0; i--) {
      // _currCount is only updated if other widgets are notified
      if (notifier is Function) {
        _currCount = i;
        notifier();
      }
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }
}
