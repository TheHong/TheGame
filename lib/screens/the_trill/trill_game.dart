import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';
import 'package:game_app/screens/the_trill/components/prompter.dart';
import 'package:game_app/screens/the_trill/components/minikey_pressor.dart';
import 'package:game_app/screens/the_trill/components/submit_button.dart';
import 'package:game_app/screens/the_trill/components/title_bar.dart';
import 'package:provider/provider.dart';

class TrillGame extends StatefulWidget {
  @override
  _TrillGameState createState() => _TrillGameState();
}

class _TrillGameState extends State<TrillGame> {
  TheTrillCore trillCore = TheTrillCore();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TheTrillCore>(
        create: (context) => trillCore,
        child: Scaffold(
            backgroundColor: Colors.green[100],
            appBar: AppBar(
              title: Text("The Trill", style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.green[100],
              elevation: 0,
              actions: <Widget>[
                Visibility(
                  visible: trillCore.isDebugMode,
                  child: IconButton(
                    icon: Icon(Icons.directions_run),
                    onPressed: () {
                      trillCore.run();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.bug_report,
                    color: trillCore.isDebugMode ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      trillCore.isDebugMode = !trillCore.isDebugMode;
                    });
                  },
                )
              ],
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 50),
              child: Column(
                children: <Widget>[
                  TitleBar(),
                  Prompter(),
                  MiniKeyPressor(),
                  SubmitButton(),
                ],
              ),
            )));
  }
}
