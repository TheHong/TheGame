import 'package:flutter/material.dart';
import 'package:game_app/models/game_info.dart';
import 'package:game_app/models/note_player.dart';
import 'package:provider/provider.dart';

class NoteIcon extends StatefulWidget {
  @override
  _NoteIconState createState() => _NoteIconState();
}

class _NoteIconState extends State<NoteIcon> {
  final notePlayer = NotePlayer();

  @override
  Widget build(BuildContext context) {
    notePlayer.randomizeNote();
    return Consumer<GameInfo>(
      builder: (context, gameInfo, child) {
        return Container(
            child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: IconButton(
            icon: Icon(Icons.music_note),
            iconSize: 100,
            onPressed: () {
              print("${notePlayer.currNote} (${notePlayer.currNoteAsStr})");
              gameInfo.incrScore(10);
              notePlayer.play();
              notePlayer.randomizeNote();
            },
          ),
        ));
      },
    );
  }
}
