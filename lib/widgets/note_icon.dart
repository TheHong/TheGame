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
  int low = 35;
  int hi = 80;
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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(50.0),
      child: IconButton(
        icon: Icon(Icons.music_note),
        iconSize: 100,
        onPressed: () {
          _play(85);
        },
      ),
    ));
  }
}
