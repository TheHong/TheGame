import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/models/user.dart';
import 'package:game_app/services/database.dart';
import 'package:provider/provider.dart';

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
          stream: Firestore.instance.collection('The Bored').snapshots(),
          builder: (context, snapshot) {
            // if (!snapshot.hasData) return const Text("Loading...");

            List<Result> res = processSnapshot("The Pitch", snapshot);
            print(res.length);
            return Text(res[0].name);


            // return ListView.builder(
            //   itemCount: snapshot.data.documents.length,
            //   itemBuilder: (context, index) =>
            //       Text("${snapshot.data.documents[index]['name']}"),
            // );
          }),
      floatingActionButton: IconButton(
        icon: Icon(Icons.shuffle),
        onPressed: () async {
          // await DatabaseService().update();
          // print("Done");
        },
      ),
    );
  }
}
