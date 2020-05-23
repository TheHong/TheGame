import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

class NotePlayer{
  /* 
  Notes can be played using an integer identifier from 0 to 127 inclusive, each 
  integer corresponding to a certain note. More details found at:
  https://medium.com/@gmcerveny/midi-note-number-chart-for-ios-music-apps-b3c01df3cb19 
  
  */

  final _flutterMidi = FlutterMidi(); // Deals with playing the midi
  final random = new Random(); // Generates random number

  List<String> notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
  int low = 35; // Lowest note to play by an instance
  int hi = 80; // Highest note to play by an instance
  int currNote = -1; // The current note to be played by an instance

  NotePlayer() {
    print("Initializing NotePlayer");
    load('assets/Piano.sf2');
  }

  void load(asset) async{
    _flutterMidi.unmute();
    ByteData _byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: _byte);
  }

  void play() {
    /* Plays the instance's CURRENT note*/
    _flutterMidi.playMidiNote(midi: currNote);
  }

  void randomizeNote(){
    /* Changes the current note to a random note. */
    currNote = low + random.nextInt(hi - low);
  }

  String getCurrNoteAsStr(){
    /* Converts the current note integer in its corresponding string (ignoring which octave) */
    return getNoteAsStr(currNote);
  }

  String getNoteAsStr(int note){
    /* Converts the note integer in its corresponding string (ignoring which octave) */
    int numKeys = 12;
    return notes[note % numKeys];
  }

}