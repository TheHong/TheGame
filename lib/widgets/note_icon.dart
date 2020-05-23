import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

class NoteIcon extends StatefulWidget {
  @override
  _NoteIconState createState() => _NoteIconState();
}

class _NoteIconState extends State<NoteIcon> {
  //https://medium.com/@gmcerveny/midi-note-number-chart-for-ios-music-apps-b3c01df3cb19
  final _flutterMidi = FlutterMidi();
  final rng = new Random();
  int low = 35;
  int hi = 80;
  int currNote = -1;

  @override
  void initState() {
    load('assets/Piano.sf2');
    super.initState();
  }

  void load(String asset) async {
    _flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: _byte);
  }

  void _play(int midi) {
    print("Played note");
    _flutterMidi.playMidiNote(midi: midi);
  }

  void randomizeNote(){
    currNote = low + rng.nextInt(hi - low);
  }

  String getNoteAsStr(int note){
    
  }

  @override
  Widget build(BuildContext context) {
    randomizeNote();
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(50.0),
      child: IconButton(
        icon: Icon(Icons.music_note),
        iconSize: 100,
        onPressed: () {
          print(currNote);
          _play(currNote);
          randomizeNote();
        },
      ),
    ));
  }
}
