import 'package:flutter/material.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:game_app/screens/the_icon/components/board.dart';
import 'package:game_app/screens/the_icon/components/bottom_bar.dart';
import 'package:provider/provider.dart';

class IconGame extends StatefulWidget {
  @override
  _IconGameState createState() => _IconGameState();
}

class _IconGameState extends State<IconGame> {
  TheIconCore iconCore = TheIconCore();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TheIconCore>(
        create: (context) => iconCore,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Text(
                "HELLO",
                style: TextStyle(fontSize: 50),
              ),
              Board(),
              BottomBar(),
            ],
          ),
        ));
  }
}
