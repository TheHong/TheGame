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
  double score = 11; // The score represents the round number

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
    // Set the question element to the option element
    currIconBoard.question.iconItems[idxQuestion].codepoint =
        currIconBoard.options.iconItems[idxOption].codepoint;
    // Show the question element and deactivate option element
    currIconBoard.question.show(idxQuestion);
    currIconBoard.options.deactivate(idxOption);
    // Move the current question to another question element
    currIconBoard.currQuestionIdx =
        currIconBoard.currQuestionIdx + 1 < currIconBoard.question.length
            ? currIconBoard.currQuestionIdx + 1
            : currIconBoard.question.earliestHidden;

    // Check if correct (Change: Correctness checked when user submits are time runs out)
    // if (currIconBoard.options.codepoints[idxOption] ==
    //     currIconBoard.question.codepoints[idxQuestion]) {
    //   currIconBoard.options.deactivate(idxOption);
    //   currIconBoard.question.show(idxQuestion);
    //   currIconBoard.currQuestionIdx =
    //       currIconBoard.currQuestionIdx + 1 < currIconBoard.question.length
    //           ? currIconBoard.currQuestionIdx + 1
    //           : currIconBoard.question.earliestHidden; // TODO: TO TEST
    //   print(currIconBoard.currQuestionIdx);
    // }
    notifyListeners();
  }

  @override
  String getDebugInfo() {
    return "";
  }
}