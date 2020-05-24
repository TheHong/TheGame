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
        appBar: AppBar(
          title: Text("HELLO"),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GameTitleBar(),
            NoteIcon(),
            KeyPressor(),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.directions_run),
                  iconSize: 50.0,
                  color: Colors.greenAccent,
                  onPressed: () {
                    gameInfo.run();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 30.0,
                  color: Colors.greenAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, '/waiting_page');
                  },
                ),
              ],
            ),
            SubmitButton(),
          ],
        ),
      ),
    );
  }
}
