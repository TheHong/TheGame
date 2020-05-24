import 'package:flutter/material.dart';
import 'package:game_app/models/keyboard.dart';

import 'note_player.dart';

class GameInfo extends ChangeNotifier {
  static int _numRounds = 3;
  static int timePerRound = 5;
  static int timePerPreparation = 3;

  double score;

  // TODO: Organize these vars and determine their inactive values
  // TODO: Privatize if needed
  int currRound;
  String currNote;
  String selectedNote;
  double submitTime = -1;
  String prompt = "Get Ready!";
  bool isCorrect = false;
  bool isResultDecided = false;
  bool isGameDone = false;

  final notePlayer = NotePlayer();
  final keyboard = Keyboard();
  final counter = Counter(); // To get time to be displayed
  final stopwatch = Stopwatch(); // To measure time

  GameInfo() {
    print("GameInfo initialized!");
    score = 0;
    currRound = 0;
    // run();
  }

  void resetRound() {
    isResultDecided = false;
    notePlayer.randomizeNote();
    currNote = notePlayer.currNoteAsStr;
    keyboard.reset();
    selectedNote = "";
    submitTime = -1;
    currRound += 1;
    prompt = "Get Ready!";
    notifyListeners();
  }

  void run() async {
    for (int i = 0; i < _numRounds; i++) {
      // Prepare for the round
      resetRound();

      // Prepare user for the round
      // TODO: Prevent user from guessing before round even begins
      await counter.run(timePerPreparation, notifyListeners);

      // Round begins
      print("Round $currRound commencing");
      prompt = "GO!";
      notifyListeners();
      notePlayer.play();
      stopwatch.start();
      await counter.run(timePerRound, notifyListeners);
      print(stopwatch.elapsedMicroseconds);
      stopwatch.stop();
      stopwatch.reset();
      
      // Check answer
      if (submitTime == -1 || currNote != selectedNote){ // No answer was submitted or the answer is incorrect
        score += 0;
        isCorrect = false;
        prompt = "Incorrect!";
      }else{
        score += timePerRound - submitTime;
        isCorrect = true;
        prompt = "Correct!";
      }
      isResultDecided = true;
      isGameDone = i + 1 == _numRounds;
      notifyListeners();

      // Pause for user to get result feedback (happening in the waiting_page)
      await counter.run(3, false);
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
}

class Counter {
  /* Starts counting down at startCount - 1 */
  int _currCount=0;
  int get currCount => _currCount;
  set currCount(int num) => num;

  Future run (int startCount, dynamic notifier) async {
    for (int i = startCount - 1; i >= 0; i--) {
      _currCount = i;
      if (notifier is Function){
        notifier();
      }
      await Future.delayed(Duration(seconds:1), () {});
    }
  }
}

