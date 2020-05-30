import 'package:flutter/material.dart';

ThemeData getTheme({String name}) {
  /* Currently mainly used by The Pitch */
  Map themes = {
    "futuristic": ThemeData(
      backgroundColor: Colors.blueGrey[100],
      accentColor: Colors.grey[800],
      scaffoldBackgroundColor: Colors.cyan[800],
    ),
    "chung": ThemeData(
      backgroundColor: Colors.white,
      accentColor: Colors.indigo[800],
      scaffoldBackgroundColor: Colors.lightBlue[300],
    )
  };

  return themes[name];
}
