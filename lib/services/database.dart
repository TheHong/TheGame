/*
Most of the names below are stored in constants.dart.

Results are stored as follows:
Collection: "The Game"
->Document: "results"
-->Field: "The Pitch"
          ^[{"name": String, "score": double, "timestamp": Timestamp}, ...]
-->Field: "The Trill"
...

Control Commands are stored as follows:
Collection: "The Game"
->Document: "control"
-->Field: "The Pitch"
          ^{"game activated": bool, "results activated": bool}
-->Field: "The Trill"
...
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/results.dart';

class DatabaseService {
  final DocumentReference onlineResults = Firestore.instance
      .collection(Constant.FIREBASE_COLLECTION_NAME)
      .document(Constant.FIREBASE_RESULTS_DOCUMENT_NAME);
  final DocumentReference onlineStats = Firestore.instance
      .collection(Constant.FIREBASE_COLLECTION_NAME)
      .document(Constant.FIREBASE_STATS_DOCUMENT_NAME);
  final DocumentReference onlineControl = Firestore.instance
      .collection(Constant.FIREBASE_COLLECTION_NAME)
      .document(Constant.FIREBASE_CONTROL_DOCUMENT_NAME);

  Future updateNonAtomic(String game, List<Result> newResults) async {
    return await onlineResults.setData(
      {
        game: newResults.map((result) => result.toMap()).toList(),
      },
    );
  }

  Future updateStats(String game) async {
    onlineStats.updateData({game: FieldValue.increment(1)});
    print("Stats updated");
  }

  Future updateResults(
      String game, List<Result> newResults, Transaction transaction) async {
    await transaction.update(
      onlineResults,
      {
        game: newResults.map((result) => result.toMap()).toList(),
      },
    );
    print("Results updated");
  }

  Future<List<Result>> getResults(game) async {
    DocumentSnapshot resultsDocument = await onlineResults.get();
    return getResultsFromDocSnapshot(game, resultsDocument);
  }

  Future<Map> getSingleGameControl(game) async {
    DocumentSnapshot controlDocument = await onlineControl.get();
    Map controls = getGameControlFromSnapshot(controlDocument);
    return controls.containsKey(game) ? controls[game] : {};
  }
}

Map getGameControlFromSnapshot(dynamic snapshot) {
  try {
    DocumentSnapshot controlDocument =
        snapshot is AsyncSnapshot ? snapshot.data : snapshot;
    Map controlCommands = controlDocument.data;
    assert(controlCommands != null,
        "Make sure ${Constant.FIREBASE_COLLECTION_NAME}/${Constant.FIREBASE_CONTROL_DOCUMENT_NAME} exists in Firestore.");
    return controlCommands;
  } on NoSuchMethodError {
    // Occurs when the getter 'data' is called on null
    return {};
  }
}

List<Result> getResultsFromAsyncSnapshot(String game, AsyncSnapshot snapshot) {
  // Looking for data
  if (!snapshot.hasData) return [];

  // Extracting the results from the snapshot
  DocumentSnapshot resultsDocument = snapshot.data;
  return getResultsFromDocSnapshot(game, resultsDocument);
}

List<Result> getResultsFromDocSnapshot(String game, DocumentSnapshot snapshot) {
  Map results = snapshot.data;
  assert(
      results != null,
      "Make sure ${Constant.FIREBASE_COLLECTION_NAME}/${Constant.FIREBASE_RESULTS_DOCUMENT_NAME} " +
          "and ${Constant.FIREBASE_COLLECTION_NAME}/${Constant.FIREBASE_STATS_DOCUMENT_NAME} " +
          "are already made in Firestore");
  if (!results.containsKey(game)) return []; // If no data for game

  // Storing and returning the results
  List gameResults = results[game];
  List<Result> historicalResults = List();
  for (int i = 0; i < gameResults.length; i++) {
    historicalResults.add(
      Result(
          game: game,
          name: gameResults[i][Constant.FIREBASE_RESULTS_NAME_KEY],
          score: gameResults[i][Constant.FIREBASE_RESULTS_SCORE_KEY] * 1.0,
          timestamp: gameResults[i][Constant.FIREBASE_RESULTS_TIMESTAMP_KEY],
          additionalScore:
              // The containskey check is to deal with previous versions of gameResults. Can remove in future versions
              gameResults[i].containsKey(Constant.FIREBASE_RESULTS_SCORE2_KEY)
                  ? gameResults[i][Constant.FIREBASE_RESULTS_SCORE2_KEY] * 1.0
                  : Constant.DEFAULT_NO_ADDITIONAL_SCORE),
    );
  }
  return historicalResults;
}
