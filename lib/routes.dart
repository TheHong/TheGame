import 'package:flutter/widgets.dart';
import 'package:game_app/screens/results.dart';
import 'package:game_app/screens/the_icon/icon_game.dart';
import 'package:game_app/screens/the_trill/trill_game.dart';
import 'package:game_app/screens/waiting.dart';
import 'package:game_app/screens/home.dart';
import 'package:game_app/screens/the_pitch/pitch_game.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (context) => Home(),
  '/the_pitch': (context) => PitchGame(),
  '/the_trill': (context) => TrillGame(),
  '/the_icon': (context) => IconGame(),
  '/waiting_page': (context) => WaitingPage(),
  '/results_page': (context) => ResultsPage(),
};
