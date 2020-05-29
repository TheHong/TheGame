import 'dart:math';

import 'package:flutter/material.dart';

Widget progressBar({
  double score,
  List<double> centerCoords,
  double height,
  double length,
  List<double> checkpoints,
  int numDecPlaces,
}) {
  // Regarding checkpoints.
  // They are of the following form: [lowest leaderboard score, bronze score, silver score, gold score]. 
  // ^ For example, if the leaderboard is currently [8, 9, 11, 12, 13], then checkpoints is [8, 11, 12, 13].
  // Put -1 if does not exist due to a tie. 
  // ^ For example, if the leaderboard is currently [8, 9, 11, 13, 13], then checkpoints is [8, 11, -1, 13].
  // Put a 0 if does not exist due to not enough entries
  // ^ For example, if the leaderboard is currently [8, 9], then checkpoints is [0, 0, 8, 9].

  assert (checkpoints.length == 4, "There must be 4 checkpoints.");
  assert (checkpoints.last != -1, "Invalid checkpoints list. There must always be at least one gold.");


  return CustomPaint(
    foregroundPainter: ProgressBarPainter(
      score: score,
      centerCoords: centerCoords,
      height: height,
      length: length,
      checkpoints: checkpoints,
      numDecPlaces: numDecPlaces,
    ),
  );
}

class ProgressBarPainter extends CustomPainter {
  Color barColour = Colors.black;
  List<LinearGradient> progressGradients = [
    LinearGradient(colors: [Colors.blueGrey, Colors.blueGrey]), // Below leaderboard
    LinearGradient(colors: [Colors.green, Colors.green]), // On leaderboard
    LinearGradient(colors: [Colors.brown, Colors.amber[900]]), // Bronze
    LinearGradient(colors: [Colors.grey[700], Colors.blueGrey[100]]), // Silver
    LinearGradient(
        colors: [Colors.amberAccent[700], Colors.amberAccent]), // Gold
  ];
  double _barThicknessFactor = 0.25; // relative to height

  List<double> centerCoords; // [horizontal, vertical] from top
  double score;
  double height;
  double length;
  List<double> checkpoints;
  int numDecPlaces;

  ProgressBarPainter({
    this.score,
    this.centerCoords,
    this.height,
    this.length,
    this.checkpoints,
    this.numDecPlaces,
  });

  getRectPaint(LinearGradient gradient, Rect rect, bool isFill) {
    return Paint()
      ..strokeCap = StrokeCap.butt
      ..style = isFill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = isFill ? 0 : rect.height * _barThicknessFactor
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
    int progressIndex = 1 +
        checkpoints.lastIndexWhere((chkpt) => chkpt != -1 && score >= chkpt);

    List<double> topLeftCoords = [
      centerCoords[0] - length / 2,
      centerCoords[1] - height / 2
    ];

    // Forming the rectangles to be painted
    Rect bar =
        Rect.fromCenter(center: Offset(0, 0), width: length, height: height);
    Rect progress = Rect.fromLTWH(
      topLeftCoords[0] + barThickness,
      topLeftCoords[1] + barThickness,
      progressLength,
      height - 2 * barThickness,
    );

    // Getting the paint based on the progress and rectangles
    Paint barPaint = getRectPaint(
        LinearGradient(colors: [barColour, barColour]), bar, false);
    Paint progressPaint =
        getRectPaint(progressGradients[progressIndex], progress, true);

    // Draw bar
    canvas.drawRect(bar, barPaint);
    canvas.drawRect(progress, progressPaint);

    // Draw markers
    double vertCoord = topLeftCoords[1] - 5;
    for (int i = 0; i < checkpoints.length; i++) {
      double chkpt = checkpoints[i];
      if (chkpt == -1)
        continue; // If a checkpoint does not exist because of a tie
      double horiCoord = topLeftCoords[0] +
          barThickness +
          maxProgressLength * chkpt / checkpoints.last;
      canvas.drawLine(
        Offset(horiCoord, vertCoord),
        Offset(horiCoord, vertCoord - 10),
        getLinePaint(progressGradients[i + 1].colors[0]),
      );
    }
    // Draw current number of taps
    TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: "${score.toStringAsFixed(numDecPlaces)}",
          style: TextStyle(color: Colors.black87),
        ),
        textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(topLeftCoords[0] + progressLength,
            topLeftCoords[1] + barThickness + height));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
