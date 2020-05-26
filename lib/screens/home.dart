import 'package:flutter/material.dart';
import 'package:game_app/components/result_widgets.dart';
import 'package:game_app/models/user.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// TODO: Navigation-related (disable back, pop off pages)
class _HomeState extends State<Home> {
  // Results processing ==============================
  // These results to be replaced later by data from a database
  List<Result> ppResults = getSampleResults();

  // Building the home screen ====================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Text(
              "by The Hong",
              style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white,
                fontSize: 25.0,
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
                  child: ListView(
                    children: <Widget>[
                      gameCard(
                        name: "The Pitch",
                        subtitle: "Practice perfect pitch",
                        icon: Icons.music_note,
                        routeStr: '/the_pitch',
                        results: ppResults,
                        colorGradient: [Colors.blue[200], Colors.blue[100]],
                      ),
                      gameCard(
                        name: "The Trill",
                        subtitle: "How fast can you trill?",
                        icon: Icons.autorenew,
                        routeStr: '/the_trill',
                        results: ppResults,
                        colorGradient: [Colors.green[200], Colors.green[100]],
                      ),
                      gameCard(
                        name: "The Icon",
                        subtitle: "Coming Soon",
                        icon: Icons.face,
                        routeStr: '/waiting_page',
                        results: ppResults,
                        colorGradient: [Colors.red[200], Colors.red[100]],
                      ),
                      gameCard(
                        name: "The Bored",
                        subtitle: "Coming Soon",
                        icon: Icons.nature_people,
                        routeStr: '/waiting_page',
                        results: ppResults,
                        colorGradient: [Colors.lime[200], Colors.lime[100]],
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget gameCard(
      {String name,
      String subtitle,
      IconData icon,
      String routeStr,
      List<Result> results,
      List<Color> colorGradient}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                  Text(
                    name,
                    style: TextStyle(fontSize: 30.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0, bottom: 3.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(fontSize: 15.0, color: Colors.black26),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      getSmallMedalResultItem(1, results[0]),
                      getSmallMedalResultItem(2, results[1]),
                      getSmallMedalResultItem(3, results[2]),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () {
                    _showQuickResults(context, results);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.pushNamed(context, routeStr);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showQuickResults(BuildContext context, List<Result> results) {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text("Historical Results (${results[0].game})",
          style: TextStyle(fontSize: 20)),
      children: [
        Container(
          width: 300,
          height: 300,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: results.length,
              itemBuilder: (context, index) {
                return getResultItem(index + 1, results[index]);
              }),
        ),
      ],
    ),
  );
}
