import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:game_app/screens/the_icon/components/group.dart';
import 'package:provider/provider.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Consumer<TheIconCore>(builder: (context, iconCore, child) {
      return iconCore.currIconBoard == null
          ? Container(
              child: SpinKitPouringHourglass(
                color: Colors.white,
                size: 100.0,
              ),
            )
          : Column(
              children: <Widget>[
                Group(
                    iconGroup: iconCore.currIconBoard.question,
                    isButton: true,
                    height: screen.height * Constant.QUESTIONS_SIZE_FACTOR_ICON,
                    groupMargins: EdgeInsets.symmetric(horizontal: 10),
                    groupPadding: EdgeInsets.all(5),
                    curveRadius: 30,
                    numIconsPerRow: 10,
                    // groupColor: Colors.white,
                    highlightID: iconCore.currIconBoard.currQuestionIdx,
                    buttonColor: Colors.black26,
                    onPressed: (TheIconCore iconCore, int idx) {
                      iconCore.selectQuestion(idx);
                    }),
                Group(
                    iconGroup: iconCore.currIconBoard.options,
                    isButton: true,
                    height: screen.height * Constant.OPTIONS_SIZE_FACTOR_ICON,
                    groupMargins: EdgeInsets.all(25),
                    groupPadding: EdgeInsets.all(10),
                    groupColor: Colors.white,
                    curveRadius: 25,
                    numIconsPerRow: 10,
                    onPressed: (TheIconCore iconCore, int idx) {
                      iconCore.selectOption(idx);
                    }),
                Group(
                  iconGroup: iconCore.currIconBoard.answer,
                  isButton: true,
                  numIconsPerRow: 15,
                ),
              ],
            );
    });
  }
}
