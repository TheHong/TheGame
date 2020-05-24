import 'package:flutter/material.dart';
import 'package:game_app/models/game_info.dart';
import 'package:game_app/widgets/game_title_bar.dart';
import 'package:game_app/widgets/key_pressor.dart';
import 'package:game_app/widgets/note_icon.dart';
import 'package:game_app/widgets/submit_button.dart';
import 'package:provider/provider.dart';

class PerfectPitchGame extends StatefulWidget {
  @override
  _PerfectPitchGameState createState() => _PerfectPitchGameState();
}

class _PerfectPitchGameState extends State<PerfectPitchGame> {
  GameInfo gameInfo = GameInfo();

  // TODO: Create submit button to finish game
  // TODO: Organize perfect_pitch screen
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => gameInfo,
      child: Scaffold(
        backgroundColor: Color(0xFF21BFBD),
        appBar: AppBar(
          title: Text("PERFECT PITCH"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.directions_run),
              onPressed: () {
                gameInfo.run();
              },
            ),
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                Navigator.pushNamed(context, '/waiting_page');
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(75.0),
                  topRight: Radius.circular(75.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  NoteIcon(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      gameInfo.prompt,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  KeyPressor(),
                  SubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
