import 'package:flutter/material.dart';
import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/models/the_icon/icon_core.dart';
import 'package:game_app/models/the_icon/icon_models.dart';
import 'package:provider/provider.dart';

class Group extends StatelessWidget {
  final IconGroup iconGroup;
  final bool isButton;
  Group({
    @required this.iconGroup,
    @required this.isButton,
  });

  @override
  Widget build(BuildContext context) {
    const double boardPadding = 10;
    const double iconPadding = 8;
    const int numIconsPerRow = 10;
    Size screen = MediaQuery.of(context).size;
    double iconSize =
        (screen.width - 2 * boardPadding - 2 * numIconsPerRow * iconPadding) /
            numIconsPerRow;

    // Split icons into rows
    List<List<int>> iconGrid = [];
    for (int idx = 0; idx < iconGroup.length; idx++) {
      if (idx % numIconsPerRow == 0) iconGrid.add([]);
      iconGrid.last.add(iconGroup.codepoints[idx]);
    }

    return Consumer<TheIconCore>(builder: (context, iconCore, child) {
      return Padding(
        padding: const EdgeInsets.all(boardPadding),
        child: Container(
          height: iconSize * 2 * iconGrid.length,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: iconGrid.length,
            itemBuilder: (context, rowNum) {
              return Container(
                height: iconSize * 2,
                color: Colors.red[50],
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
                            onPressed: iconGroup.isActive(idxGlobal)
                                ? () {
                                    print(
                                        "${iconGrid[rowNum][index]} preessed!");
                                    iconGroup.deactivate(idxGlobal);
                                  }
                                : null,
                          )
                        : Icon(
                            IconData(
                              iconGroup.codepoints[index],
                              fontFamily: 'MaterialIcons',
                            ),
                          );
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
