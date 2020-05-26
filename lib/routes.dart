import 'package:flutter/widgets.dart';
import 'package:game_app/screens/waiting.dart';
import 'package:game_app/screens/home.dart';
import 'package:game_app/screens/the_pitch/perfect_pitch_game.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (context) => Home(),
  '/the_pitch': (context) => PerfectPitchGame(),
  '/waiting_page': (context) => WaitingPage(),
};
