class Constant {
  // Overall ==================================================================
  static const int LEADERBOARD_SIZE = 10;

  // Firebase =================================================================
  static const String FIREBASE_COLLECTION_NAME = "The Game v1.0";
  static const String FIREBASE_RESULTS_DOCUMENT_NAME = "results";
  static const String FIREBASE_STATS_DOCUMENT_NAME = "stats";

  // The Pitch ================================================================
  static const int NUM_ROUNDS_PITCH = 10;
  static const int TIME_PER_ROUND_PITCH = 10; // Duration of each round
  static const int TIME_PER_ROUND_START_PITCH =
      3; // Duration of the countdown to the start of the round
  static const int TIME_PER_ROUND_END_PITCH =
      3; // Duration at the end of each round before the countdown of next round
  static const String INSTRUCTIONS_PITCH =
      "The point of this game is to be able to choose the note that corresponds to the note being played as quickly as possible." +
          " For each round, one note will be played. You will have $TIME_PER_ROUND_PITCH seconds to guess the note by pressing one of the keys on the keyboard." +
          " The faster you choose the note correctly, the more points you earn." +
          " However, if the answer is incorrect, then no points will be awarded." +
          " There will be $NUM_ROUNDS_PITCH rounds." +
          " At the start of the game, the keyboard is activated and you may press the keys to hear what notes sound like." +
          " To start the game, press the 'Begin' button below the keyboard." +
          " Once the round starts and the note is played, you may press the giant musical note icon to replay the note.";

  // The Trill ================================================================
  static const int TIME_PER_ROUND_TRILL = 15;
  static const int TIME_PER_ROUND_END_TRILL = 3;
  static const String INSTRUCTIONS_TRILL =
      "The point of the game is to tap the two keys successively as many times as possible: " +
          "this is the piano trill. The bar at the top gives an indication of where you are at with respect to the leaderboard." +
          " The green marker represents level needed to make it onto the leaderboard. The other three represents the bronze, silver, and gold results." +
          " You will have $TIME_PER_ROUND_TRILL seconds to do as many taps as possible.";
}
