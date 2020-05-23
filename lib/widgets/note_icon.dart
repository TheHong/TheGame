import 'package:flutter/material.dart';
import 'package:game_app/models/note_player.dart';

class NoteIcon extends StatefulWidget {
  @override
  _NoteIconState createState() => _NoteIconState();
}

class _NoteIconState extends State<NoteIcon> {
  final notePlayer = NotePlayer();

  @override
  Widget build(BuildContext context) {
    notePlayer.randomizeNote();
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(50.0),
      child: IconButton(
        icon: Icon(Icons.music_note),
        iconSize: 100,
        onPressed: () {
          print("${notePlayer.currNote} (${notePlayer.currNoteAsStr})");
          notePlayer.play();
          notePlayer.randomizeNote();
        },
      ),
    ));
  }
}
