import 'package:game_app/models/constants.dart';
import 'package:game_app/models/game_core.dart';

class TheIconCore extends GameCore {
  @override
  String getGameName() => "The Icon";
  @override
  String getGamePath() => "/the_icon";
  @override
  int getNumDecPlaces() => 0;
  @override
  String getInstructions() => Constant.INSTRUCTIONS_ICON;

  @override
  Future game() {}

  @override
  String getDebugInfo() {
    return "";
  }
}
