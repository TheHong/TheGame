import 'package:flutter/material.dart';
import 'package:game_app/models/game_core.dart';

Widget UpdatorBackButton(BuildContext context, GameCore gameCore) =>
    gameCore.isGameDone
        ? Container()
        : BackButton(
            onPressed: () {
              if (gameCore.isGameDone)
                gameCore.databaseService.updateStats(gameCore.getGameName());
              Navigator.pop(context);
            },
          );
