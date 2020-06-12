import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IconList {
  String iconCodePointsFile = "assets/icon_codepoints.txt";
  List<String> iconInfo = [];
  final _random = Random();
  Future loadIconInfo() async {
    try {
      String fileData = await rootBundle.loadString(iconCodePointsFile);
      iconInfo = fileData.split("\n");
    } on FlutterError {
      print("File not found!!!!!!!!!!!!!!!!!!");
    }
  }

  int get length => iconInfo.length;

  int getCodepoint(int idx) =>
      int.parse(iconInfo[idx].split(" ")[1], radix: 16);

  List<int> getRandomCodepoints({int n}) =>
      List<int>.generate(n, (_) => getCodepoint(_random.nextInt(length)));
}
