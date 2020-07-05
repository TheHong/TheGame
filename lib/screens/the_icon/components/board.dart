import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:game_app/screens/the_icon/components/group.dart';
import 'package:provider/provider.dart';

class Board extends StatefulWidget {
  /// A Group object displays the current IconBoard given by the IconCore.
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Consumer<TheIconCore>(builder: (context, iconCore, child) {
      return iconCore.phase == Phase.PRE_GAME
          ? Expanded(
              child: Container()) // TODO: Check if this is doing anything
          : iconCore.phase == Phase.LOADING
              ? Container(
                  child: SpinKitPouringHourglass(
                    color: Colors.white,
                    size: 100.0,
                  ),
                )
              : Column(
                  children: <Widget>[
                    Visibility(
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      visible: [Phase.REMEMBER, Phase.RECALL, Phase.EVALUATE]
                          .contains(iconCore.phase),
                      child: Group(
                        iconGroup: iconCore.phase == Phase.REMEMBER
                            ? iconCore.currIconBoard.answer
                            : iconCore.currIconBoard.question,
                        height:
                            screen.height * Constant.QUESTIONS_SIZE_FACTOR_ICON,
                        groupMargins: EdgeInsets.symmetric(horizontal: 10),
                        groupPadding: EdgeInsets.all(5),
                        curveRadius: 30,
                        numIconsPerRow: 10,
                        iconColor: Colors.white,
                        disabledIconColor: Colors.white,
                        buttonColor: Colors.black26,
                        onPressed: (TheIconCore iconCore, int idx) {
                          iconCore.selectQuestion(idx);
                        },
                        groupColor: Colors.blue[50],
                      ),
                    ),
                    Visibility(
                      maintainSize: true,
                      maintainState: true,
                      maintainAnimation: true,
                      visible: iconCore.phase == Phase.RECALL,
                      child: Group(
                          iconGroup: iconCore.currIconBoard.options,
                          height:
                              screen.height * Constant.OPTIONS_SIZE_FACTOR_ICON,
                          groupMargins: EdgeInsets.all(25),
                          groupPadding: EdgeInsets.all(10),
                          groupColor: Colors.white,
                          curveRadius: 25,
                          numIconsPerRow: 10,
                          onPressed: (TheIconCore iconCore, int idx) {
                            iconCore.selectOption(idx);
                          }),
                    ),
                    Group(
                      // TODO: For debugging purposes
                      iconGroup: iconCore.currIconBoard.answer,
                      numIconsPerRow: 15,
                    ),
                  ],
                );
    });
  }
}
