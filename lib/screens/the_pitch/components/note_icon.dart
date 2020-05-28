import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';

class NoteIcon extends StatefulWidget {
  @override
  _NoteIconState createState() => _NoteIconState();
}

class _NoteIconState extends State<NoteIcon> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThePitchCore>(
      builder: (context, pitchCore, child) {
        return Container(
            color: pitchCore.isDebugMode ? Colors.black12 : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
              ),
              child: OutlineButton(
                padding: EdgeInsets.all(25),
                shape: CircleBorder(),
                child: Icon(
                  Icons.music_note,
                  size: 100,
                  // Inactive: Black
                  // Awaiting user answer: Blue
                  // Displaying result: Green or Red
                  color: !pitchCore.keyboard.isActive && !pitchCore.isRoundDone
                      ? Colors.black
                      : pitchCore.isRoundDone
                          ? (pitchCore.isCorrect
                              ? Colors.lightGreenAccent[700]
                              : Colors.redAccent[700])
                          : Colors.blue,
                ),
                onPressed: !pitchCore.keyboard.isActive
                    ? null
                    : () {
                        // Play note
                        pitchCore.notePlayer.play();
                        print(
                            "${pitchCore.notePlayer.currNote} (${pitchCore.notePlayer.currNoteAsStr})");
                      },
              ),
            ));
      },
    );
  }
}
