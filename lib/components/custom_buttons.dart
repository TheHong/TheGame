import 'package:flutter/material.dart';

class MaterialIconButton extends StatelessWidget {
  final int codepoint;
  final double padding;
  final double size;
  final VoidCallback onPressed;
  final Color color;
  final Color disabledColor;

  const MaterialIconButton({
    @required this.codepoint,
    @required this.size,
    @required this.onPressed,
    this.color = Colors.black,
    this.disabledColor = Colors.black26,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          width: size + 2 * padding,
          height: size + 2 * padding,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black12,
          ),
          child: Icon(
            IconData(codepoint, fontFamily: 'MaterialIcons'),
            size: size,
            color: onPressed != null ? color : disabledColor,
          ),
        ),
        onTap: onPressed,
      );
}
