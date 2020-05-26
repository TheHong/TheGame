import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/screens/the_pitch/components/game_title_bar.dart';
import 'package:game_app/screens/the_pitch/components/key_pressor.dart';
import 'package:game_app/screens/the_pitch/components/note_icon.dart';
import 'package:game_app/screens/the_pitch/components/prompter.dart';
import 'package:game_app/screens/the_pitch/components/submit_button.dart';
import 'package:provider/provider.dart';

class PitchGame extends StatefulWidget {
  @override
  _PitchGameState createState() => _PitchGameState();
}

class _PitchGameState extends State<PitchGame> {
  ThePitchCore gameInfo = ThePitchCore(); // TODO: Change gameInfo to something else

  // TODO: Create submit button to finish game
  // TODO: Organize perfect_pitch screen
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => gameInfo,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text("The Pitch"),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          actions: <Widget>[
            Visibility(
              visible: gameInfo.isDebugMode,
              child: IconButton(
                icon: Icon(Icons.directions_run),
                onPressed: () {
                  gameInfo.run();
                },
              ),
            ),
            Visibility(
              visible: gameInfo.isDebugMode,
              child: IconButton(
                icon: Icon(Icons.camera),
                onPressed: () {
                  Navigator.pushNamed(context, '/waiting_page');
                },
              ),
            ),
            IconButton(
              // TODO: Implement a "Are you sure?" if user wants to exits before game ends
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            IconButton(
              icon: Icon(
                Icons.bug_report,
                color: gameInfo.isDebugMode ? Colors.greenAccent : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  gameInfo.isDebugMode = !gameInfo.isDebugMode;
                });
              },
            )
          ],
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GameTitleBar(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75.0),
                    topRight: Radius.circular(75.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    NoteIcon(),
                    Prompter(),
                    KeyPressor(),
                    SubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
