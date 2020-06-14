import 'package:flutter/material.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/models/the_icon/icon_models.dart';

enum Phase {
  preGame,
  preRound,
  remember,
  recall,
}

class TheIconCore extends GameCore {
  IconList iconList = IconList();
  IconBoard currIconBoard;
  Phase phase = Phase.preGame;
  double score = 25; // The score represents the round number
  double optionsFactor = 1; // Ratio of options to questions

  @override
  String getGameName() => "The Icon";
  @override
  String getGamePath() => "/the_icon";
  @override
  int getNumDecPlaces() => 0;
  @override
  String getInstructions() => Constant.INSTRUCTIONS_ICON;

  @override
  Future game() async {
    await iconList.loadIconInfo();
    while (!isGameDone) {
      isGameStarted = true;

      // Generating icons
      currIconBoard = IconBoard(
        answer: IconGroup(
          codepoints: iconList.getRandomCodepoints(n: score.toInt()),
        ),
        iconList: iconList,
        optionsFactor: optionsFactor,
      );
      notifyListeners();

      // Remembering phase

      // Recalling Phase

      isGameDone = true; // To be removed
    }
    print("Game Complete!");
  }

  void selectQuestion(int idx) {
    currIconBoard.question.iconItems[currIconBoard.currQuestionIdx]
        .borderColor = Colors.transparent;
    currIconBoard.question.iconItems[idx].borderColor =
        Constant.SELECT_COLOUR_ICON;
    currIconBoard.currQuestionIdx = idx;
    notifyListeners();
  }

  void selectOption(int idxOption) {
    int idxQuestion = currIconBoard.currQuestionIdx;
    if (idxQuestion == -1) {
      print("None selected");
      return;
    }

    IconItem questionItem = currIconBoard.question.iconItems[idxQuestion];
    IconItem optionItem = currIconBoard.options.iconItems[idxOption];

    // Case 1: Question has already been assigned to current option
    if (optionItem.idxLink == idxQuestion) {
      // Update the current option as not chosen
      optionItem.isChosen = false;
      optionItem.idxLink = -1;
      questionItem.isVisible = false;
      questionItem.idxLink = -1;
    } else {
      // Case 2 Part 1: Question has already been assigned to another option
      if (questionItem.idxLink != -1) {
        // Update the other option as not chosen
        IconItem otherO = currIconBoard.options.iconItems[questionItem.idxLink];
        otherO.isChosen = false;
        otherO.idxLink = -1;
      }

      // Case 2 Part 2: Option has already been assigned
      if (optionItem.idxLink != -1) {
        IconItem pastQ = currIconBoard.question.iconItems[optionItem.idxLink];
        pastQ.isVisible = false;
        pastQ.idxLink = -1;
      }

      // Case 3: Otherwise, continue with rest of code

      // Set the question element to have same icon as the option element
      questionItem.codepoint = optionItem.codepoint;

      // Update the elements
      optionItem.isChosen = true;
      optionItem.idxLink = idxQuestion;
      questionItem.isVisible = true;
      questionItem.idxLink = idxOption;

      // Move the current question to another question element
      selectQuestion(currIconBoard.getNextQuestion());
    }

    notifyListeners();
  }

  void evaluateAnswer() {
    List<bool> correct = List<bool>.generate(
      currIconBoard.answer.length,
      (i) =>
          currIconBoard.question.iconItems[i].idxLink != -1 &&
          currIconBoard.answer.iconItems[i].codepoint ==
              currIconBoard.question.iconItems[i].codepoint,
    );

    for (int i = 0; i < currIconBoard.answer.length; i++) {
      currIconBoard.question.iconItems[i].borderColor =
          correct[i] ? Colors.green : Colors.red;
    }
    notifyListeners();
  }

  @override
  String getDebugInfo() {
    return "";
  }
}
