import 'package:flutter/material.dart';
import 'package:game_app/components/result_widgets.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/models/results.dart';

class ResultsPage extends StatelessWidget {
  final GameCore gameCore;
  ResultsPage(this.gameCore);

  @override
  Widget build(BuildContext context) {
    List<int> ranking = getRanking(gameCore.historicalResults);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.home),
            iconSize: 40,
            onPressed: () {
              // Doesn't create new home screen. It just pops the result screen
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Try Again"),
              onPressed: () {
                Navigator.popAndPushNamed(context, gameCore.getGamePath());
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Visibility(
              visible: gameCore.newIndex != -1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  gameCore.prompt,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.white, Colors.white]),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Final Score",
                    style: TextStyle(color: Colors.black26, fontSize: 20),
                  ),
                  Text(
                    "${gameCore.score.toStringAsFixed(gameCore.getNumDecPlaces())}",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Visibility(
                    visible: gameCore.additionalScore !=
                        Constant.DEFAULT_NO_ADDITIONAL_SCORE,
                    child: Text(
                      "(${gameCore.additionalScore.toStringAsFixed(0)} correct)",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: gameCore.historicalResults.length,
                      itemBuilder: (context, index) {
                        return getResultItem(
                          rank: ranking[index],
                          index: index,
                          result: gameCore.historicalResults[index],
                          indexBeEmphasized: gameCore.newIndex,
                          numDecPlaces: gameCore.getNumDecPlaces(),
                        );
                      }),
                ),
              ),
            ),
          ],
        ));
  }
}
