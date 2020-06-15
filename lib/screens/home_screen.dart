import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:game_app/components/result_widgets.dart';
import 'package:game_app/models/constants.dart';
import 'package:game_app/services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Results processing ==============================
  // Done within the gameCards as stream and in the respective games

  // Building the home screen ====================================
  @override
  Widget build(BuildContext context) {
    print(
        "============= Currently in ${Constant.IS_DEBUG ? "DEBUG" : "RELEASE"} mode =============");
    print(
        ">>> Connected to the '${Constant.FIREBASE_COLLECTION_NAME}' firestore collection <<<");
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFF21BFBD),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 30.0),
              child: Text(
                "The Game",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "by The Hong",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 1.0),
                child: Text(
                  Constant.VERSION,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 10.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75.0),
                    ),
                    child: StreamBuilder(
                        stream: Firestore.instance
                            .collection(Constant.FIREBASE_COLLECTION_NAME)
                            .document(Constant.FIREBASE_CONTROL_DOCUMENT_NAME)
                            .snapshots(),
                        builder: (context, snapshot) {
                          Map gameCommands =
                              getGameControlFromSnapshot(snapshot);
                          return ListView(
                            children: <Widget>[
                              // NOTE: DON'T FORGET TO ADD ANY NEW GAMES TO THE constants.dart file
                              gameCard(
                                name: "The Pitch",
                                subtitle: "Practice perfect pitch",
                                icon: Icons.music_note,
                                routeStr: '/the_pitch',
                                numDecPlaces: 3,
                                colorGradient: [
                                  Colors.blue[200],
                                  Colors.blue[100]
                                ],
                                gameCommands: gameCommands["The Pitch"],
                              ),
                              gameCard(
                                name: "The Trill",
                                subtitle: "How fast can you trill?",
                                icon: Icons.autorenew,
                                routeStr: '/the_trill',
                                numDecPlaces: 0,
                                colorGradient: [
                                  Colors.green[200],
                                  Colors.green[100]
                                ],
                                gameCommands: gameCommands["The Trill"],
                              ),
                              gameCard(
                                name: "The Icon",
                                subtitle: "What would you like to order?",
                                icon: MaterialCommunityIcons.face,
                                routeStr: '/the_icon',
                                numDecPlaces: 0,
                                colorGradient: [
                                  Colors.red[200],
                                  Colors.red[100]
                                ],
                                gameCommands: gameCommands["The Icon"],
                              ),
                              gameCard(
                                name: "The Icons",
                                subtitle: "The Icon . . . but more",
                                icon: MaterialCommunityIcons.face_outline,
                                routeStr: '/waiting_screen',
                                numDecPlaces: 0,
                                colorGradient: [
                                  Colors.red[300],
                                  Colors.purple[200]
                                ],
                                gameCommands: gameCommands["The Icons"],
                              ),
                              gameCard(
                                name: "The Sign",
                                subtitle: "Coming Soon",
                                icon: FontAwesome.sign_language,
                                routeStr: '/waiting_page',
                                numDecPlaces: 0,
                                colorGradient: [
                                  Colors.purple[200],
                                  Colors.purple[100]
                                ],
                                gameCommands: gameCommands["The Sign"],
                              ),
                              gameCard(
                                name: "The Bored",
                                subtitle: "Coming Soon",
                                icon: Icons.nature_people,
                                routeStr: Constant.IS_DEBUG
                                    ? '/testing_ground'
                                    : '/waiting_page',
                                numDecPlaces: 0,
                                colorGradient: [
                                  Colors.lime[200],
                                  Colors.lime[100]
                                ],
                                gameCommands: gameCommands["The Bored"],
                              ),
                              // NOTE: DON'T FORGET TO ADD ANY NEW GAMES TO THE constants.dart file
                              Visibility(
                                visible:
                                    Constant.IS_DEBUG || Constant.IS_DEVELOPER,
                                child: gameCard(
                                  name: "Developer's Suite",
                                  subtitle: "For developers",
                                  icon: Icons.android,
                                  routeStr: '/developers_screen',
                                  numDecPlaces: 0,
                                  colorGradient: [
                                    Colors.blueGrey[200],
                                    Colors.blueGrey[100]
                                  ],
                                  gameCommands:
                                      Constant.FIREBASE_GAME_FULL_ACCESS,
                                ),
                              ),
                            ],
                          );
                        }),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget gameCard(
      {String name,
      String subtitle,
      IconData icon,
      String routeStr,
      int numDecPlaces,
      List<Color> colorGradient,
      Map<String, bool> gameCommands}) {
    assert(
      gameCommands != null,
      "Check if '$name' is included in Constants.GAMES",
    );
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: GestureDetector(
          onTap: () {
            if (_evaluateWithFalseSnackbar(
              context: context,
              condition:
                  gameCommands[Constant.FIREBASE_CONTROL_GAME_ACTIVATED_KEY],
              text: "Game is currently unavailable",
              seconds: 2,
            )) Navigator.pushNamed(context, routeStr);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              gradient: LinearGradient(colors: colorGradient),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(width: 20.0),
                Icon(
                  icon,
                  size: 50.0,
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(fontSize: 30.0),
                            ),
                          ),
                          Visibility(
                            // Only warn if game is activated but result updates are not
                            visible: !gameCommands[Constant
                                    .FIREBASE_CONTROL_RESULTS_ACTIVATED_KEY] &&
                                gameCommands[Constant
                                    .FIREBASE_CONTROL_GAME_ACTIVATED_KEY],
                            child: GestureDetector(
                              child: Icon(Icons.error,
                                  color: Colors.red, size: 30),
                              onTap: () {
                                _evaluateWithFalseSnackbar(
                                    context: context,
                                    condition: false,
                                    text: "Game can still be played, but result update" +
                                        " with leaderboard is currently unavailable.",
                                    seconds: 4);
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0, bottom: 3.0),
                        child: Text(
                          subtitle,
                          style:
                              TextStyle(fontSize: 15.0, color: Colors.black26),
                        ),
                      ),
                      // Row(
                      //   children: <Widget>[
                      //     // This does not take into account more than 3 players on podium
                      //     // Nor does it take into account there is less than 3 players
                      //     getSmallMedalResultItem(1, results[0]),
                      //     getSmallMedalResultItem(2, results[1]),
                      //     getSmallMedalResultItem(3, results[2]),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.list),
                      onPressed: () {
                        _showQuickResults(context, name, numDecPlaces);
                        // _showQuickResultsFromResults(context, results, numDecPlaces);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      color: gameCommands[
                              Constant.FIREBASE_CONTROL_GAME_ACTIVATED_KEY]
                          ? Colors.black
                          : Colors.black26,
                      onPressed: () {
                        if (_evaluateWithFalseSnackbar(
                          context: context,
                          condition: gameCommands[
                              Constant.FIREBASE_CONTROL_GAME_ACTIVATED_KEY],
                          text: "Game is currently unavailable",
                          seconds: 2,
                        )) Navigator.pushNamed(context, routeStr);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool _evaluateWithFalseSnackbar(
    {BuildContext context, bool condition, String text, int seconds}) {
  if (condition) {
    return true;
  } else {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text, style: TextStyle(fontSize: 15.0)),
      duration: Duration(seconds: seconds),
    ));
    return false;
  }
}

void _showQuickResults(BuildContext context, String game, int numDecPlaces) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text("Results ($game)", style: TextStyle(fontSize: 20)),
      children: [
        Container(
          width: 300,
          height: 300,
          child: homeResultsStreamer(context, game, numDecPlaces),
        ),
      ],
    ),
  );
}

// void _showQuickResultsFromResults(
//     BuildContext context, List<Result> results, int numDecPlaces) {
//   List<int> ranking = getRanking(results);
//   showDialog(
//     context: context,
//     builder: (context) => SimpleDialog(
//       title: Text(
//           results.isNotEmpty
//               ? "Results (${results[0].game})"
//               : "No records yet!",
//           style: TextStyle(fontSize: 20)),
//       children: [
//         Visibility(
//           visible: results.isNotEmpty,
//           child: Container(
//             width: 300,
//             height: 300,
//             child: ListView.builder(
//                 // Put stream
//                 scrollDirection: Axis.vertical,
//                 itemCount: results.length,
//                 itemBuilder: (context, index) {
//                   return getResultItem(
//                     rank: ranking[index],
//                     index: index,
//                     result: results[index],
//                     numDecPlaces: numDecPlaces,
//                   );
//                 }),
//           ),
//         ),
//       ],
//     ),
//   );
// }
