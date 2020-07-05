import 'package:flutter/material.dart';
import 'package:game_app/components/custom_buttons.dart';
import 'package:game_app/models/the_icon/icon_models.dart';

class TestingGround extends StatefulWidget {
  @override
  _TestingGroundState createState() => _TestingGroundState();
}

class _TestingGroundState extends State<TestingGround> {
  String state = "HELLO";
  IconList icList = IconList();
  IconGroup icGroup;
  int currCP = 59692;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Testing")),
      body: Column(
        children: <Widget>[
          Text(
            state,
            style: TextStyle(fontSize: 50),
          ),
          IconButton(
            icon: Icon(Icons.disc_full),
            onPressed: () async {
              await icList.loadIconInfo();
              icGroup =
                  IconGroup(codepoints: icList.getRandomCodepoints(n: 11));
              setState(() {
                state = "Ready";
              });
            },
          ),
          icGroup != null ? displayGroup(context, icGroup, true) : Container(),
        ],
      ),
      floatingActionButton: IconButton(
        icon: Icon(IconData(currCP, fontFamily: 'MaterialIcons')),
        onPressed: () {
          print("numicons: ${icList.length}");
          List<int> cc = icList.getRandomCodepoints(n: 3);
          print("${cc[0]}");
          setState(() {
            currCP = cc[0];
          });
        },
      ),
    );
  }
}

Widget displayGroup(BuildContext context, IconGroup iconGroup, bool isButton) {
  // TODO: tobe deleted
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
    iconGrid.last.add(iconGroup.iconItems[idx].codepoint);
  }

  return Padding(
    padding: const EdgeInsets.all(boardPadding),
    child: Container(
      height: 3 * iconSize * iconGrid.length,
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
                return MaterialIconButton(
                  codepoint: iconGrid[rowNum][index],
                  size: iconSize,
                  padding: iconPadding,
                  iconVisibility: iconGroup.isVisible(idxGlobal),
                  onPressed: true
                      ? () {
                          print("${iconGrid[rowNum][index]} preessed!");
                        }
                      : null,
                );
              },
            ),
          );
        },
      ),
    ),
  );
}
