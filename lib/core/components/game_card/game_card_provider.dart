import 'package:flutter/material.dart';
import 'package:memory_game_provider/core/model/game_card_model.dart';

class GameCardProvider with ChangeNotifier {
  Color isFlippedOrMatchedColor(GameCardModel gameCardModel) => gameCardModel.isMatched
      ? gameCardModel.color
      : gameCardModel.isFlipped
          ? gameCardModel.color
          : Colors.white;
}
