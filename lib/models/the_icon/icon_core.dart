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
    // TODO: Could make more elegant
    int idxQuestion = currIconBoard.currQuestionIdx;
    IconItem questionItem = currIconBoard.question.iconItems[idxQuestion];
    IconItem optionItem = currIconBoard.options.iconItems[idxOption];
    int selectIncrement =
        1; // Determines where the selection should be after the current selection is processed

    // Case 1: If option has not been used before
    if (!optionItem.isChosen) {
      // If the question was already assigned to another item
      if (questionItem.isVisible) {
        // Find where the question is currently assigned
        int otherOidx = questionItem.idxLink;
        IconItem otherO = currIconBoard.options.iconItems[otherOidx];

        // Update the other option
        otherO.isChosen = false;
        otherO.idxLink = -1;
      }

      // Set the question element to have same icon as the option element
      questionItem.codepoint = optionItem.codepoint;

      // Update the elements
      optionItem.isChosen = true;
      questionItem.isVisible = true;
    }
    // Case 2: If option has already been used
    else {
      // Find where the option was previously used
      int pastQidx = optionItem.idxLink;
      IconItem pastQ = currIconBoard.question.iconItems[pastQidx];

      // If the question was already assigned to another item
      if (questionItem.isVisible) {
        // Case 2a: If option is already assigned to the current question
        if (pastQidx == idxQuestion) {
          optionItem.isChosen = false;
          optionItem.idxLink = -1;
          questionItem.isVisible = false;
          questionItem.idxLink = -1;
          selectIncrement = 0;

          // Case 2b: If another option is assigned to the current question
        } else {
          // Find where the question is currently assigned
          int otherOidx = questionItem.idxLink;
          IconItem otherO = currIconBoard.options.iconItems[otherOidx];

          // Update the other option and past question with new link
          otherO.idxLink = pastQidx; 
          pastQ.idxLink = otherOidx;// <-- Shouldn't change the link since option doesn't move

          // Perform the swap
          currIconBoard.question.iconItems[idxQuestion] = pastQ;
          currIconBoard.question.iconItems[pastQidx] = questionItem;
        }
      }
    }
    // In both case, link the question with option
    optionItem.idxLink = idxQuestion; // <-- This probably is in the wrong place
    questionItem.idxLink = idxOption;

    // Move the current question to another question element
    currIconBoard.currQuestionIdx =
        currIconBoard.currQuestionIdx + selectIncrement <
                currIconBoard.question.length
            ? currIconBoard.currQuestionIdx + selectIncrement
            : currIconBoard.question.earliestHidden;

    notifyListeners();
  }

  @override
  String getDebugInfo() {
    return "";
  }
}
