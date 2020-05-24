import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              ),
            ),
          ],
        ));
  }
}
