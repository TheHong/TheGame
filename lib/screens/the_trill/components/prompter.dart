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
    const double progressBarHeight = 20;
    return Consumer<TheTrillCore>(builder: (context, trillCore, child) {
      return Padding(
        padding: const EdgeInsets.only(top: progressBarHeight, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              trillCore.prompt,
              style: TextStyle(fontSize: 20.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                top:
                    progressBarHeight + MediaQuery.of(context).size.height / 15,
                bottom: 50,
              ),
              child: Align(
                alignment: Alignment.center,
                child: ProgressBar(
                  score: trillCore.score,
                  centerCoords: [0, 0],
                  height: progressBarHeight,
                  length: (MediaQuery.of(context).size.width - 10 * 2) *
                      0.9, // 10 is the side paddings
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
