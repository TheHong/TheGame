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

  Future updateNonAtomic(String game, List<Result> newResults) async {
    return await onlineResults.setData(
      {
        game: newResults.map((result) => result.toMap()).toList(),
      },
    );
  }

  Future updateResults(
      String game, List<Result> newResults, Transaction transaction) async {
    await transaction.update(onlineResults, {
      game: newResults.map((result) => result.toMap()).toList(),
    });
  }

  Future<List<Result>> getResults(game) async {
    DocumentSnapshot resultsDocument = await onlineResults.get();
    return getResultsFromDocSnapshot(game, resultsDocument);
  }

  Future updateStats(String game) async {
    onlineStats.updateData({game: FieldValue.increment(1)});
  }
}

Map getGameControlFromAsyncSnapshot(AsyncSnapshot snapshot) {
  try {
    DocumentSnapshot controlDocument = snapshot.data;
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
  assert(results != null,
      "Make sure 'The Game/results' and 'The Game/stats' are already made in Firestore");
  if (!results.containsKey(game)) return []; // If no data for game

  // Storing and returning the results
  List gameResults = results[game];
  List<Result> historicalResults = List();
  for (int i = 0; i < gameResults.length; i++) {
    historicalResults.add(
      Result(
        game: game,
        name: gameResults[i]["name"],
        score: gameResults[i]["score"] * 1.0,
        timestamp: gameResults[i]["timestamp"],
      ),
    );
  }
  return historicalResults;
}
