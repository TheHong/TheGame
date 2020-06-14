import 'package:flutter/material.dart';
import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:game_app/screens/instructions_screen.dart';
import 'package:game_app/screens/the_icon/components/board.dart';
import 'package:game_app/screens/the_icon/components/bottom_bar.dart';
import 'package:game_app/screens/the_icon/components/game_title_bar.dart';
import 'package:provider/provider.dart';

class IconGame extends StatefulWidget {
  @override
  _IconGameState createState() => _IconGameState();
}

class _IconGameState extends State<IconGame> {
  TheIconCore iconCore = TheIconCore();
  Color backgroundColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TheIconCore>(
        create: (context) => iconCore,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text("The Icon"),
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: getUpdatorBackButton(context, iconCore),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstructionsPage(iconCore),
                    ),
                  );
                },
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              GameTitleBar(),
              Board(),
              BottomBar(),
            ],
          ),
        ));
  }
}
