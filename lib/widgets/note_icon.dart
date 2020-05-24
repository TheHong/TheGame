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
            color: gameInfo.isDebugMode ? Colors.indigo : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: OutlineButton(
                padding: EdgeInsets.all(25),
                shape: CircleBorder(),
                child: Icon(
                  Icons.music_note,
                  size: 100,
                  // Inactive: Black
                  // Awaiting user answer: Blue
                  // Displaying result: Green or Red
                  color: !gameInfo.keyboard.isActive && !gameInfo.isRoundDone
                      ? Colors.black
                      : gameInfo.isRoundDone
                          ? (gameInfo.isCorrect ? Colors.green : Colors.red)
                          : Colors.blue,
                ),
                onPressed: !gameInfo.keyboard.isActive
                    ? null
                    : () {
                        // Play note
                        gameInfo.notePlayer.play();
                        print(
                            "${gameInfo.notePlayer.currNote} (${gameInfo.notePlayer.currNoteAsStr})");
                      },
              ),
            ));
      },
    );
  }
}
