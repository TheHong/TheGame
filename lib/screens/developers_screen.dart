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
  // Note that that for scaffold floatingactionbutton, the boolean responsible
  // for preventing double presses must be outside the build
  bool _isPressed = false;
  String backupLocation = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Developer's Screen")),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 25.0),
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
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton(
              child: ListTile(
                title: Text("Choose backup location"),
                subtitle: Text(backupLocation),
              ),
              onSelected: (value) {
                setState(() {
                  backupLocation = value;
                });
              },
              onCanceled: () {
                setState(() {
                  backupLocation = "";
                });
              },
              itemBuilder: (context) => <PopupMenuItem<String>>[
                    PopupMenuItem(
                      child: Text("Backup0"),
                      value: "Backup0",
                    ),
                    PopupMenuItem(
                      child: Text("Backup1"),
                      value: "Backup1",
                    ),
                    PopupMenuItem(
                      child: Text("Backup2"),
                      value: "Backup2",
                    ),
                  ])
        ],
      ),
      floatingActionButton: RaisedButton(
        child: Text(
          "Backup",
          style: TextStyle(
            color: backupLocation.isEmpty || _isPressed
                ? Colors.black12
                : Colors.green,
          ),
        ),
        onPressed: () async {
          if (!_isPressed && backupLocation.isNotEmpty) {
            _isPressed = true;
            setState(() {
              state = "Backing up data...";
            });
            await databaseBackupService.backup(backupLocation);
            setState(() {
              state = "Successfully backed up at '$backupLocation'";
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

  Future backup(String backupLocation) async {
    final DocumentReference backupDataDoc = Firestore.instance
        .collection(Constant.FIREBASE_COLLECTION_NAME)
        .document(backupLocation);
    Map<String, dynamic> backupData = {"Backup Time": Timestamp.now()};
    DocumentSnapshot resultsDocument = await onlineDataDoc.get();
    backupData.addAll(resultsDocument.data);
    DocumentSnapshot statsDocument = await onlineStatsDoc.get();
    for (String key in statsDocument.data.keys)
      backupData["$key Stats"] = statsDocument.data[key];
    return await backupDataDoc.setData(backupData);
  }
}
