import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/results.dart';
import 'package:game_app/services/database.dart';

class BoolInterrupt {
  bool val = false;
  void raise() {
    val = true;
  }

  void reset() {
    val = false;
  }
}

class Counter {
  /* Starts counting down at startCount - 1 */
  int currCount = 0;

  Color defaultColour = Colors.black;
  Color urgentColour = Colors.red;
  Color colour = Colors.black;

  Future run(int startCount,
      {Function notifier,
      BoolInterrupt boolInterrupt,
      bool isRedActive = true}) async {
    try {
      for (int i = startCount - 1; i >= 0; i--) {
        if (boolInterrupt is BoolInterrupt && boolInterrupt.val) break;
        // _currCount is only updated if other widgets are notified
        if (notifier is Function) {
          currCount = i;
          colour = isRedActive && i <= 3 ? urgentColour : defaultColour;
          notifier();
        }
        if (boolInterrupt is BoolInterrupt && boolInterrupt.val) break;
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
  double additionalScore = Constant
      .DEFAULT_NO_ADDITIONAL_SCORE; // Currently displayed in results with 0 decimal places
  List<Result> historicalResults = []; // From highest to lowest

  bool isRoundDone = false; // Is the round completed
  bool isGameDone = false; // Are all the rounds completed
  bool isDebugMode = false;
  bool isGameStarted = false; // Has the game started
  Map controlCommands = {}; // Developer commands from firestore
  bool isResultsActivated = false; //Is result update activated
  bool isStatsUpdated = false; // Is the stat stored in firestore updated
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
  Future game();

  void run() async {
    print("${getGameName()} is running!");
    try {
      await loadFirestoreData();
      await game();
    } on FlutterError {
      //Used to deal with the case where user abruptly ends game by exiting
      print("Core safely came to an abrupt end.");
    }
  }

  Future loadFirestoreData({Function onDone}) async {
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
        if (score >= historicalResults[j].score) break;
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
    print(
        "$this successfully disposed. (Stats${isStatsUpdated ? " " : " not "}updated)");
  }
}
