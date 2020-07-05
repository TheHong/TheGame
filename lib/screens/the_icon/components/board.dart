import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:game_app/screens/the_icon/components/group.dart';
import 'package:provider/provider.dart';

class Board extends StatefulWidget {
  /// A Group object displays the current IconBoard given by the IconCore.
  final int numIconsPerRow = 8;
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Consumer<TheIconCore>(builder: (context, iconCore, child) {
      return iconCore.phase == Phase.PRE_GAME
          ? Expanded(child: Container())
          : iconCore.phase == Phase.LOADING
              ? Container(
                  child: SpinKitCubeGrid(
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
                        numIconsPerRow: widget.numIconsPerRow,
                        height:
                            screen.height * Constant.QUESTIONS_SIZE_FACTOR_ICON,
                        alignment: Alignment.center,
                        groupMargins: EdgeInsets.symmetric(horizontal: 10),
                        groupPadding: EdgeInsets.all(5),
                        iconMargins: 5,
                        curveRadius: 30,
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
                      maintainSize: !iconCore.isGameDone,
                      maintainState: !iconCore.isGameDone,
                      maintainAnimation: !iconCore.isGameDone,
                      visible: iconCore.phase == Phase.RECALL,
                      child: Group(
                          iconGroup: iconCore.currIconBoard.options,
                          numIconsPerRow: widget.numIconsPerRow,
                          height:
                              screen.height * Constant.OPTIONS_SIZE_FACTOR_ICON,
                          alignment: Alignment.centerLeft,
                          groupMargins: EdgeInsets.all(25),
                          groupPadding: EdgeInsets.all(10),
                          groupColor: Colors.white,
                          curveRadius: 25,
                          onPressed: (TheIconCore iconCore, int idx) {
                            iconCore.selectOption(idx);
                          }),
                    ),
                    Visibility(
                      visible: iconCore.isGameDone,
                      child: Group(
                          iconGroup: iconCore.currIconBoard.answer,
                          numIconsPerRow: widget.numIconsPerRow,
                          height: screen.height / 8,
                          disabledIconColor: Colors.black,
                          alignment: Alignment.center,
                          groupMargins: EdgeInsets.symmetric(
                            vertical: 25,
                            horizontal: 35,
                          ),
                          groupPadding: EdgeInsets.all(10),
                          groupColor: iconCore.scaffoldColor,
                          curveRadius: 25,
                          onPressed: (TheIconCore iconCore, int idx) {
                            iconCore.selectOption(idx);
                          }),
                    ),
                  ],
                );
    });
  }
}
