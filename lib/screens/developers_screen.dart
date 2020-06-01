import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/models/constants.dart';

class DevelopersScreen extends StatefulWidget {
  @override
  _DevelopersScreenState createState() => _DevelopersScreenState();
}

class _DevelopersScreenState extends State<DevelopersScreen> {
  final DatabaseBackupService databaseBackupService = DatabaseBackupService();
  String state = "Welcome";
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Developer's Screen")),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        state,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: RaisedButton(
        child: Text(
          "Backup",
          style: TextStyle(
            color: _isPressed ? Colors.black26 : Colors.green,
          ),
        ),
        onPressed: () async {
          if (!_isPressed) {
            _isPressed = true;
            setState(() {
              state = "Backing up data...";
            });
            await databaseBackupService.backup();
            setState(() {
              state = "Successfully backed up";
            });
          }
        },
      ),
    );
  }
}

class DatabaseBackupService {
  final DocumentReference onlineDataDoc = Firestore.instance
      .collection(Constant.FIREBASE_COLLECTION_NAME)
      .document(Constant.FIREBASE_RESULTS_DOCUMENT_NAME);
  final DocumentReference onlineStatsDoc = Firestore.instance
      .collection(Constant.FIREBASE_COLLECTION_NAME)
      .document(Constant.FIREBASE_STATS_DOCUMENT_NAME);
  final DocumentReference backupDataDoc = Firestore.instance
      .collection(Constant.FIREBASE_COLLECTION_NAME)
      .document("backup1");

  Future backup() async {
    Map backupData;
    DocumentSnapshot resultsDocument = await onlineDataDoc.get();
    backupData = resultsDocument.data;
    DocumentSnapshot statsDocument = await onlineStatsDoc.get();
    for (String key in statsDocument.data.keys)
      backupData["$key Stats"] = statsDocument.data[key];
    return await backupDataDoc.setData(backupData);
  }
}
