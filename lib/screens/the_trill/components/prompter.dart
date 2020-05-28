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
    return Consumer<TheTrillCore>(builder: (context, trillCore, child) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0, bottom: 75),
        child: Column(
          children: <Widget>[
            Text(
              trillCore.prompt,
              style: TextStyle(fontSize: 20.0),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ProgressBar(
                score: trillCore.score,
                topLeftCoords: [0, 0],
                height: 20,
                length: 300,
                checkpoints: [10, 20, 30, 40],
              ),
            ),
          ],
        ),
      );
    });
  }
}
