import 'package:flutter/material.dart';
import 'package:game_app/components/progress_bar.dart';
import 'package:game_app/models/game_core.dart';
import 'package:provider/provider.dart';

class Prompter extends StatefulWidget {
  @override
  _PrompterState createState() => _PrompterState();
}

class _PrompterState extends State<Prompter> {
  @override
  Widget build(BuildContext context) {
    const double progressBarHeight = 20; // Does not adapt with screen size
    Size screen = MediaQuery.of(context).size;
    return Consumer<TheTrillCore>(builder: (context, trillCore, child) {
      return Padding(
        padding: const EdgeInsets.only(
            top: progressBarHeight, bottom: progressBarHeight),
        child: Column(
          children: <Widget>[
            Text(
              trillCore.prompt,
              style: TextStyle(fontSize: 20.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: progressBarHeight + screen.height / 15,
                bottom: screen.height * 0.15,
              ),
              child: Align(
                alignment: Alignment.center,
                child: progressBar(
                  score: trillCore.score,
                  centerCoords: [0, 0],
                  height: progressBarHeight,
                  length: screen.width * 0.9,
                  checkpoints: trillCore.getCheckpoints(),
                  numDecPlaces: trillCore.getNumDecPlaces(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
