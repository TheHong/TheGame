import 'package:flutter/material.dart';

void getExitConfirmation(BuildContext context) {
  BuildContext prevContext = context;
  showDialog(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Ensuring compactness
                    children: <Widget>[
                      Text(
                        "Are you sure you want to leave?",
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          children: <Widget>[
                            FlatButton(
                              child: Text("Yes"),
                              onPressed: () {
                                Navigator.pop(prevContext);
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text("No"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ));
}
