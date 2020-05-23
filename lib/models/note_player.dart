import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

class NotePlayer {
  /* 
  Notes can be played using an integer identifier from 0 to 127 inclusive, each 
  integer corresponding to a certain note. More details found at:
  https://medium.com/@gmcerveny/midi-note-number-chart-for-ios-music-apps-b3c01df3cb19 
  
  */

  final _flutterMidi = FlutterMidi(); // Deals with playing the midi
  final _random = new Random(); // Generates random number

  List<String> _noteStr = [
    "C",
    "C#",
    "D",
    "D#",
    "E",
    "F",
    "F#",
    "G",
    "G#",
    "A",
    "A#",
    "B"
  ];
  int _low = 35; // Lowest note to play by an instance
  int _hi = 80; // Highest note to play by an instance
  int _currNote = -1; // The current note to be played by an instance

  // Gets info about current note
  int get currNote => _currNote;
  String get currNoteAsStr => getNoteAsStr(currNote); // Ignore which octave

  NotePlayer() {
    print("Initializing NotePlayer");
    _load('assets/Piano.sf2');
  }

  void play() {
    /* Plays the instance's CURRENT note*/
    _flutterMidi.playMidiNote(midi: currNote);
  }

  void _load(asset) async {
    _flutterMidi.unmute();
    ByteData _byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: _byte);
  }

  void randomizeNote() {
    /* Changes the current note to a random note. */
    _currNote = _low + _random.nextInt(_hi - _low);
  }

  String getNoteAsStr(int note) {
    /* Converts the note integer in its corresponding string (ignoring which octave) */
    int numKeys = _noteStr.length;
    return _noteStr[note % numKeys];
  }
}
