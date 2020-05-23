import 'package:flutter/material.dart';
import 'package:game_app/widgets/key_pressor.dart';
import 'package:game_app/widgets/note_icon.dart';

class PerfectPitchGame extends StatefulWidget {
  @override
  _PerfectPitchGameState createState() => _PerfectPitchGameState();
}

class _PerfectPitchGameState extends State<PerfectPitchGame> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HELLO"),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NoteIcon(),
            KeyPressor(),
          ],
        ));
  }
}