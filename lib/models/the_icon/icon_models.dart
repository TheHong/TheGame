/* 
Terminology for The Icon:
An Icon is an Icon.
An Icon Group is a group of Icons. There are two types of Groups:
  1. The Groups that is displayed for the user to memorize and later fill in.
  2. The Groups that is given to the user to choose.
An Icon Board is the combination of both Groups and is responsible for checking correctness.
An Icon List contains information about all the available icons for this game.
*/

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

  IconGroup({
    @required this.codepoints,
    bool isAllVisible = true,
    bool isAllActive = true,
  }) {
    _visibilities = List.filled(codepoints.length, isAllVisible);
    _activities = List.filled(codepoints.length, isAllActive);
  }

  int get length => codepoints.length;
  bool isVisible(int idx) => _visibilities[idx];
  bool isActive(int idx) => _activities[idx];

  void deactivate(int idx) {
    _activities[idx] = false;
  }
  void activate(int idx) {
    _activities[idx] = false;
  }
}

class IconBoard {
  IconGroup question; // Icons to be filled in
  IconGroup options; // Icons to choose from
  int currQuestionIdx =
      -1; // Index of the current icon (wrt to the question IconGroup) to which player must choose the correct icon from the options

  IconBoard({
    @required this.question,
    @required IconList iconList,
  }) {
    // Copy the icons to be recalled
    List<int> optionCodepoints = question.codepoints.sublist(0);

    // Add in random icons and shuffle
    int newCodepoint;
    while (optionCodepoints.length < 2 * question.length) {
      newCodepoint = iconList.getRandomCodepoints(n: 1)[0];
      if (!optionCodepoints.contains(newCodepoint)) {
        optionCodepoints.add(newCodepoint);
      }
    }
    optionCodepoints.shuffle();

    // Create icongroup
    options = IconGroup(codepoints: optionCodepoints, isAllVisible: true);
  }
}

Widget displayGroup(BuildContext context, IconGroup iconGroup, bool isButton) {
  // TODO: tobe deleted
  const double boardPadding = 10;
  const double iconPadding = 8;
  const int numIconsPerRow = 10;
  Size screen = MediaQuery.of(context).size;
  double iconSize =
      (screen.width - 2 * boardPadding - 2 * numIconsPerRow * iconPadding) /
          numIconsPerRow;

  // Split icons into rows
  List<List<int>> iconGrid = [];
  for (int idx = 0; idx < iconGroup.length; idx++) {
    if (idx % numIconsPerRow == 0) iconGrid.add([]);
    iconGrid.last.add(iconGroup.codepoints[idx]);
  }

  return Padding(
    padding: const EdgeInsets.all(boardPadding),
    child: Container(
      height: 3 * iconSize * iconGrid.length,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: iconGrid.length,
        itemBuilder: (context, rowNum) {
          return Container(
            height: iconSize * 2,
            color: Colors.red[50],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: iconGrid[rowNum].length,
              itemBuilder: (context, index) {
                int idxGlobal = rowNum * numIconsPerRow + index;
                return isButton
                    ? MaterialIconButton(
                        codepoint: iconGrid[rowNum][index],
                        size: iconSize,
                        padding: iconPadding,
                        iconVisibility: iconGroup.isVisible(idxGlobal),
                        onPressed: iconGroup.isActive(idxGlobal)
                            ? () {
                                print("${iconGrid[rowNum][index]} preessed!");
                                iconGroup.deactivate(idxGlobal);
                              }
                            : null,
                      )
                    : Icon(
                        IconData(
                          iconGroup.codepoints[index],
                          fontFamily: 'MaterialIcons',
                        ),
                      );
              },
            ),
          );
        },
      ),
    ),
  );
}
