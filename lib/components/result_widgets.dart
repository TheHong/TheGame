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

Widget getResultItem(int rank, Result result, {int rankBeEmphasized = -1}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: rank == rankBeEmphasized
              ? [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 10,
                      blurRadius: 7,
                      offset: Offset(0, 3))
                ]
              : [],
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
                      child: Text(
                        "$rank.",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: rank == rankBeEmphasized
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
            ),
            Expanded(
                child: Text(
              result.name,
              style: TextStyle(
                  fontSize: rank <= 3 ? 35 : 25,
                  fontWeight: rank == rankBeEmphasized
                      ? FontWeight.bold
                      : FontWeight.normal),
            )),
            Text("${result.score.toStringAsFixed(3)}",
                style: TextStyle(
                    fontSize: rank <= 3 ? 35 : 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        )),
  );
}

void getNamePrompter(BuildContext context, int rank) {
  double avatarRadius = 50;
  showDialog(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // To make the card compact
                    children: <Widget>[
                      Text(
                        "HELLO",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "TEXT HERE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // To close the dialog
                          },
                          child: Text("PRESS THIS"),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(backgroundImage: AssetImage("assets/silver.png"), radius: avatarRadius,)
                    // getMedalItem(rank, 45),
                  ],
                ),
              ],
            ),
          ));
}
