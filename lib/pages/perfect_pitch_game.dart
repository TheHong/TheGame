import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_app/models/game_info.dart';
import 'package:game_app/widgets/game_title_bar.dart';
import 'package:game_app/widgets/key_pressor.dart';
import 'package:game_app/widgets/note_icon.dart';
import 'package:provider/provider.dart';



class PerfectPitchGame extends StatefulWidget {
  @override
  _PerfectPitchGameState createState() => _PerfectPitchGameState();
}

class _PerfectPitchGameState extends State<PerfectPitchGame> {
  int _numRounds = 3;

  int score;
  Duration timePerRound = Duration(seconds: 5);
  bool _isRoundActive;

  void counter() async {
    // print("Start");
    // new Timer(interval, () => print('hi! $i'));

    for (int i = 0; i < _numRounds; i++) {
      _isRoundActive = true;
      await Future.delayed(timePerRound, () {
        _isRoundActive = false;
      });
      print(i);
    }

    print("Done");
  }

  @override
  Widget build(BuildContext context) {
    counter();
    return ChangeNotifierProvider(
      create: (context) => GameInfo(),
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
            ],
          )),
    );
  }
}
