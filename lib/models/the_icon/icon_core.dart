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
  IconGroup currOptions;
  Phase phase = Phase.preGame;
  double score = 1; // The score represents the round number

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
      currOptions = IconGroup(iconList.getRandomCodepoints(n: score.toInt()));
      currIconBoard = IconBoard(currOptions, iconList);
      // notifyListeners();

      // Remembering phase

      // Recalling Phase

      isGameDone = true; // To be removed
    }
    print("Game Complete!");
  }

  

  @override
  String getDebugInfo() {
    return "";
  }
}
