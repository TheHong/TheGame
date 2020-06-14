import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
                    numIconsPerRow: 10,
                    highlightID: iconCore.currIconBoard.currQuestionIdx,
                    onPressed: (TheIconCore iconCore, int idx) {
                      iconCore.currIconBoard.selectQuestion(idx);
                      iconCore.notifyListeners();
                    }),
                Group(
                    iconGroup: iconCore.currIconBoard.options,
                    isButton: true,
                    numIconsPerRow: 10,
                    onPressed: (TheIconCore iconCore, int idx) {
                      iconCore.selectOption(idx);
                    }),
              ],
            );
    });
  }
}
