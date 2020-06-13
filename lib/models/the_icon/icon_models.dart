import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_app/components/custom_buttons.dart';

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

class IconGroup {
  // An IconGroup consists of a group of icons, either the ones from which the player chooses, or the ones to be filled
  List<int> codepoints;
  List<bool> _visibilities; // WHether or not it's visible
  List<bool> _activities; // Whether or not they are chosen
  IconGroup(this.codepoints,
      {bool isAllVisible = true, bool isAllActive = true}) {
    _visibilities = List.filled(codepoints.length, isAllVisible);
    _activities = List.filled(codepoints.length, isAllActive);
  }
  int get length => codepoints.length;
  bool isActive(int idx) => _visibilities[idx];
  void hide(int idx) {
    _visibilities[idx] = false;
  }

  void show(int idx) {
    _visibilities[idx] = false;
  }
}

class IconBoard {
  IconGroup query;
  IconGroup options;
  int currQueryIdx =
      -1; // Index of the current icon (wrt to the query IconGroup) to which player must choose the correct icon from the options

  IconBoard(this.options, IconList iconList) {
    // Copy the icon options
    List<int> queryCodepoints = options.codepoints.sublist(0);

    // Add in random icons and shuffle
    int newCodepoint;
    while (queryCodepoints.length < 2 * options.length) {
      newCodepoint = iconList.getRandomCodepoints(n: 1)[0];
      if (!queryCodepoints.contains(newCodepoint)) {
        queryCodepoints.add(newCodepoint);
      }
    }
    queryCodepoints.shuffle();

    // Create icongroup
    query = IconGroup(queryCodepoints, isAllVisible: false);
  }
}

Widget displayBoard(BuildContext context, IconGroup iconGroup, bool isButton) {
  // WILL take into account that higher number of icons would result in different number of rows
  const double boardPadding = 10;
  const double iconPadding = 8;
  const int numIconPerRow = 10;
  Size screen = MediaQuery.of(context).size;
  double iconSize =
      (screen.width - 2 * boardPadding - 2 * numIconPerRow * iconPadding) /
          numIconPerRow;

  return Padding(
    padding: const EdgeInsets.all(boardPadding),
    child: Container(
      height: iconSize * 2,
      color: Colors.green,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: iconGroup.length,
        itemBuilder: (context, index) {
          return iconGroup.isActive(index)
              ? isButton
                  ? MaterialIconButton(
                      codepoint: iconGroup.codepoints[index],
                      size: iconSize,
                      padding: iconPadding,
                      onPressed: () {
                        print("${iconGroup.codepoints[index]} preessed!");
                      },
                    )
                  : Icon(IconData(iconGroup.codepoints[index],
                      fontFamily: 'MaterialIcons'))
              : Text(
                  "_",
                  style: TextStyle(fontSize: 12),
                );
        },
      ),
    ),
  );
}
