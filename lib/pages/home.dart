import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool pressed=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () {
              setState(() {
                pressed=!pressed;
              });
            },
            color: pressed?Colors.red:Colors.blue,
          ),
          SizedBox(width: 20.0,),
          IconButton(
            icon: Icon(Icons.account_balance),
            onPressed: () {},
          ),
        ],
      ),
    ));
  }
}
