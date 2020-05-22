import 'package:flutter/material.dart';

class NoteIcon extends StatefulWidget {
  @override
  _NoteIconState createState() => _NoteIconState();
}

class _NoteIconState extends State<NoteIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: IconButton(
          icon: Icon(Icons.music_note),
          iconSize: 100,
          onPressed: (){},
        ),
      )
    );
  }
}