import 'dart:math';

import 'package:flutter/material.dart';

class ProgressBar extends CustomPainter {
  Color barColour = Colors.black;
  List<LinearGradient> progressGradients = [
    LinearGradient(colors: [Colors.purple, Colors.purple]), // Below leaderboard
    LinearGradient(colors: [Colors.green, Colors.green]), // On leaderboard
    LinearGradient(colors: [Colors.brown, Colors.amber[900]]), // Bronze
    LinearGradient(colors: [Colors.grey[700], Colors.blueGrey[100]]), // Silver
    LinearGradient(
        colors: [Colors.amberAccent[700], Colors.amberAccent]), // Gold
  ];
  double _barThicknessFactor = 0.25; // relative to height

  List<double> topLeftCoords; // [horizontal, vertical] from top
  double score;
  double height;
  double length;
  List<double>
      checkpoints; // [lowest leaderboard score, bronze score, silver score, gold score]

  ProgressBar({
    this.score,
    this.topLeftCoords,
    this.height,
    this.length,
    this.checkpoints,
  });

  getRectPaint(LinearGradient gradient, Rect rect) {
    return Paint()
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(rect);
  }

  getLinePaint(Color color) {
    return Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Get progress information
    double barThickness = height * _barThicknessFactor;
    double maxProgressLength = length - 2 * barThickness;
    double fractionComplete = score / checkpoints.last;
    double progressLength =
        min(maxProgressLength, maxProgressLength * fractionComplete);
    int progressIndex =
        1 + checkpoints.lastIndexWhere((chkpt) => score >= chkpt);

    // Forming the rectangles to be painted
    Rect bar =
        Rect.fromLTWH(topLeftCoords[0], topLeftCoords[1], length, height);
    Rect progress = Rect.fromLTWH(
      topLeftCoords[0] + barThickness,
      topLeftCoords[1] + barThickness,
      progressLength,
      height - 2 * barThickness,
    );

    // Getting the paint based on the progress and rectangles
    Paint barPaint =
        getRectPaint(LinearGradient(colors: [barColour, barColour]), bar);
    Paint progressPaint =
        getRectPaint(progressGradients[progressIndex], progress);

    // Draw bar
    canvas.drawRect(bar, barPaint);
    canvas.drawRect(progress, progressPaint);

    // Draw markers
    double vertCoord = topLeftCoords[1] + height + 5;
    for (int i = 0; i < checkpoints.length; i++) {
      double chkpt = checkpoints[i];
      double horiCoord = topLeftCoords[0] +
          barThickness +
          maxProgressLength * chkpt / checkpoints.last;
      canvas.drawLine(
        Offset(horiCoord, vertCoord),
        Offset(horiCoord, vertCoord + 10),
        getLinePaint(progressGradients[i + 1].colors[1]),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
