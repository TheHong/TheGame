import 'package:flutter/material.dart';
import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/models/the_pitch/pitch_core.dart';
import 'package:game_app/screens/instructions_screen.dart';
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
    Size screen = MediaQuery.of(context).size;
    return ChangeNotifierProvider<ThePitchCore>(
      create: (context) => pitchCore,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text("The Pitch"),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: getUpdatorBackButton(context, pitchCore),
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
                    KeyPressor(), // Contains parameters that do not adapt with screen size
                    SizedBox(height: screen.height / 23),
                    BottomBar(),
                    SizedBox(
                      // Used to extend the container
                      height: screen.height / 7,
                    ),
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
