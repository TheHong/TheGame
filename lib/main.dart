import 'package:flutter/material.dart';
import 'package:game_app/pages/home.dart';
import 'package:game_app/pages/perfect_pitch_game.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/perfect_pitch', // To override the default of '/'
  routes: {
    '/': (context) => Home(),
    '/perfect_pitch': (context) => PerfectPitchGame(),
  }
));