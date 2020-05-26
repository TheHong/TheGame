

import 'package:flutter/material.dart';
import 'package:game_app/models/user.dart';

Widget getSmallMedalResultItem(int rank, Result result) {
  assert(rank <= 3, "One does not get a medal if the rank is more than 3");
  return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: getMedalItem(rank, 10),
      ),
      Text(result.name),
    ],
  );
}

Widget getMedalItem(int rank, double medalSize) {
  assert(rank <= 3, "One does not get a medal if the rank is more than 3");
  List<Color> gradientColours;
  switch (rank) {
    case 1: // Gold
      {
        gradientColours = [Colors.amber[800], Colors.yellow];
      }
      break;
    case 2: // Silver
      {
        gradientColours = [Colors.grey[700], Colors.blueGrey[100]];
      }
      break;
    case 3: // Bronze
      {
        gradientColours = [Colors.brown, Colors.orange];
      }
  }
  return Container(
    width: medalSize,
    height: medalSize,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: gradientColours,
      ),
      shape: BoxShape.circle,
    ),
  );
}

Widget getResultItem(int rank, Result result) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: rank % 2 == 0
                ? [Colors.deepPurple[50], Colors.deepPurple[100]]
                : [Colors.indigo[50], Colors.indigo[100]],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: rank <= 3
                  ? getMedalItem(rank, 50)
                  : Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text("$rank.", style: TextStyle(fontSize: 25)),
                    ),
            ),
            Expanded(
                child: Text(result.name,
                    style: TextStyle(fontSize: rank <= 3 ? 35 : 25))),
            Text("${result.score}",
                style: TextStyle(
                    fontSize: rank <= 3 ? 35 : 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        )),
  );
}
