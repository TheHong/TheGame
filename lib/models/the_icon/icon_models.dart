/* 
Terminology for The Icon:
An Icon Item is an object containing info of Icon.
An Icon Group is a group of Items. There are two types of Groups:
  1. The Answer Group: given to the user to choose. 
  2. The Question Group: displayed for the user to memorize and later fill in.
An Icon Board is the combination of both Groups and is responsible for checking correctness.
An Icon List contains information about all the available icons for this game.

In the beginning, all the question items are unassigned; here the question item icons are not visible.
(Visibility of a question item determines whether or not it has been assigned).
When an answer item is answered to a question item, the answer item will change icon colour
while the question item will match the icon of the answer item.
*/

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_app/models/constants.dart';

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

  int getRandomCodepoint() => getCodepoint(_random.nextInt(length));

  List<int> getRandomCodepoints({int n}) =>
      List<int>.generate(n, (_) => getRandomCodepoint());
}

class IconItem {
  int codepoint;
  int idxLink = -1; // To relate icon item to a particular index
  bool isVisible;
  bool isChosen = false;
  Color borderColor = Colors.transparent;
  IconItem({
    @required this.codepoint,
    this.isVisible = true,
  });
}

class IconGroup {
  // An IconGroup consists of a group of Icon Items, either the ones from which the player chooses, or the ones to be filled
  List<IconItem> iconItems;
  IconGroup({
    @required List<int> codepoints,
    bool isAllVisible = true,
  }) {
    iconItems = List<IconItem>.generate(
      codepoints.length,
      (i) => IconItem(
        codepoint: codepoints[i],
        isVisible: isAllVisible,
      ),
    );
  }

  int get length => iconItems.length;
  bool isVisible(int idx) => iconItems[idx].isVisible;

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
    @required double optionsFactor,
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
      isAllVisible: false,
    );
    question.iconItems.first.borderColor = Constant.SELECT_COLOUR_ICON;

    // Add in random icons and shuffle
    int newCodepoint;
    while (optionCodepoints.length < optionsFactor * answer.length) {
      newCodepoint = iconList.getRandomCodepoint();
      if (!optionCodepoints.contains(newCodepoint)) {
        optionCodepoints.add(newCodepoint);
      }
    }
    optionCodepoints.shuffle();

    // Create icongroup
    options = IconGroup(codepoints: optionCodepoints, isAllVisible: true);
  }

  int getNextQuestion() {
    int nextIdx = question.iconItems.indexWhere(
      (iconItem) => iconItem.idxLink == -1,
      currQuestionIdx,
    );
    nextIdx = nextIdx != -1
        ? nextIdx
        : question.iconItems.indexWhere(
            (iconItem) => iconItem.idxLink == -1,
          );
    return nextIdx;
  }
}
