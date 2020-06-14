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

class IconItem {
  int codepoint;
  bool isVisible;
  bool isActive;
  bool isChosen = false;
  IconItem({
    @required this.codepoint,
    this.isVisible = true,
    this.isActive = true,
  });
}

class IconGroup {
  // An IconGroup consists of a group of Icon Items, either the ones from which the player chooses, or the ones to be filled
  List<IconItem> iconItems;
  IconGroup({
    @required List<int> codepoints,
    bool isAllVisible = true,
    bool isAllActive = true,
  }) {
    iconItems = List<IconItem>.generate(
      codepoints.length,
      (i) => IconItem(
        codepoint: codepoints[i],
        isVisible: isAllVisible,
        isActive: isAllActive,
      ),
    );
  }

  int get length => iconItems.length;
  bool isVisible(int idx) => iconItems[idx].isVisible;
  bool isActive(int idx) => iconItems[idx].isActive;
  int get earliestHidden =>
      iconItems.indexWhere((iconItem) => !iconItem.isActive);

  void deactivate(int idx) {
    iconItems[idx].isActive = false;
  }

  void activate(int idx) {
    iconItems[idx].isActive = true;
  }

  void hide(int idx) {
    iconItems[idx].isVisible = false;
  }

  void show(int idx) {
    iconItems[idx].isVisible = true;
  }
}

class IconBoard {
  IconGroup answer; // Icons expected to be filled in
  IconGroup question; // Icons to be filled in
  IconGroup options; // Icons to choose from
  int currQuestionIdx =
      0; // Index of the current icon (wrt to the question IconGroup) to which player must choose the correct icon from the options

  IconBoard({
    @required this.answer,
    @required IconList iconList,
  }) {
    // Copy the icons to be recalled
    List<int> optionCodepoints = List<int>.generate(
      answer.length,
      (i) => answer.iconItems[i].codepoint,
    );

    // Create the question group
    //(codepoints are irrelevant here, but icons used as placeholders)
    question = IconGroup(
        codepoints: iconList.getRandomCodepoints(n: answer.length),
        isAllVisible: false);

    // Add in random icons and shuffle
    int newCodepoint;
    while (optionCodepoints.length < 2 * answer.length) {
      newCodepoint = iconList.getRandomCodepoints(n: 1)[0];
      if (!optionCodepoints.contains(newCodepoint)) {
        optionCodepoints.add(newCodepoint);
      }
    }
    optionCodepoints.shuffle();

    // Create icongroup
    options = IconGroup(codepoints: optionCodepoints, isAllVisible: true);
  }

  void selectQuestion(int idx) {
    currQuestionIdx = idx;
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
    iconGrid.last.add(iconGroup.iconItems[idx].codepoint);
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
                          iconGroup.iconItems[index].codepoint,
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
