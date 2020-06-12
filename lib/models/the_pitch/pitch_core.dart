import 'package:flutter/material.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/models/the_pitch/keyboard.dart';
import 'package:game_app/models/the_pitch/note_player.dart';

class ThePitchCore extends GameCore {
  static final int _numRounds = Constant.NUM_ROUNDS_PITCH;
  static final int _timePerRound = Constant.TIME_PER_ROUND_PITCH;
  static final int _timePerRoundStart = Constant.TIME_PER_ROUND_START_PITCH;
  static final int _timePerRoundEnd = Constant.TIME_PER_ROUND_END_PITCH;
  static final Map _prompts = {
    "loading": "Game is loading...",
    "prep": "Get Ready!",
    "game": "GO!",
    "correct": "Correct!",
    "incorrect": "Incorrect!",
  };

  int get numRounds => _numRounds;
  int currRound = 0;
  String currNote = ""; // Current note to be identified
  String selectedNote = ""; // Note selected by player

  double submitTime = -1; // Point in the COUNTDOWN that answer was submitted

  bool isCorrect = false; // Is the submitted answer correct
  double scoreChange = 0;
  double additionalScore = 0; // WIll count how many correct

  final notePlayer = NotePlayer(); // To play the tones
  final keyboard = Keyboard(); // Contains the information of the keys
  final stopwatch = Stopwatch(); // To measure time

  String getGameName() => "The Pitch";
  String getGamePath() => "/the_pitch";
  int getNumDecPlaces() => 3;
  String getInstructions() => Constant.INSTRUCTIONS_PITCH;

  ThePitchCore() {
    print("$this Initiated");
  }

  @override
  Future game() async {
    // Prepare for the game ---------------------------------------------------
    isGameStarted = true;

    for (int i = 0; i < _numRounds; i++) {
      // Prepare for the round ------------------------------------------------
      // Prevent user from guessing before round even begins
      keyboard.deactivate();

      // Reset variables
      isRoundDone = false;
      keyboard.reset();
      selectedNote = "";
      submitTime = -1;
      scoreChange = 0;
      boolInterrupt.reset();

      // Update variables
      prompt = _prompts["prep"];
      currRound += 1;

      // Get new note
      notePlayer.randomizeNote();
      currNote = notePlayer.currNoteAsStr;
      keyboard.reset();
      notifyListeners();

      // Counts down for the user right before round begins
      await counter.run(_timePerRoundStart,
          notifier: notifyListeners, isRedActive: false);

      // Round ----------------------------------------------------------------
      // Just in case this async function does not end when game abruptly ends
      if (isGameDone) {
        print("Run process came to abrupt end.");
        break;
      }

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
      await counter.run(_timePerRound,
          notifier: notifyListeners, boolInterrupt: boolInterrupt);
      print(stopwatch.elapsedMicroseconds);
      stopwatch.stop();
      stopwatch.reset();
      keyboard.deactivate();

      // Evaluation -----------------------------------------------------------
      // No answer was submitted or the answer is incorrect
      if (submitTime == -1 || currNote != selectedNote) {
        scoreChange =
            0; // This and the next line are not needed. They are just for clarity
        score += scoreChange;
        isCorrect = false;
        keyboard.currKey.specialColor = Colors.red;
        keyboard.keysByNote[currNote].specialColor = Colors.green;
        prompt = "Incorrect!";
      } else {
        scoreChange = _timePerRound - submitTime;
        score += scoreChange;
        isCorrect = true;
        keyboard.currKey.specialColor = Colors.green;
        additionalScore += 1; // num_correct
        prompt = "Correct!";
      }
      isRoundDone = true;
      notifyListeners();

      // Pause for user to get result feedback --------------------------------
      await counter.run(_timePerRoundEnd);
    }
    print("The Pitch Game Completed");
    isGameDone = true;
    prompt = "";
    notifyListeners();
  }

  void setSubmitTime(double newSubmit) {
    submitTime = newSubmit;
    notifyListeners();
  }

  void setSelected(String newNote) {
    selectedNote = newNote;
    notifyListeners();
  }

  @override
  String getDebugInfo() {
    return "Chosen: $selectedNote\n" +
        "Current: $currNote\n" +
        "Keyboard Active: ${keyboard.isActive}\n" +
        "Submit Time: $submitTime\n" +
        "Correct: $isCorrect\n" +
        "Round Complete: $isRoundDone\n" +
        "Game Complete: $isGameDone\n";
  }
}
