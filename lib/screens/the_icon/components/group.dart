import 'package:flutter/material.dart';
import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:game_app/models/the_icon/icon_models.dart';
import 'package:provider/provider.dart';

class Group extends StatelessWidget {
  final IconGroup iconGroup;
  final bool isButton;
  final EdgeInsets groupMargins;
  final EdgeInsets groupPadding;
  final double iconPadding;
  final int numIconsPerRow;
  final Function onPressed;
  final int highlightID;
  final double height;
  final double curveRadius;
  final Color groupColor;
  final Color buttonColor;

  Group({
    @required this.iconGroup,
    @required this.isButton,
    this.onPressed,
    this.highlightID = -1,
    this.groupMargins = EdgeInsets.zero,
    this.groupPadding = EdgeInsets.zero,
    this.groupColor = Colors.transparent,
    this.buttonColor,
    this.iconPadding = 8,
    this.numIconsPerRow = 10,
    this.height,
    this.curveRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double iconSize = (screen.width -
            (groupMargins.right +
                groupMargins.left +
                groupPadding.right +
                groupPadding.left) -
            2 * numIconsPerRow * iconPadding) /
        numIconsPerRow;

    // Split icons into rows
    List<List<int>> iconGrid = [];
    for (int idx = 0; idx < iconGroup.length; idx++) {
      if (idx % numIconsPerRow == 0) iconGrid.add([]);
      iconGrid.last.add(iconGroup.iconItems[idx].codepoint);
    }

    return Consumer<TheIconCore>(builder: (context, iconCore, child) {
      return Padding(
        padding: groupMargins,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(curveRadius)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(curveRadius)),
              color: groupColor,
            ),
            padding: groupPadding,
            height: height ??
                2 * (iconSize * iconGrid.length) +
                    groupPadding.top +
                    groupPadding.bottom,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: iconGrid.length,
              itemBuilder: (context, rowNum) {
                return Container(
                  height: iconSize * 2,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: iconGrid[rowNum].length,
                    itemBuilder: (context, index) {
                      int idxGlobal = rowNum * numIconsPerRow + index;
                      return isButton
                          ? MaterialIconButton(
                              codepoint: iconGrid[rowNum][index],
                              size: iconSize,
                              padding: iconPadding,
                              iconVisibility: iconGroup.isVisible(idxGlobal),
                              backgroundColor: buttonColor,
                              // Change colour if chosen already
                              color: iconGroup.iconItems[idxGlobal].isChosen
                                  ? Colors.black26
                                  : Colors.black,
                              borderColor:
                                  iconGroup.iconItems[idxGlobal].borderColor,
                              onPressed: iconGroup.isActive(idxGlobal)
                                  ? () {
                                      onPressed(iconCore, idxGlobal);
                                      print(
                                          "Pressed ${iconGroup.iconItems[idxGlobal].codepoint}");
                                    }
                                  : null,
                            )
                          : Icon(
                              IconData(
                                iconGroup.iconItems[index].codepoint,
                                fontFamily: 'MaterialIcons',
                              ),
                            );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
