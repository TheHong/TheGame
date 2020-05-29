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

List<Result> processSnapshot(String game, DocumentSnapshot snapshot) {
  List onlineResult = snapshot.data[game];
  List<Result> historicalResults = List();
  for (int i = 0; i < onlineResult.length; i++) {
    historicalResults.add(
      Result(
        game: game,
        name: onlineResult[i]["name"],
        score: onlineResult[i]["score"] * 1.0,
      ),
    );
  }
  return historicalResults;
}

