import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/models/constants.dart';

class DevelopersScreen extends StatefulWidget {
  @override
  _DevelopersScreenState createState() => _DevelopersScreenState();
}

class _DevelopersScreenState extends State<DevelopersScreen> {
  final DatabaseBackupService databaseBackupService = DatabaseBackupService();

  @override
  Widget build(BuildContext context) {
    String state = "";
    bool _isPressed = false;
    return Scaffold(
      appBar: AppBar(title: Text("Developer's Screen")),
      body: Container(
        padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(75.0),
          ),
        ),
      ),
      floatingActionButton: RaisedButton(
        child: Text("Backup"),
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
    backupData.addAll(resultsDocument.data);
    return await backupDataDoc.setData(backupData);
  }
}
