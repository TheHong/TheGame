import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_app/models/constants.dart';

class Result {
  String name;
  String game;
  double score;
  double additionalScore;
  Timestamp timestamp;
  Result({
    this.name,
    this.game,
    this.score,
    this.timestamp,
    this.additionalScore = Constant.DEFAULT_NO_ADDITIONAL_SCORE,
  });
  Map toMap() => {
        Constant.FIREBASE_RESULTS_NAME_KEY: name,
        Constant.FIREBASE_RESULTS_SCORE_KEY: score,
        Constant.FIREBASE_RESULTS_TIMESTAMP_KEY: timestamp,
        Constant.FIREBASE_RESULTS_SCORE2_KEY: additionalScore
      };
}

List<Result> getSampleResults() {
  Timestamp stamp = Timestamp.now();
  return [
    Result(name: "Anna", score: 10, game: "The Game", timestamp: stamp),
    Result(name: "Bob", score: 9, game: "The Game", timestamp: stamp),
    Result(name: "Carl", score: 8, game: "The Game", timestamp: stamp),
    Result(name: "Carl", score: 7, game: "The Game", timestamp: stamp),
    Result(name: "Diana", score: 6, game: "The Game", timestamp: stamp),
    Result(name: "Anna", score: 1, game: "The Game", timestamp: stamp),
  ];
}

List<int> getRanking(List<Result> sortedResults) {
  // sortedResults must be sorted from highest to lowest
  List<int> ranking = [];
  int prevRank = 0;
  double prevScore = -100;
  int tieLength = 0;
  for (Result result in sortedResults) {
    if (result.score == prevScore) {
      // If there's a tie
      tieLength += 1;
    } else {
      // If there is no tie
      prevRank += tieLength + 1;
      tieLength = 0;
    }
    prevScore = result.score;
    ranking.add(prevRank);
  }
  return ranking;
}
