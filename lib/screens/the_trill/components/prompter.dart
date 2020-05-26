import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';

class Prompter extends StatefulWidget {
  @override
  _PrompterState createState() => _PrompterState();
}


// TODO: Change timer to https://medium.com/flutterdevs/creating-a-countdown-timer-using-animation-in-flutter-2d56d4f3f5f1
class _PrompterState extends State<Prompter> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TheTrillCore>(builder: (context, trillCore, child) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              trillCore.prompt,
              style: TextStyle(fontSize: 20.0),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              color: Colors.green[200],
              child: Text("Time Left: ${trillCore.counter.currCount}",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: trillCore.counter.colour)),
            ),
          ],
        ),
      );
    });
  }
}
