import 'dart:developer' as d;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memory_game_provider/core/extension/color_extension.dart';

import '../../core/model/game_card_model.dart';

class MainGameProvider with ChangeNotifier {
  //?  STATES
  TurnState turnState = TurnState.ali;
  GameCardState gameCardState = GameCardState.idle;
  //? SCORES
  int scoreAli = 0;
  int scoreSebnem = 0;
  Color backgroundColorForTurnState = Colors.blue.shade100;
  late List<Color> colors;
  late List<int> colorIndexes;
  late List<GameCardModel> gameCards;
  int duration = 500;
  bool isGameOver = false;
  String winner = '';

  MainGameProvider() {
    initialState();
  }

  initialState() {
    _generateGameCards();
    notifyListeners();
  }

  void _generateGameCards() {
    colors = List.generate(12, (index) => randomColor());
    colors.addAll([...colors]);
    colorIndexes = List.generate(colors.length, (index) => index);
    gameCards = colorIndexes.map((index) => GameCardModel(color: colors[index], index: index)).toList();
    gameCards.shuffle();
  }

  void flip(GameCardModel gameCardModel) async {
    d.log(gameCardState.name);
    switch (gameCardState) {
      case GameCardState.idle:
        _flipFirstCard(gameCardModel);
        break;
      case GameCardState.firstCardFlipped:
        _flipSecondCard(gameCardModel);
        break;
      case GameCardState.secondCardFlipped:
        // imposible case
        break;
    }
  }

  void _flipFirstCard(GameCardModel gameCardModel) {
    gameCards.where((element) => element.index == gameCardModel.index).forEach((element) => element.flip());
    gameCardState = GameCardState.firstCardFlipped;
    notifyListeners();
  }

  void checkGameOver() {
    if (gameCards.every((card) => card.isMatched)) {
      isGameOver = true;
      winner = scoreAli > scoreSebnem
          ? "Winner : Ali"
          : scoreAli == scoreSebnem
              ? "Draw"
              : "Winner : Şebnem";
      notifyListeners();
    }
  }

  Future<void> _flipSecondCard(GameCardModel gameCardModel) async {
    gameCards.where((element) => element.index == gameCardModel.index).forEach((element) => element.flip());
    if (gameCards.where((element) => element.isFlipped).where((element) => gameCardModel.color == element.color).length % 2 == 0) {
      gameCards.where((element) => element.isFlipped).where((element) => gameCardModel.color == element.color).forEach((e) {
        duration = 0;
        e.match();
      });
      turnState == TurnState.ali ? scoreAli++ : scoreSebnem++;
      checkGameOver();
    } else {
      duration = 500;
      turnState = turnState.next;
      _changeBackgrounColorForTurnState();
    }
    gameCardState = GameCardState.secondCardFlipped;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: duration));
    gameCards.where((element) => !element.isMatched).toList().forEach((e) => e.flippedBack());
    gameCardState = GameCardState.idle;
    notifyListeners();
  }

  void changeTurnState() {
    turnState = turnState.next;
    _changeBackgrounColorForTurnState();
    notifyListeners();
  }

  void _changeBackgrounColorForTurnState() {
    backgroundColorForTurnState = turnState == TurnState.ali ? Colors.blue.shade100 : Colors.red.shade100;
  }

  void resetGame() {
    scoreAli = 0;
    scoreSebnem = 0;
    gameCardState = GameCardState.idle;
    _generateGameCards();
    _randomTurnState();
    isGameOver = false;
    notifyListeners();
  }

  void _randomTurnState() {
    turnState = turnState.random;
    _changeBackgrounColorForTurnState();
    notifyListeners();
  }
}

Color randomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

enum TurnState {
  ali,
  sebnem,
}

enum GameCardState {
  idle,
  firstCardFlipped,
  secondCardFlipped,
}

extension TurnStateExtension on TurnState {
  TurnState get next => this == TurnState.ali ? TurnState.sebnem : TurnState.ali;
  TurnState get random => Random().nextBool() ? TurnState.ali : TurnState.sebnem;
}
