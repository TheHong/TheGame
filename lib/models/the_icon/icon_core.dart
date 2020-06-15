import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/models/the_icon/icon_models.dart';

enum Phase {
  PRE_GAME,
  LOADING,
  PRE_ROUND,
  REMEMBER,
  RECALL,
  EVALUATE,
}

class TheIconCore extends GameCore {
  IconList iconList = IconList();
  IconBoard currIconBoard;
  Phase phase = Phase.PRE_GAME;
  double score = 0; // The score represents the number of rounds COMPLETED
  double optionsFactor = 1; // Ratio of options to questions
  int _timePerRoundStart = 3;
  int _timePerRoundEnd = 3;
  String bottomText = "";
  int get rememberTime => (3 * (score + 1)).toInt();
  int get recallTime => (5 * (score + 1)).toInt();

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
    phase = Phase.LOADING;
    notifyListeners();
    await iconList.loadIconInfo();
    isGameStarted = true;

    while (!isGameDone) {
      phase = Phase.PRE_ROUND;
      prompt = "You got ${rememberTime}s!";

      // Generating icons
      currIconBoard = IconBoard(
        answer: IconGroup(
          codepoints: iconList.getRandomCodepoints(n: (score + 1).toInt()),
        ),
        iconList: iconList,
        optionsFactor: optionsFactor,
      );
      notifyListeners();

      // Counts down for the user right before round begins
      await counter.run(_timePerRoundStart,
          notifier: notifyListeners, isRedActive: false);

      // Remembering phase
      phase = Phase.REMEMBER;
      prompt = "Remember!";
      bottomText = "Ready to Recall";
      await counter.run(rememberTime,
          notifier: notifyListeners, boolInterrupt: boolInterrupt);
      boolInterrupt.reset();

      // Recalling Phase
      phase = Phase.RECALL;
      prompt = "Recall!";
      bottomText = "Submit";
      await counter.run(recallTime,
          notifier: notifyListeners, boolInterrupt: boolInterrupt);
      boolInterrupt.reset();

      // Evaluation Phase
      phase = Phase.EVALUATE;
      if (evaluateAnswer()) {
        prompt = "Correct!";
        score += 1;
      } else {
        isGameDone = true;
      }
      // notifyListeners()
      await counter.run(_timePerRoundEnd);
    }
    print("Game Complete!");
  }

  void selectQuestion(int idx) {
    currIconBoard.question.iconItems[currIconBoard.currQuestionIdx]
        .borderColor = Colors.transparent;
    // Only change border colour if there is still an unanswered question item
    if (idx != -1) {
      currIconBoard.question.iconItems[idx].borderColor =
          Constant.SELECT_COLOUR_ICON;
    }
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

  bool evaluateAnswer() {
    bool isCorrect = true;
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
      isCorrect = isCorrect && correct[i];
    }
    notifyListeners();
    return isCorrect;
  }

  @override
  String getDebugInfo() {
    return "";
  }
}
