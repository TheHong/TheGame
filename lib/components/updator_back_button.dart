import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';

Widget UpdatorBackButton(BuildContext context, GameCore gameCore) => BackButton(
      onPressed: () {
        if (gameCore.isGameDone && !gameCore.isStatsUpdated && gameCore.isResultsActivated) {
          gameCore.databaseService.updateStats(gameCore.getGameName());
          gameCore.isStatsUpdated = true;
        }
        Navigator.pop(context);
      },
    );
