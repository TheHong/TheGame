import 'package:flutter/material.dart';
import 'package:game_app/models/game_info.dart';
import 'package:provider/provider.dart';

class NoteIcon extends StatefulWidget {
  @override
  _NoteIconState createState() => _NoteIconState();
}

class _NoteIconState extends State<NoteIcon> {
  
  @override
  Widget build(BuildContext context) {
    return Consumer<GameInfo>(
      builder: (context, gameInfo, child) {
        return Container(
            child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: IconButton(
            icon: Icon(Icons.music_note),
            iconSize: 100,
            onPressed: () {
              // Submit answer if a note is selected
              gameInfo.setSubmitted(gameInfo.selectedNote != "");
              // Navigator.pushNamed(context, '/waiting_page');

              // Play note
              gameInfo.notePlayer.play();
              print("${gameInfo.notePlayer.currNote} (${gameInfo.notePlayer.currNoteAsStr})");

            },
          ),
        ));
      },
    );
  }
}
