import 'package:flutter/material.dart';
import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:game_app/models/the_icon/icon_models.dart';
import 'package:provider/provider.dart';

class Group extends StatelessWidget {
  /// A Group object displays an IconGroup.

  final IconGroup iconGroup; // IconGroup to be displayed
  final Function onPressed;
  final double height;
  final EdgeInsets groupMargins;
  final EdgeInsets groupPadding;
  final double iconPadding; // Padding between icon and the pressable region
  final Color groupColor; // Background colour of the group
  final Color buttonColor; // Background colour of the buttons
  final Color iconColor; // Colour of the button icons
  final Color disabledIconColor; // Colour of the button icons when disabled
  final Color chosenIconColor; // Background colour of button icon when chosen
  final int numIconsPerRow;
  final double curveRadius; // Curve radius of the group

  Group({
    @required this.iconGroup,
    this.onPressed,
    this.height,
    this.groupMargins = EdgeInsets.zero,
    this.groupPadding = EdgeInsets.zero,
    this.iconPadding = 8,
    this.groupColor = Colors.transparent,
    this.buttonColor,
    this.iconColor = Colors.black,
    this.disabledIconColor = Colors.black12,
    this.chosenIconColor = Colors.black26,
    this.numIconsPerRow = 10,
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
              // Building a row
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: iconGrid.length,
              itemBuilder: (context, rowNum) {
                return Container(
                  height: iconSize * 2,
                  child: ListView.builder(
                    // Building within a row (alternates between icon item and sizedbox)
                    scrollDirection: Axis.horizontal,
                    itemCount: iconGrid[rowNum].length * 2 - 1,
                    itemBuilder: (context, index) {
                      int iconIdx = index ~/ 2;
                      int idxGlobal = rowNum * numIconsPerRow + iconIdx;
                      return index % 2 == 1
                          ? MaterialIconButton(
                              codepoint: iconGrid[rowNum][iconIdx],
                              size: iconSize,
                              padding: iconPadding,
                              iconVisibility: iconGroup.isVisible(idxGlobal),
                              backgroundColor: buttonColor,
                              disabledColor: disabledIconColor,
                              // Change colour if chosen already
                              color: iconGroup.iconItems[idxGlobal].isChosen
                                  ? chosenIconColor
                                  : iconColor,
                              borderColor:
                                  iconGroup.iconItems[idxGlobal].borderColor,
                              onPressed: iconCore.phase == Phase.RECALL
                                  ? () {
                                      onPressed(iconCore, idxGlobal);
                                      print(
                                          "Pressed ${iconGroup.iconItems[idxGlobal].codepoint}");
                                    }
                                  : null,
                            )
                          : SizedBox(width: 25);
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
