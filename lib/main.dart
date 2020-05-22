import 'package:flutter/material.dart';
import 'package:game_app/pages/home.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/', // To override the default of '/'
  routes: {
    '/': (context) => Home(),
  }
));