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
  double score = 10; // The score represents the round number

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
      // Generating icons
      currIconBoard = IconBoard(
        answer: IconGroup(
          codepoints: iconList.getRandomCodepoints(n: score.toInt()),
        ),
        iconList: iconList,
      );
      notifyListeners();

      // Remembering phase

      // Recalling Phase

      isGameDone = true; // To be removed
    }
    print("Game Complete!");
  }

  void selectOption(int idxOption) {
    int idxQuestion = currIconBoard.currQuestionIdx;
    if (idxQuestion == -1){
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
      currIconBoard.currQuestionIdx = currIconBoard.getNextQuestion();
    }

    notifyListeners();
  }

  @override
  String getDebugInfo() {
    return "";
  }
}
