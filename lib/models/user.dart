import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  String name;
  String game;
  double score;
  Timestamp timestamp;
  Result({this.name, this.game, this.score, this.timestamp});
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
