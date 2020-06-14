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
  StringObject userInput = StringObject();
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
                subtitle: Text(userInput.val),
              ),
              onSelected: (value) {
                setState(() {
                  userInput.val = value;
                });
                if (value == "") _dialogPrompter(context, userInput, setState);
              },
              onCanceled: () {
                setState(() {
                  userInput.val = "";
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
                    PopupMenuItem(
                      child: Text("Backup3"),
                      value: "Backup3",
                    ),
                    PopupMenuItem(
                      child: Text(
                        "custom",
                        style: TextStyle(color: Colors.blue),
                      ),
                      value: "",
                    ),
                  ])
        ],
      ),
      floatingActionButton: RaisedButton(
        child: Text(
          "Backup",
          style: TextStyle(
            color: userInput.val.isEmpty || _isPressed
                ? Colors.black12
                : Colors.green,
          ),
        ),
        onPressed: !_isPressed && userInput.val.isNotEmpty
            ? () async {
                _isPressed = true;
                setState(() {
                  state = "Backing up data...";
                });
                await databaseBackupService.backup(userInput.val);
                setState(() {
                  state = "Successfully backed up at '${userInput.val}'";
                });
              }
            : null,
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

class StringObject {
  String val;
  StringObject({this.val = ""});
}

void _dialogPrompter(
    BuildContext context, StringObject input, Function setState) {
  final _getNameFormKey = GlobalKey<FormState>();
  bool _isNameSubmitted = false;
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensuring compactness
              children: <Widget>[
                Form(
                  key: _getNameFormKey,
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    cursorColor: Colors.green,
                    decoration: InputDecoration(
                      filled: true,
                      icon: const Icon(Icons.backup),
                      hintText: "e.g. backup dis",
                      labelText: "Enter a backup name",
                    ),
                    onSaved: (value) {
                      input.val = value;
                    },
                    validator: (value) => value.isEmpty
                        ? "Must enter something"
                        : (value.startsWith(" ") || value.endsWith(" ")
                            ? "Must not start or end with a space"
                            : null),
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () async {
                      if (!_isNameSubmitted) {
                        _isNameSubmitted = true;
                        if (_getNameFormKey.currentState.validate()) {
                          _getNameFormKey.currentState.save();
                          setState(() {});
                          Navigator.pop(
                              context); // This removes the screen underneath
                        } else {
                          _isNameSubmitted = false;
                        }
                      } else {
                        print("Detected double press");
                      }
                    },
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
