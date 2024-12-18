import 'dart:developer';

import 'package:flutter/material.dart';

class GameCardModel {
  final Color color;
  bool isFlipped;
  bool isMatched;
  int index;

  GameCardModel({
    required this.color,
    required this.index,
    this.isFlipped = false,
    this.isMatched = false,
  });

  void flip() {
    isFlipped = !isFlipped;
  }

  void match() {
    isMatched = true;
  }

  void unmatch() {
    isMatched = false;
  }

  void flippedBack() {
    log("Kaç kez çalışıyor", name: "FlippedBack");
    isFlipped = false;
  }
}
