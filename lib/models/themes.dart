

import 'package:flutter/material.dart';

ThemeData getTheme({String name}){
  Map themes = {
    "futuristic": ThemeData(
      primaryColor: Colors.blueGrey[100],
      accentColor: Colors.grey[800],
      scaffoldBackgroundColor: Colors.cyan[800],
    )
  };

  return themes[name];

}