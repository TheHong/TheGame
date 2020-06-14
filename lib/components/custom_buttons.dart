import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';

class OneShotButton extends StatelessWidget {
  // This button prevents double clicks
  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  final Color disabledColor;

  bool _isPressed = false;

  OneShotButton({
    @required this.child,
    @required this.onPressed,
    this.color = Colors.black,
    this.disabledColor = Colors.black26,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: child,
      color: color,
      disabledColor: disabledColor,
      onPressed: () {
        if (!_isPressed) {
          _isPressed = true;
          onPressed();
        } else {
          print("Detected double press");
        }
      },
    );
  }
}

Widget getUpdatorBackButton(BuildContext context, GameCore gameCore) =>
    BackButton(
      onPressed: () {
        if (gameCore.isGameDone &&
            !gameCore.isStatsUpdated &&
            gameCore.isResultsActivated) {
          gameCore.databaseService.updateStats(gameCore.getGameName());
          gameCore.isStatsUpdated = true;
        }
        Navigator.pop(context);
      },
    );

class MaterialIconButton extends StatelessWidget {
  final int codepoint;
  final double padding;
  final double size;
  final VoidCallback onPressed;
  final Color color;
  final Color disabledColor;
  final Color borderColor;
  final bool iconVisibility;
  final Color backgroundColor = Colors.black12;

  const MaterialIconButton({
    @required this.codepoint,
    @required this.size,
    @required this.onPressed,
    this.color = Colors.black,
    this.disabledColor = Colors.black26,
    this.borderColor = Colors.transparent,
    this.padding = 8.0,
    this.iconVisibility = true,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          width: size + 2 * padding,
          height: size + 2 * padding,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              border: Border.all(
                width: 3,
                color: borderColor,
                style: BorderStyle.solid,
              )),
          child: Visibility(
            visible: iconVisibility,
            child: Icon(
              IconData(codepoint, fontFamily: 'MaterialIcons'),
              size: size,
              color: onPressed != null ? color : disabledColor,
            ),
          ),
        ),
        onTap: onPressed,
      );
}
