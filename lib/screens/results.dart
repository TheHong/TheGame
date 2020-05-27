import 'package:flutter/material.dart';
import 'package:game_app/components/result_widgets.dart';
import 'package:game_app/models/game_core.dart';

class ResultsPage extends StatelessWidget {
  final GameCore gameCore;
  ResultsPage(this.gameCore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.home),
            iconSize: 40,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            FlatButton(child: Text("Try Again"), onPressed: (){
              Navigator.popAndPushNamed(context, '/the_pitch');
            },)
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                gameCore.result.score == -1 ? "" : gameCore.prompt,
                style: TextStyle(color: Colors.black, fontSize: 25),
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
                    "${gameCore.score.toStringAsFixed(3)}",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: gameCore.historicalResults.length,
                    itemBuilder: (context, index) {
                      return getResultItem(
                        index + 1,
                        gameCore.historicalResults[index],
                        rankBeEmphasized: gameCore.newRank,
                      );
                    }),
              ),
            ),
            // getResultItem(1, gameCore.historicalResults[0])
          ],
        ));
  }
}
