import 'package:flutter/material.dart';
import 'package:game_app/theme/themes.dart';
import 'package:game_app/routes.dart';


void main() => runApp(MaterialApp(
  title: "The Game",
  initialRoute: '/testing_ground', // To override the default of '/'
  routes: routes,
  theme: getTheme(name: "chung"),
));