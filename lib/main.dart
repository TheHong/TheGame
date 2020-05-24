import 'package:flutter/material.dart';
import 'package:game_app/models/themes.dart';
import 'package:game_app/pages/home.dart';
import 'package:game_app/pages/perfect_pitch_game.dart';
import 'package:game_app/pages/waiting.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/', // To override the default of '/'
  routes: {
    '/': (context) => Home(),
    '/the_pitch': (context) => PerfectPitchGame(),
    '/waiting_page': (context) => WaitingPage(),
  },
  theme: getTheme(name: "chung"),
));