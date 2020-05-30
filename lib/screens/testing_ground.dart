import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/results.dart';

class TestingGround extends StatefulWidget {
  @override
  _TestingGroundState createState() => _TestingGroundState();
}

class _TestingGroundState extends State<TestingGround> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Testing")),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection(Constant.FIREBASE_COLLECTION_NAME)
              .document(Constant.FIREBASE_DOCUMENT_NAME)
              .snapshots(),
          builder: (context, snapshot) {
            // if (!snapshot.hasData) return const Text("No data...");
            if (snapshot.data == null || snapshot.data.data == null)
              return const Text("No data...");
            List<Result> res =
                getResultsFromAsyncSnapshot("The Pitch", snapshot);
            print("Amount of results => ${res.length}");

            return ListView.builder(
              itemCount: res.length,
              itemBuilder: (context, index) => Text(
                  "${res[index].name} => ${res[index].score} (${res[index].timestamp.toDate()})"),
            );
          }),
      floatingActionButton: Tooltip(
        message:
            "WARNING!!!!! MAKE SURE THE DATABASE OBJECT IS NOT A DatabaseService, but a DatabaseServiceTest." +
                "Must not overwrite",
        child: IconButton(
          icon: Icon(Icons.shuffle),
          onPressed: () async {
            await DatabaseServiceTest()
                .testUpdateasdfasdf("The Pitch", getSampleResults());
            print("Done");
          },
        ),
      ),
    );
  }
}

class DatabaseServiceTest {
  final DocumentReference onlineResults =
      Firestore.instance.collection("TEST_GROUND").document("TEST_RESULTS");

  Future testUpdateasdfasdf(String game, List<Result> newResults) async {
    return await onlineResults.setData(
      {
        game: newResults.map((result) => result.toMap()).toList(),
      },
    );
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
