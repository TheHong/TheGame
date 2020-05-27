import 'package:flutter/material.dart';
import 'package:game_app/models/the_pitch/keyboard.dart';
import 'package:game_app/models/the_pitch/note_player.dart';
import 'package:game_app/models/the_trill/mini_keyboard.dart';
import 'package:game_app/models/user.dart';

class Counter {
  /* Starts counting down at startCount - 1 */
  int _currCount = 0;
  int get currCount => _currCount;
  set currCount(int num) => num;

  Color defaultColour = Colors.black;
  Color urgentColour = Colors.red;
  Color colour = Colors.black;

  Future run(int startCount, dynamic notifier,
      {bool isRedActive = true}) async {
    try {
      for (int i = startCount - 1; i >= 0; i--) {
        // _currCount is only updated if other widgets are notified
        if (notifier is Function) {
          _currCount = i;
          colour = isRedActive && i <= 3 ? urgentColour : defaultColour;
          notifier();
        }
        await Future.delayed(Duration(seconds: 1), () {});
      }
    } on FlutterError {
      print("Counter safely came to an abrupt end.");
    }
    colour = defaultColour;
  }
}

abstract class GameCore extends ChangeNotifier {
  final counter = Counter(); // To get time to be displayed

  // TODO: Privatize if needed
  double score = 0.0;
  bool isRoundDone = false; // Is the round completed
  bool isGameDone = false; // Are all the rounds completed
  bool isDebugMode = false;
  List<Result> historicalResults;
  String prompt =
      "Welcome"; // Prompt to inform player of the current game status
  Result result = Result(game: "", name: "", score: -1);

  // Variables used to store user info if they make it onto leaderboard
  int newRank = -1;
  String newName = "";

  void run();
  String getGameName();
  String getGamePath();
  String getDebugInfo();

  void loadHistoricalResults() {
    // TODO: Load from firebase (kinda repeat from the home.dart)
    // The following is temprorary
    historicalResults = getSampleResults();
  }

  void evaluateResult() {
    if (score > historicalResults.last.score) {
      // Player makes it onto the ranking
      int rank;
      for (rank = 1; rank <= historicalResults.length; rank++) {
        if (score >= historicalResults[rank - 1].score) {
          break;
        }
      }
      newRank = rank;
    }
  }

  void updateResult({String name}) {
    if (newRank > 0) {
      result = Result(game: getGameName(), name: newName, score: score);
      historicalResults.removeAt(historicalResults.length - 1);
      historicalResults.insert(newRank - 1, result);
      prompt = "Congrats! You are ranked $newRank!";
      // TODO: Update firebase

    } else {
      print("Not on leaderboard. No result to be updated");
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("$this successfully disposed.}");
  }
}

class ThePitchCore extends GameCore {
  static int _numRounds = 1;
  static int _timeBeforeStart = 5; // Duration for game to load
  static int _timePerRound = 5; // Duration of each round
  static int _timePerPreparation =
      3; // Duration of the countdown to the start of the round
  static int _timePerEnd =
      3; // Duration at the end of each round before the countdown of next round
  static Map _prompts = {
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

  final notePlayer = NotePlayer(); // To play the tones
  final keyboard = Keyboard(); // Contains the information of the keys
  final stopwatch = Stopwatch(); // To measure time

  ThePitchCore() {
    loadHistoricalResults();
    // run();
  }

  String getGameName() {
    return "The Pitch";
  }

  String getGamePath() {
    return "/the_pitch";
  }

  @override
  void run() async {
    // Prepare for the game ---------------------------------------------------
    prompt = _prompts["loading"];
    notifyListeners();
    await counter.run(_timeBeforeStart, notifyListeners, isRedActive: false);

    try {
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
        await counter.run(_timePerPreparation, notifyListeners,
            isRedActive: false);

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
      prompt = "";
      notifyListeners();
    } on FlutterError {
      print("Core safely came to an abrupt end.");
    }
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

class TheTrillCore extends GameCore {
  static int _timeBeforeStart = 5; // Duration for game to load
  static int _timePerRound = 11; // Duration of each round
  static int _timePerPreparation =
      5; // Duration of the countdown to the start of the round
  static int _timePerEnd =
      3; // Duration at the end of each round before the countdown of next round

  MiniKeyboard keyboard = MiniKeyboard();

  TheTrillCore() {
    loadHistoricalResults();
    // run();
  }

  String getGameName() {
    return "The Trill";
  }

  String getGamePath() {
    return "/the_trill";
  }

  void run() async {
    // Prepare for the game ---------------------------------------------------
    prompt = "Game is loading...";
    notifyListeners();
    await counter.run(_timeBeforeStart, notifyListeners, isRedActive: false);

    prompt = "Get Ready!";
    notifyListeners();

    // Counts down for the user right before game begins
    await counter.run(_timePerPreparation, notifyListeners, isRedActive: false);

    // Game  ----------------------------------------------------------------
    // Start Round
    prompt = "TRILL!";
    keyboard.activate();
    notifyListeners();

    // Give player a certain amount of time to do the trills
    await counter.run(_timePerRound, notifyListeners);
    keyboard.deactivate();

    // Pause for user to get result feedback --------------------------------
    prompt = "";
    isGameDone = true;
    notifyListeners();
    await counter.run(_timePerEnd, false);

    print("Done");
  }

  String getDebugInfo() {
    return "score: $score\n" +
        "keyboard active: ${keyboard.isActive}\n" +
        "previous tap: ${keyboard.prevTap}\n" +
        "game done: $isGameDone";
  }
}
