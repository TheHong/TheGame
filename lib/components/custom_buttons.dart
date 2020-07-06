import 'package:flutter/material.dart';
import 'package:game_app/components/common_widgets.dart';
import 'package:game_app/models/game_core.dart';

class OneShotButton extends StatelessWidget {
  // This button prevents double clicks
  final Widget child;
  final VoidCallback onPressed;
  final Color color;
  final Color disabledColor;
  final Color disabledTextColor;
  final EdgeInsets padding;

  bool _isPressed = false;

  OneShotButton({
    @required this.child,
    @required this.onPressed,
    this.color = Colors.black,
    this.disabledColor = Colors.black26,
    this.disabledTextColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: child,
      padding: padding,
      color: color,
      disabledTextColor: disabledTextColor,
      disabledColor: disabledColor,
      onPressed: onPressed == null
          ? null
          : () {
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
        if (!gameCore.isGameDone)
          confirmedExit(context);
        else
          Navigator.pop(context);
      },
    );

class MaterialIconButton extends StatelessWidget {
  /// Button consists of a icon, where the pressable region consists of the
  /// button and the immediate area around the button

  final int codepoint; // Codepoint defining the icon to use
  final VoidCallback onPressed; // Set to null to disable
  final double padding; // Padding between button and borders of press region
  final double size; // Diameter of the button
  final Color color; // Colour of the icon
  final Color disabledColor; // Colour of the icon when button is disabled
  final Color borderColor; // Colour of the border around the button
  final Color backgroundColor; // Colour of the background surrounding the icon
  final bool iconVisibility; // Whether or not icon is visible

  const MaterialIconButton({
    @required this.codepoint,
    @required this.onPressed,
    @required this.size,
    this.padding = 8.0,
    this.color = Colors.black,
    this.disabledColor = Colors.black26,
    this.borderColor = Colors.transparent,
    this.backgroundColor = Colors.transparent,
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
