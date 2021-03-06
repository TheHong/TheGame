import 'package:flutter/material.dart';
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
  int currRound = 0;
  double optionsFactor = 1; // Ratio of options to questions
  String buttonPrompt = ""; // Prompt to specify the usage of the main button
  int _timePerRoundStart = 2;
  int _timePerRoundEnd = 1;
  int get rememberTime => (Constant.TIME_PER_Q_ICON * currRound).toInt();
  int get recallTime => 2 * (Constant.TIME_PER_Q_ICON * currRound).toInt();
  int bonusTime = 0;
  int timeEarned;
  Color scaffoldColor = Colors.cyan[200];

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
    prompt = "Loading...";
    isGameStarted = true;
    notifyListeners();
    await iconList.loadIconInfo();

    timeEarned = 0;
    while (!isGameDone) {
      phase = Phase.PRE_ROUND;
      currRound += 1;

      // Generating icons
      currIconBoard = IconBoard(
        answer: IconGroup(
          codepoints: iconList.getRandomCodepoints(n: (currRound).toInt()),
        ),
        iconList: iconList,
        optionsFactor: optionsFactor,
      );

      // Counts down for the user right before round begins
      prompt = "Get Ready!";
      buttonPrompt = "";
      await counter.run(_timePerRoundStart,
          notifier: notifyListeners, isRedActive: false, isShow: false);

      // Remembering phase
      phase = Phase.REMEMBER;
      prompt = "Remember!";
      buttonPrompt = "Click to Recall";
      await counter.run(
        rememberTime + bonusTime,
        notifier: notifyListeners,
        isRedActive: true,
      );
      if (counter.timeElapsed < rememberTime) {
        // Gained bonus
        timeEarned = (rememberTime - counter.timeElapsed).ceil();
      } else {
        // Loss bonus
        timeEarned = (rememberTime - counter.timeElapsed).floor();
      }

      // Recalling Phase
      phase = Phase.RECALL;
      prompt = "Recall!";
      buttonPrompt = "Click to Submit";
      await counter.run(
        recallTime,
        notifier: notifyListeners,
        isRedActive: true,
      );

      // Evaluation Phase
      phase = Phase.EVALUATE;
      if (evaluateAnswer()) {
        prompt = "Correct!";
        bonusTime += timeEarned;
        score += 1;
      } else {
        isGameDone = true;
      }
      notifyListeners();
      await counter.run(_timePerRoundEnd);
    }
    print("Game Complete!");
  }

  @override
  Future gadme() async {
    phase = Phase.LOADING;
    prompt = "Loading...";
    isGameStarted = true;
    notifyListeners();
    await iconList.loadIconInfo();

    phase = Phase.PRE_ROUND;
    currRound += 1;

    // Generating icons
    currIconBoard = IconBoard(
      answer: IconGroup(
        codepoints: iconList.getRandomCodepoints(n: (currRound).toInt()),
      ),
      iconList: iconList,
      optionsFactor: optionsFactor,
    );

    // Remembering phase
    phase = Phase.REMEMBER;
    prompt = "Remember!";
    buttonPrompt = "Click to Recall";
    notifyListeners();
  }

  void selectQuestion(int idx) {
    // idx of -1 is encountered when getNextQuestion() is called but all questions are answered.

    // Deselect the previous question (if applicable)
    if (currIconBoard.currQuestionIdx != -1) {
      currIconBoard.question.iconItems[currIconBoard.currQuestionIdx]
          .borderColor = Colors.transparent;
    }
    // Select the new question
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

      // Case 3: Otherwise, continue with rest of this function

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
          currIconBoard.question.iconItems[i].idxLink != -1 && // A link exists
          currIconBoard.answer.iconItems[i].codepoint ==
              currIconBoard.question.iconItems[i].codepoint, // Link is correct
    );

    // Change border colours to reflect evaluation results
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

class TheIconsCore extends TheIconCore {
  double optionsFactor = Constant.OPTIONS_FACTOR_ICONS;
  Color scaffoldColor = Colors.cyan;
  int get rememberTime => (Constant.TIME_PER_Q_ICONS * currRound).toInt();
  int get recallTime => 2 * (Constant.TIME_PER_Q_ICONS * currRound).toInt();
  @override
  String getGameName() => "The Icons";
  @override
  String getGamePath() => "/the_icons";
  @override
  String getInstructions() => Constant.INSTRUCTIONS_ICONS;
}
