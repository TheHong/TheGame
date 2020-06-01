import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/the_pitch/keyboard.dart';
import 'package:game_app/models/the_pitch/note_player.dart';
import 'package:game_app/models/the_trill/mini_keyboard.dart';
import 'package:game_app/models/results.dart';
import 'package:game_app/services/database.dart';

class BoolInterrupt {
  bool isDone = false;
  void raise() {
    isDone = true;
  }

  void reset() {
    isDone = false;
  }
}

class Counter {
  /* Starts counting down at startCount - 1 */
  int _currCount = 0;
  int get currCount => _currCount;
  set currCount(int num) {
    _currCount = num;
  }

  Color defaultColour = Colors.black;
  Color urgentColour = Colors.red;
  Color colour = Colors.black;

  Future run(int startCount,
      {Function notifier,
      BoolInterrupt boolInterrupt,
      bool isRedActive = true}) async {
    try {
      for (int i = startCount - 1; i >= 0; i--) {
        if (boolInterrupt is BoolInterrupt && boolInterrupt.isDone) break;
        // _currCount is only updated if other widgets are notified
        if (notifier is Function) {
          _currCount = i;
          colour = isRedActive && i <= 3 ? urgentColour : defaultColour;
          notifier();
        }
        if (boolInterrupt is BoolInterrupt && boolInterrupt.isDone) break;
        await Future.delayed(Duration(seconds: 1), () {});
      }
    } on FlutterError {
      print("Counter safely came to an abrupt end.");
    }
    colour = defaultColour;
  }
}

abstract class GameCore extends ChangeNotifier {
  DatabaseService databaseService = DatabaseService();
  final counter = Counter(); // To get time to be displayed
  final leaderboardSize = Constant.LEADERBOARD_SIZE;
  final boolInterrupt = BoolInterrupt();

  // TODO: Privatize if needed
  double score = 0.0;
  double additionalScore = Constant.DEFAULT_NO_ADDITIONAL_SCORE;
  List<Result> historicalResults = []; // From highest to lowest

  bool isRoundDone = false; // Is the round completed
  bool isGameDone = false; // Are all the rounds completed
  bool isDebugMode = false;
  bool isGameStarted = false; // Has the game started
  Map controlCommands = {}; // Developer commands from firestore
  bool isResultsActivated = false; //Is result update activated
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
  String getInstructions();
  Future _run();

  void run() async {
    print("${getGameName()} is running!");
    try {
      await loadFirestoreData();
      await _run();
    } on FlutterError {
      //Used to deal with the case where user abruptly ends game by exiting
      print("Core safely came to an abrupt end.");
    }
  }

  Future loadFirestoreData({Function onDone}) async {
    // The following is temprorary
    // historicalResults = getSampleResults();
    historicalResults = await databaseService.getResults(getGameName());
    controlCommands = await databaseService.getSingleGameControl(getGameName());
    isResultsActivated =
        controlCommands[Constant.FIREBASE_CONTROL_RESULTS_ACTIVATED_KEY] ??
            false;
    notifyListeners();
    if (onDone is Function) onDone();
  }

  List<double> getCheckpoints() {
    List<int> ranking = getRanking(historicalResults);
    int numEntries = historicalResults.length;
    return ranking.isNotEmpty
        ? [
            numEntries >= leaderboardSize ? historicalResults.last.score : 0,
            ranking.contains(3)
                ? historicalResults[ranking.indexOf(3)].score
                : (numEntries >= 3 ? -1 : 0),
            ranking.contains(2)
                ? historicalResults[ranking.indexOf(2)].score
                : (numEntries >= 2 ? -1 : 0),
            historicalResults.first.score,
          ]
        : [0, 0, 0, 0];
  }

  void evaluateResult() {
    /* Evaluates result based on the historical results of the instant that they were loaded.*/
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

      newRank = getRanking(historicalResults.sublist(0, j + 1)).last;
      newIndex = j;
      // If there's still space for the player
    } else if (historicalResults.length < leaderboardSize) {
      newRank = historicalResults.length + 1;
      newIndex = historicalResults.length;
    }
  }

  Future updateResult({String name}) async {
    /* Part of algorithm courtesy of Chi-Chung Cheung */
    await Firestore.instance.runTransaction((transaction) async {
      // Get most updated results and reevaluate rank and index
      await loadFirestoreData();
      evaluateResult();

      // Perform leaderboard changes if needed
      if (newRank > 0) {
        // Insert at new index first
        newResult = Result(
          game: getGameName(),
          name: newName,
          score: score,
          timestamp: Timestamp.now(),
          additionalScore: additionalScore,
        );
        historicalResults.insert(newIndex, newResult);

        // Check validity of leaderboard
        // Two checks below:
        // Is leaderboard overflowing?
        // Is there a tie at the supposed end of the leaderboard?
        if (historicalResults.length > leaderboardSize) {
          if (historicalResults[leaderboardSize].score !=
              historicalResults[leaderboardSize - 1].score) {
            historicalResults.removeRange(
              leaderboardSize,
              historicalResults.length,
            );
          }
        }

        // Update Firebase
        databaseService.updateResults(
          getGameName(),
          historicalResults,
          transaction,
        );

        // Update prompt
        prompt = "Congrats! You are ranked $newRank!";
      } else {
        print("Not on leaderboard. No result to be updated");
        prompt = "";
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    isGameDone = true; // Ensure background processes end
    boolInterrupt.raise(); // Ensure background processes end
    print("$this successfully disposed.");
  }
}

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

class TheTrillCore extends GameCore {
  static int _timePerRound = Constant.TIME_PER_ROUND_TRILL;
  static int _timePerRoundEnd = Constant.TIME_PER_ROUND_END_TRILL;

  MiniKeyboard keyboard = MiniKeyboard();

  TheTrillCore() {
    prompt = "Loading Game...";
    keyboard.deactivate();
    loadFirestoreData(onDone: () {
      prompt = "Start trilling to start the game!";
      counter.currCount = _timePerRound;
      keyboard.activate();
    });
    print("$this Initiated");
  }

  String getGameName() => "The Trill";
  String getGamePath() => "/the_trill";
  int getNumDecPlaces() => 0;
  String getInstructions() => Constant.INSTRUCTIONS_TRILL;

  Future _run() async {
    // Game  ----------------------------------------------------------------
    // Start Round
    isGameStarted = true;
    prompt = "TRILL!";
    notifyListeners();

    // Give player a certain amount of time to do the trills
    await counter.run(_timePerRound,
        notifier: notifyListeners, boolInterrupt: boolInterrupt);
    keyboard.deactivate();

    // Pause for user to get result feedback --------------------------------
    prompt = "Final Score: ${score.toStringAsFixed(getNumDecPlaces())}";
    isGameDone = true;
    notifyListeners();
    await counter.run(_timePerRoundEnd);

    print("The Trill Game Completed");
  }

  String getDebugInfo() {
    return "score: $score\n" +
        "keyboard active: ${keyboard.isActive}\n" +
        "previous tap: ${keyboard.prevTap}\n" +
        "game done: $isGameDone";
  }
}
