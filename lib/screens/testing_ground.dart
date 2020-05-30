import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/models/user.dart';
import 'package:game_app/services/database.dart';

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
              .collection('The Bored')
              .document('results')
              .snapshots(),
          builder: (context, snapshot) {
            // if (!snapshot.hasData) return const Text("Loading...");

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
        message: "Add data",
        child: IconButton(
          icon: Icon(Icons.shuffle),
          onPressed: () async {
            await DatabaseService().updateSample();
            // await DatabaseService().update("The Pitch", getSampleResults());
            print("Done");
          },
        ),
      ),
    );
  }
}
