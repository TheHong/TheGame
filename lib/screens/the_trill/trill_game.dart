import 'package:flutter/material.dart';
import 'package:game_app/models/the_trill/trill_core.dart';
import 'package:game_app/screens/instructions_screen.dart';
import 'package:game_app/screens/the_trill/components/prompter.dart';
import 'package:game_app/screens/the_trill/components/minikey_pressor.dart';
import 'package:game_app/screens/the_trill/components/submit_button.dart';
import 'package:game_app/screens/the_trill/components/title_bar.dart';
import 'package:game_app/components/updator_back_button.dart';
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
              leading: getUpdatorBackButton(context, trillCore),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.help_outline),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstructionsPage(trillCore),
                      ),
                    );
                  },
                )
              ],
            ),
            body: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: MediaQuery.of(context).size.width / 41),
                  child: Column(
                    children: <Widget>[
                      TitleBar(),
                      Prompter(), // Contains parameters that do not adapt with screen size
                      MiniKeyPressor(),
                      SubmitButton(),
                    ],
                  ),
                )
              ],
            )));
  }
}
