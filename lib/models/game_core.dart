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
  final leaderboardSize = 10;

  // TODO: Privatize if needed
  double score = 0.0;
  bool isRoundDone = false; // Is the round completed
  bool isGameDone = false; // Are all the rounds completed
  bool isDebugMode = false;
  bool isGameStarted = false; // Has the game started
  List<Result> historicalResults = []; // From highest to lowest
  String prompt =
      "Welcome"; // Prompt to inform player of the current game status

  // Variables used to store user info if they make it onto leaderboard
  Result newResult = Result(game: "", name: "", score: -1);
  int newIndex =
      -1; // Location in the list the new result is placed (not necessarily the actual rank)
  int newRank = -1; // Actual rank. Starts at 1!
  String newName = "";

  int getNumDecPlaces();
  String getGameName();
  String getGamePath();
  String getDebugInfo();
  Future _run();

  void run() async {
    try {
      //Used to deal with the case where user abruptly ends game by exiting
      await _run();
    } on FlutterError {
      print("Core safely came to an abrupt end.");
    }
  }

  void loadHistoricalResults() {
    // TODO: Load from firebase (kinda repeat from the home.dart)
    // The following is temprorary
    historicalResults = getSampleResults();
  }

  List<double> getCheckpoints() {
    assert(historicalResults.isNotEmpty,
        "Historical results must be loaded before checkpoints can be generated.");

    List<int> ranking = getRanking(historicalResults);
    int numEntries = historicalResults.length;
    return [
      numEntries >= leaderboardSize ? historicalResults.last.score : 0,
      ranking.contains(3)
          ? historicalResults[ranking.indexOf(3)].score
          : (numEntries >= 3 ? -1 : 0),
      ranking.contains(2)
          ? historicalResults[ranking.indexOf(2)].score
          : (numEntries >= 2 ? -1 : 0),
      historicalResults.first.score,
    ];
  }

  void evaluateResult() {
    /* In case of ties, the new player will have same rank, but will be earlier in the list */

    if (historicalResults.isEmpty) {
      newRank = 1;
      newIndex = 0;
    }
    // If player makes it onto the ranking
    else if (score >= historicalResults.last.score) {
      int j;
      for (j = 0; j < historicalResults.length; j++) {
        if (score >= historicalResults[j].score) {
          break;
        }
      }

      newRank = getRanking(historicalResults.sublist(0, j)).last;
      newIndex = j;
      // If there's still space for the player
    } else if (historicalResults.length < leaderboardSize) {
      newRank = historicalResults.length + 1;
      newIndex = historicalResults.length;
    }
  }

  void updateResult({String name}) {
    /* Algorithm courtesy of Chi-Chung Cheung */
    if (newRank > 0) {
      // Insert at new index first
      newResult = Result(game: getGameName(), name: newName, score: score);
      historicalResults.insert(newIndex, newResult);

      // Check validity of leaderboard
      // Two checks below:
      // Is leaderboard overflowing?
      // Is there a tie at the supposed end of the leaderboard?
      if (historicalResults.length > leaderboardSize) {
        if (historicalResults[leaderboardSize] !=
            historicalResults[leaderboardSize - 1]) {
          historicalResults.removeRange(
            leaderboardSize,
            historicalResults.length,
          );
        }
      }

      // TODO: Update firebase

      // Update prompt
      prompt = "Congrats! You are ranked $newRank!";
    } else {
      print("Not on leaderboard. No result to be updated");
      prompt = "";
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

  String getGameName() => "The Pitch";
  String getGamePath() => "/the_pitch";
  int getNumDecPlaces() => 3;

  @override
  Future _run() async {
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
    print("The Pitch Game Completed");
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

class TheTrillCore extends GameCore {
  static int _timePerRound = 5; // Duration of each round
  static int _timePerEnd =
      3; // Duration at the end of each round before the countdown of next round

  MiniKeyboard keyboard = MiniKeyboard();

  TheTrillCore() {
    loadHistoricalResults();
    prompt = "Start tapping to start the game!";
    keyboard.activate();
  }

  String getGameName() => "The Trill";
  String getGamePath() => "/the_trill";
  int getNumDecPlaces() => 0;

  Future _run() async {
    // Game  ----------------------------------------------------------------
    // Start Round
    isGameStarted = true;
    prompt = "TRILL!";
    notifyListeners();

    // Give player a certain amount of time to do the trills
    await counter.run(_timePerRound, notifyListeners);
    keyboard.deactivate();

    // Pause for user to get result feedback --------------------------------
    prompt = "Final Score: ${score.toStringAsFixed(0)}";
    isGameDone = true;
    notifyListeners();
    await counter.run(_timePerEnd, false);

    print("The Trill Game Completed");
  }

  String getDebugInfo() {
    return "score: $score\n" +
        "keyboard active: ${keyboard.isActive}\n" +
        "previous tap: ${keyboard.prevTap}\n" +
        "game done: $isGameDone";
  }
}
