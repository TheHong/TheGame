import 'package:flutter/material.dart';
import 'package:game_app/components/result_widgets.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/screens/results.dart';
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
  ThePitchCore pitchCore = ThePitchCore();

  // TODO: Create submit button to finish game
  // TODO: Organize perfect_pitch screen
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThePitchCore>(
      create: (context) => pitchCore,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text("The Pitch"),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          actions: <Widget>[
            Visibility(
              visible: pitchCore.isDebugMode,
              child: IconButton(
                icon: Icon(Icons.directions_run),
                onPressed: () {
                  pitchCore.run();
                },
              ),
            ),
            Visibility(
              visible: pitchCore.isDebugMode,
              child: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultsPage(pitchCore),
                    ),
                  );
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
              icon: Icon(Icons.indeterminate_check_box),
              onPressed: () {
                getNamePrompter(context, 2);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.bug_report,
                color:
                    pitchCore.isDebugMode ? Colors.greenAccent : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  pitchCore.isDebugMode = !pitchCore.isDebugMode;
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
