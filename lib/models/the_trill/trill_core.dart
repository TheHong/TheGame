import 'package:game_app/models/constants.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/models/the_trill/mini_keyboard.dart';

class TheTrillCore extends GameCore {
  static int _timePerRound = Constant.TIME_PER_ROUND_TRILL;
  static int _timePerRoundEnd = Constant.TIME_PER_ROUND_END_TRILL;

  MiniKeyboard keyboard = MiniKeyboard();

  TheTrillCore() {
    prompt = "Loading Game...";
    keyboard.deactivate();
    loadFirestoreData(onDone: () {
      prompt = "Start trilling to start the game!";
      counter.currCount = _timePerRound;
      keyboard.activate();
    });
    print("$this Initiated");
  }

  @override
  String getGameName() => "The Trill";
  @override
  String getGamePath() => "/the_trill";
  @override
  int getNumDecPlaces() => 0;
  @override
  String getInstructions() => Constant.INSTRUCTIONS_TRILL;

  @override
  Future game() async {
    // Game  ----------------------------------------------------------------
    // Start Round
    isGameStarted = true;
    prompt = "TRILL!";
    notifyListeners();

    // Give player a certain amount of time to do the trills
    await counter.run(_timePerRound,
        notifier: notifyListeners, boolInterrupt: boolInterrupt);
    keyboard.deactivate();

    // Pause for user to get result feedback --------------------------------
    prompt = "Final Score: ${score.toStringAsFixed(getNumDecPlaces())}";
    isGameDone = true;
    notifyListeners();
    await counter.run(_timePerRoundEnd);

    print("The Trill Game Completed");
  }

  String getDebugInfo() {
    return "score: $score\n" +
        "keyboard active: ${keyboard.isActive}\n" +
        "previous tap: ${keyboard.prevTap}\n" +
        "game done: $isGameDone";
  }
}
