import 'package:flutter/material.dart';
import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:game_app/screens/instructions_screen.dart';
import 'package:game_app/screens/the_icon/components/board.dart';
import 'package:game_app/screens/the_icon/components/bottom_bar.dart';
import 'package:game_app/screens/the_icon/components/game_title_bar.dart';
import 'package:provider/provider.dart';

class IconGame extends StatefulWidget {
  /// Used for both The Icon and The Icons
  final int gameVersion; // Either 0 (for The Icon) or 1 (for The Icons)
  TheIconCore iconCore;

  // Determining whether it's The Icon or The Icons
  IconGame({Key key, @required this.gameVersion})
      : iconCore = gameVersion == 0 ? TheIconCore() : TheIconsCore(),
        super(key: key);

  @override
  _IconGameState createState() => _IconGameState();
}

class _IconGameState extends State<IconGame> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TheIconCore>(
      create: (context) => widget.iconCore,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: widget.iconCore.scaffoldColor,
        appBar: AppBar(
          title: Text(widget.iconCore.getGameName()),
          backgroundColor: widget.iconCore.scaffoldColor,
          elevation: 0,
          leading: getUpdatorBackButton(context, widget.iconCore),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstructionsPage(widget.iconCore),
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
            Expanded(child: Container()),
            BottomBar(),
          ],
        ),
      ),
    );
  }
}
