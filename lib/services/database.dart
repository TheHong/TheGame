/*
Results are stored as follows:
Collection: "The Game"
->Document: "results"
-->Field: "The Pitch"
          ^[{"name": _, "score": _}, ...]
-->Field: "The Trill"
...
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/models/user.dart';

class DatabaseService {
  final CollectionReference onlineResults =
      Firestore.instance.collection('The Bored');

  Future update() async {
    //List<Result> newResults) async{
    return await onlineResults
        .document("new")
        .setData({'name': "Anna", 'score': 55});
  }

  Stream<QuerySnapshot> get res {
    return onlineResults.snapshots();
  }
}

List<Result> processSnapshot(String game, AsyncSnapshot snapshot) {
  // Looking for data
  if (!snapshot.hasData) return [];

  // Extracting the results from the snapshot
  DocumentSnapshot resultsDocument = snapshot.data.documents[0];
  Map results = resultsDocument.data;
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
      ),
    );
  }
  return historicalResults;
}
