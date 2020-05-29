import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/screens/instructions.dart';
import 'package:game_app/screens/the_pitch/components/game_title_bar.dart';
import 'package:game_app/screens/the_pitch/components/key_pressor.dart';
import 'package:game_app/screens/the_pitch/components/note_icon.dart';
import 'package:game_app/screens/the_pitch/components/prompter.dart';
import 'package:game_app/screens/the_pitch/components/bottom_bar.dart';
import 'package:provider/provider.dart';

class PitchGame extends StatefulWidget {
  @override
  _PitchGameState createState() => _PitchGameState();
}

class _PitchGameState extends State<PitchGame> {
  ThePitchCore pitchCore = ThePitchCore();

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
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstructionsPage(pitchCore),
                  ),
                );
              },
            )
          ],
        ),
        body: MediaQuery.removePadding(
          // Need this to remove the bottom listview padding
          context: context,
          removeBottom: true,
          child: ListView(
            // Need list view to prevent overflow when entering name
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              GameTitleBar(),
              Container(
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
                    SizedBox(height: 20),
                    BottomBar(),
                    SizedBox(
                        height: MediaQuery.of(context).size.height /
                            7), // Used to extend the container
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
