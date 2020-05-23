import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

class NotePlayer{
  // https://medium.com/@gmcerveny/midi-note-number-chart-for-ios-music-apps-b3c01df3cb19
  final _flutterMidi = FlutterMidi();
  final rng = new Random();
  List<String> notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]; // TODO:
  int low = 35;
  int hi = 80;
  int currNote = -1;

  NotePlayer() {
    print("Initializing NotePlayer");
    load('assets/Piano.sf2');
  }

  void load(asset) async{
    _flutterMidi.unmute(); // Optionally Unmute
    ByteData _byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: _byte);
  }

  void play() {
    _flutterMidi.playMidiNote(midi: currNote);
  }

  void randomizeNote(){
    currNote = low + rng.nextInt(hi - low);
  }

  String getNoteAsStr(int note){
    
  }

}