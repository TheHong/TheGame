

class Result{
  String name;
  String game;
  double score;
  Result({this.name, this.game, this.score});
}

List<Result> getSampleResults(){
  return [
    Result(name: "Anna", score: 10, game: "The Pitch?"),
    Result(name: "Bob", score: 9, game: "The Pitch?"),
    Result(name: "Carl", score: 8.5, game: "The Pitch?"),
    Result(name: "Carl", score: 8, game: "The Pitch?"),
    Result(name: "Diana", score: 1, game: "The Pitch?"),
    Result(name: "Anna", score: 1, game: "The Pitch?"),
  ];
}