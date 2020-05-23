import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:game_app/models/game_info.dart';
import 'package:provider/provider.dart';

class WaitingPage extends StatefulWidget {
  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameInfo>(builder: (context, gameInfo, child) {
      return Scaffold(
          backgroundColor: Colors.blue[900],
          body: Center(
            child: SpinKitPouringHourglass(
              // https://pub.dev/packages/flutter_spinkit
              color: Colors.white,
              size: 100.0,
            ),
          ));
    });
  }
}
